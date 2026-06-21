package main

deny contains msg if {
  input.matches
  some i
  m := input.matches[i]
  m.vulnerability.severity == "High"
  msg := sprintf("High vulnerability: %s", [m.vulnerability.id])
}

deny contains msg if {
  input.matches
  some i
  m := input.matches[i]
  m.vulnerability.severity == "Critical"
  msg := sprintf("Critical vulnerability: %s", [m.vulnerability.id])
}
