# DevSecOps Baseline

This repository provides a practical DevSecOps baseline aligned with Google Cloud security best practices.

It enforces branch protection on the default branch and requires pull requests with approvals.

Automated security gates are implemented using GitHub Actions, including:

* Supply chain security with SBOM generation
* Vulnerability scanning (high/critical enforcement)
* Secrets detection
* Policy-as-Code validation

All security controls are enforced before code can be merged into production branches.

Evidence artifacts are generated on each run to support auditability and compliance.

This repository is intended for learning, validation, and certification-oriented use.
