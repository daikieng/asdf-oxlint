#!/usr/bin/env bats

load test_helpers

@test "latest-stable returns a version" {
  run bash -c "\"${PROJECT_DIR}/bin/latest-stable\""

  [ "$status" -eq 0 ]
  [ -n "$output" ]
}

@test "latest-stable returns valid semver format" {
  run bash -c "\"${PROJECT_DIR}/bin/latest-stable\""

  [ "$status" -eq 0 ]
  # Check X.Y.Z format
  [[ "$output" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]
}

@test "latest-stable does not return pre-release version" {
  run bash -c "\"${PROJECT_DIR}/bin/latest-stable\""

  [ "$status" -eq 0 ]
  # Should not contain hyphen (pre-release indicator)
  [[ "$output" != *"-"* ]]
}

@test "latest-stable returns single version" {
  run bash -c "\"${PROJECT_DIR}/bin/latest-stable\""

  [ "$status" -eq 0 ]
  # Should not contain spaces (only one version)
  [[ "$output" != *" "* ]]
}
