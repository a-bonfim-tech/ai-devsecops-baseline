package policy

deny contains msg if {
  some i
  vuln := input.matches[i]
  vuln.vulnerability.severity == "High"
  msg := sprintf("High severity vulnerability found: %s", [vuln.vulnerability.id])
}

deny contains msg if {
  some i
  vuln := input.matches[i]
  vuln.vulnerability.severity == "Critical"
  msg := sprintf("Critical vulnerability found: %s", [vuln.vulnerability.id])
}
