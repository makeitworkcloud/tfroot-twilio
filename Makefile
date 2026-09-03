SHELL     := /bin/bash
TERRAFORM := $(shell which tofu)

.PHONY: clean init plan apply test pre-commit-config pre-commit-check-deps pre-commit-install-hooks

clean:
	@find . -name .terraform -type d | xargs -r rm -rf

# Bootstrap deliberately uses no remote backend until the encrypted backend
# contract and least-privilege CI access are established in a later PR.
init: clean
	@${TERRAFORM} init -backend=false -upgrade -input=false

plan: init
	@${TERRAFORM} plan -refresh=false -input=false -lock=false -compact-warnings

# There are intentionally no provider configurations or Twilio resources in
# this bootstrap, so the main-branch apply has no provider-side effect.
apply: init
	@${TERRAFORM} apply -auto-approve -refresh=false -input=false -lock=false -compact-warnings

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
