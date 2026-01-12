#!/usr/bin/env bash
set -euo pipefail

EVD="${HOME}/evidence/ai-devsecops"
mkdir -p "$EVD"/{00_env,10_policy,20_sbom,30_vuln,40_secrets}
mkdir -p outputs

date -Iseconds | tee "$EVD/00_env/timestamp.txt" >/dev/null

# 1) SBOM
syft dir:. -o spdx-json > outputs/sbom.spdx.json
cp outputs/sbom.spdx.json "$EVD/20_sbom/sbom.spdx.json"

# 2) Vuln scan via SBOM
grype sbom:outputs/sbom.spdx.json -o json > outputs/grype.json
cp outputs/grype.json "$EVD/30_vuln/grype.json"

# 3) Secrets scan
gitleaks detect --report-format json --report-path outputs/gitleaks.json || true
cp outputs/gitleaks.json "$EVD/40_secrets/gitleaks.json" 2>/dev/null || true

# 4) FS scan complementar (Trivy)
trivy fs --format json --output outputs/trivy_fs.json . || true
cp outputs/trivy_fs.json "$EVD/30_vuln/trivy_fs.json" 2>/dev/null || true

# 5) Policy-as-Code gate (Conftest)
./scripts/mk_policy_input.sh > tools/policy_input.json
conftest test tools/policy_input.json -p policies \
  | tee "$EVD/10_policy/conftest.txt"

# 6) Inventário final dos artefatos
ls -lh outputs/* | tee "$EVD/00_env/outputs_list.txt"
