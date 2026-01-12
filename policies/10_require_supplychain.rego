package main

deny contains msg if {
  input.repo_has_outputs == true
  not input.sbom_present
  msg := "Missing SBOM: outputs/sbom.spdx.json"
}

deny contains msg if {
  input.repo_has_outputs == true
  not input.grype_present
  msg := "Missing vulnerability report: outputs/grype.json"
}
