#!/usr/bin/env bash
set -euo pipefail

EVD="${HOME}/evidence/ai-devsecops"
mkdir -p "$EVD"/{00_env,10_policy,20_sbom,30_vuln,40_secrets}
mkdir -p outputs tools

date -Iseconds | tee "$EVD/00_env/timestamp.txt" >/dev/null

# 1) SBOM
syft dir:. -o spdx-json > outputs/sbom.spdx.json
cp outputs/sbom.spdx.json "$EVD/20_sbom/sbom.spdx.json"

# 2) Vulnerabilities (from SBOM)
grype sbom:outputs/sbom.spdx.json -o json > outputs/grype.json
cp outputs/grype.json "$EVD/30_vuln/grype.json"

# 3) Secrets
gitleaks detect --report-format json --report-path outputs/gitleaks.json
cp outputs/gitleaks.json "$EVD/40_secrets/gitleaks.json"

# 4) FS scan (optional but useful). If you want it to fail build, remove "|| true".
trivy fs --severity HIGH,CRITICAL --ignore-unfixed --format json --output outputs/trivy_fs.json . || true
cp outputs/trivy_fs.json "$EVD/30_vuln/trivy_fs.json" 2>/dev/null || true

# --- Gates (Policy-as-Code) ---
# Gate A: required artifacts
./scripts/mk_policy_input.sh > tools/policy_input.json
conftest test tools/policy_input.json -p policies | tee "$EVD/10_policy/gate_supplychain.txt"

# Gate B: deny High/Critical vulns (Grype)
jq '.' outputs/grype.json > tools/grype_input.json
conftest test tools/grype_input.json -p policies | tee "$EVD/10_policy/gate_vulns.txt"

# Gate C: deny secrets (Gitleaks)
jq '.' outputs/gitleaks.json > tools/gitleaks_input.json
conftest test tools/gitleaks_input.json -p policies | tee "$EVD/10_policy/gate_secrets.txt"

# Evidence inventory
ls -lh outputs/* | tee "$EVD/00_env/outputs_list.txt"
