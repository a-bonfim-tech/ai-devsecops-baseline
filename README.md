# DevSecOps Baseline

[![devsecops-gates](https://github.com/a-bonfim-tech/ai-devsecops-baseline/workflows/devsecops-gates/badge.svg)](https://github.com/a-bonfim-tech/ai-devsecops-baseline/actions/workflows/devsecops.yml)

This repository provides a practical DevSecOps baseline aligned with Google Cloud security best practices.

It demonstrates automated security gates that can support pull-request review,
branch protection, and audit evidence when combined with GitHub repository
rulesets.

Automated security gates are implemented using GitHub Actions, including:

* Supply chain security with SBOM generation
* Vulnerability scanning (high/critical enforcement)
* Secrets detection
* Policy-as-Code validation

All security controls are enforced before code can be merged into production branches.

Evidence artifacts are generated on each run to support auditability and compliance.

This repository is intended for learning, validation, and certification-oriented use.

## Methodology

The pipeline architecture, data flow, security gates, evidence artifacts,
failure points, and maintenance requirements are documented in
[docs/methodology.md](docs/methodology.md).

## Security and License

Security scope, safe reporting expectations, and triage handling are documented
in [SECURITY.md](SECURITY.md).

This repository is licensed under the Apache License 2.0. See [LICENSE](LICENSE).
