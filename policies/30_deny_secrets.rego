package main

deny contains msg if {
  is_array(input)
  count(input) > 0
  msg := "Secrets detected by Gitleaks"
}
