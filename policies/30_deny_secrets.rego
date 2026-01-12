package main

deny contains msg if {
  count(input) > 0
  msg := "Secrets detected by Gitleaks"
}
