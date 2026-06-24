# DevSecOps Baseline Methodology

## Objective

Document the security-gate methodology used by this repository so the pipeline
can be reviewed, reproduced, and improved without relying on implicit claims.

## Architecture

The baseline uses GitHub Actions as the orchestration layer and a shell script
as the repeatable local execution path.

Primary components:

- `.github/workflows/devsecops.yml`: GitHub Actions workflow.
- `scripts/run_pipeline.sh`: pipeline execution script.
- `scripts/mk_policy_input.sh`: policy input generator for required artifacts.
- `policies/*.rego`: OPA/Rego policy gates evaluated by Conftest.
- `outputs/*.json`: generated evidence artifacts uploaded by the workflow.

## Trigger Model

The workflow is configured to run on:

- Manual dispatch.
- Push.
- Pull request.
- Weekly schedule.

The scheduled run is configured in UTC in the GitHub Actions workflow.

## Data Flow

1. The workflow checks out the repository.
2. The workflow installs required command-line tools.
3. `scripts/run_pipeline.sh` creates local output and evidence directories.
4. Syft generates an SPDX JSON SBOM at `outputs/sbom.spdx.json`.
5. Grype scans the SBOM and writes `outputs/grype.json`.
6. Gitleaks scans for secrets and writes `outputs/gitleaks.json`.
7. Trivy performs a filesystem scan for high and critical findings and writes
   `outputs/trivy_fs.json`.
8. `scripts/mk_policy_input.sh` confirms required evidence artifacts exist.
9. Conftest evaluates OPA/Rego policies against generated inputs.
10. GitHub Actions uploads `outputs/*.json` as `devsecops-reports`.

## Security Gates

| Gate | Input | Policy intent | Build impact |
| --- | --- | --- | --- |
| Required artifacts | `tools/policy_input.json` | Fail if SBOM or Grype report is missing | Enforced |
| Vulnerability severity | `tools/grype_input.json` | Fail on High or Critical Grype findings | Enforced |
| Secret detection | `tools/gitleaks_input.json` | Fail if Gitleaks reports secrets | Enforced |
| Filesystem scan | `outputs/trivy_fs.json` | Produce additional vulnerability evidence | Informational by current script design |

## Evidence Collected

The pipeline produces:

- `outputs/sbom.spdx.json`
- `outputs/grype.json`
- `outputs/gitleaks.json`
- `outputs/trivy_fs.json`

During execution, copies are also written under `${HOME}/evidence/ai-devsecops`
to preserve a local evidence structure for environment, policy, SBOM,
vulnerability, and secrets outputs.

## Security Considerations

- Tool installation is performed at workflow runtime from upstream release or
  installer endpoints.
- Gitleaks output should be reviewed carefully before publishing artifacts, as
  secret-scanning reports can contain sensitive context.
- Trivy is currently informational because the script allows that step to
  continue even if findings are present.
- Branch protection is not enforced by the workflow itself. It must be
  configured in GitHub repository settings or rulesets.
- The baseline is a learning and validation artifact, not a complete production
  SDLC control framework.

## Failure Points

Common failure points include:

- Upstream tool download failure.
- Package or filesystem scan errors.
- High or Critical vulnerabilities in Grype output.
- Gitleaks findings.
- Missing generated artifacts.
- OPA/Rego policy incompatibility after input shape changes.

## Validation Steps

Reviewers can validate the baseline by checking:

1. The latest `devsecops-gates` workflow run conclusion.
2. Uploaded `devsecops-reports` artifacts.
3. Presence of `outputs/sbom.spdx.json`, `outputs/grype.json`, and
   `outputs/gitleaks.json` in a completed run.
4. Conftest output for each policy gate.
5. Whether branch protection or repository rulesets are configured separately
   in GitHub settings.

## Maintenance Requirements

- Pin security tool versions where possible.
- Review OPA/Rego policies after changing report formats.
- Review workflow permissions and artifact retention periodically.
- Keep `SECURITY.md` aligned with actual pipeline behavior.
- Treat failed scheduled runs as evidence requiring triage, not noise.
