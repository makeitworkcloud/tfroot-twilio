# Agent Instructions

OpenTofu root for Make IT Work Cloud Twilio control-plane infrastructure.

This root owns only Twilio phone-number inventory and inbound messaging-webhook configuration. It must not own the OpenCode SMS bridge workload, Cloudflare workload route or DNS, number-to-agent mapping, approved-source allowlist, bridge credentials, or runtime encryption material. Those runtime concerns belong to `kustomize-cluster`.

This bootstrap contains no Twilio resources, provider configuration, backend credentials, encrypted secrets, state, or number identifiers. A separately approved future credential-delivery change may add only an encrypted Twilio provider environment file; it must never hold bridge runtime credentials or encryption material. Use GitHub MCP and pull-request CI plans as validation authority. `main` is an environment-gated apply path; use scoped branches and pull requests, never direct pushes. Do not run OpenTofu, SOPS, state, import, or apply commands from this server.

The shared workflow is owned by `shared-workflows`; the runner image and canonical pre-commit configuration are owned by `images/tfroot-runner`. Keep any future SOPS data encrypted and never expose credentials, decrypted values, state, private keys, or sensitive plans.
