SHELL     := /bin/bash
TERRAFORM := $(shell which tofu)
S3_BUCKET := mitw-tf-twilio-infra
S3_REGION := us-west-2
S3_KEY    := tofu/twilio/terraform.tfstate
TWILIO_CREDENTIALS := secrets/secrets.yaml

.PHONY: clean init credentials-check plan apply test pre-commit-config pre-commit-check-deps pre-commit-install-hooks

clean:
	@find . -name .terraform -type d | xargs -r rm -rf

# tfroot-aws owns this private, versioned state bucket and the GitHub OIDC role
# that CI assumes. The backend needs no static AWS credentials.
init: clean
	@${TERRAFORM} init -reconfigure -upgrade -input=false \
		-backend-config="bucket=${S3_BUCKET}" \
		-backend-config="key=${S3_KEY}" \
		-backend-config="region=${S3_REGION}" \
		-backend-config="use_lockfile=true"

# The encrypted file is verified and exposed only to this short-lived child
# process. It does not configure the Twilio provider or call Twilio APIs.
credentials-check:
	@test -f "${TWILIO_CREDENTIALS}"
	@sops filestatus "${TWILIO_CREDENTIALS}" | jq -e '.encrypted == true' >/dev/null
	@sops exec-env "${TWILIO_CREDENTIALS}" 'test -n "$$TWILIO_ACCOUNT_SID" && test -n "$$TWILIO_API_KEY" && test -n "$$TWILIO_API_SECRET"'

plan: init credentials-check
	@${TERRAFORM} plan -refresh=false -input=false -compact-warnings

# There are intentionally no provider configurations or Twilio resources in
# this root, so backend selection and encrypted-credential validation are the
# only stateful behaviors on main.
apply: init credentials-check
	@${TERRAFORM} apply -auto-approve -refresh=false -input=false -compact-warnings

test: pre-commit-config pre-commit-install-hooks
	@pre-commit run -a

pre-commit-config:
	@curl --fail --silent --show-error --location \
		--output .pre-commit-config.yaml.tmp \
		https://raw.githubusercontent.com/makeitworkcloud/images/main/tfroot-runner/pre-commit-config.yaml
	@if cmp -s .pre-commit-config.yaml.tmp .pre-commit-config.yaml; then \
		rm -f .pre-commit-config.yaml.tmp; \
	else \
		mv .pre-commit-config.yaml.tmp .pre-commit-config.yaml; \
	fi

DEPS_PRE_COMMIT=$(shell which pre-commit || echo "pre-commit not found")
DEPS_TERRAFORM_DOCS=$(shell which terraform-docs || echo "terraform-docs not found")
DEPS_TFLINT=$(shell which tflint || echo "tflint not found")
DEPS_CHECKOV=$(shell which checkov || echo "checkov not found")
DEPS_JQ=$(shell which jq || echo "jq not found")
pre-commit-check-deps:
	@echo "Checking for pre-commit and its dependencies:"
	@echo "  pre-commit: ${DEPS_PRE_COMMIT}"
	@echo "  terraform-docs: ${DEPS_TERRAFORM_DOCS}"
	@echo "  tflint: ${DEPS_TFLINT}"
	@echo "  checkov: ${DEPS_CHECKOV}"
	@echo "  jq: ${DEPS_JQ}"
	@echo ""

pre-commit-install-hooks: pre-commit-config pre-commit-check-deps
	@pre-commit install --install-hooks --hook-type pre-commit --hook-type commit-msg
