#!/usr/bin/env bash
set -euo pipefail

repo_has_outputs=true
sbom_present=false
grype_present=false

[[ -f outputs/sbom.spdx.json ]] && sbom_present=true
[[ -f outputs/grype.json ]] && grype_present=true

cat <<JSON
{
  "repo_has_outputs": ${repo_has_outputs},
  "sbom_present": ${sbom_present},
  "grype_present": ${grype_present}
}
JSON
