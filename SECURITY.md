# Security Policy

## Scope

This repository is a learning and validation baseline for DevSecOps controls,
including GitHub Actions, SBOM generation, vulnerability scanning, secrets
detection, and OPA policy-as-code gates.

The repository is not a production control plane and does not authorize testing
against systems outside environments you own or are explicitly permitted to
assess.

## Supported Use

- Local security-control validation
- Portfolio demonstration
- Certification-oriented learning
- Policy-as-code experimentation
- Audit-friendly evidence generation

## Reporting a Concern

Open a GitHub issue if you find:

- Exposed credentials or sensitive tokens
- Unsafe default behavior
- Inaccurate security-control claims
- Broken validation logic
- A workflow result that contradicts the documented control intent

Do not post active credentials, private data, or exploit payloads against
third-party systems in public issues.

## Triage Process

Reports are handled in this order:

1. Preserve evidence of the report and affected file path.
2. Confirm whether the behavior is reproducible.
3. Determine whether the issue affects documentation, workflow behavior, or
   policy logic.
4. Apply the smallest corrective change.
5. Validate with the available pipeline or local scripts.
6. Document the correction in the relevant README or evidence file.
