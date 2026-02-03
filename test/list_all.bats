#!/usr/bin/env bats

load test_helpers

@test "list-all returns versions" {
  run bash -c "\"${PROJECT_DIR}/bin/list-all\""

  [ "$status" -eq 0 ]
  [ -n "$output" ]
}

@test "list-all includes version 1.0.0" {
  run bash -c "\"${PROJECT_DIR}/bin/list-all\""

  [ "$status" -eq 0 ]
  [[ "$output" == *"1.0.0"* ]]
}

@test "list-all includes version 1.43.0" {
  run bash -c "\"${PROJECT_DIR}/bin/list-all\""

  [ "$status" -eq 0 ]
  [[ "$output" == *"1.43.0"* ]]
}

@test "list-all versions are space-separated" {
  run bash -c "\"${PROJECT_DIR}/bin/list-all\""

  [ "$status" -eq 0 ]
  # Check that output contains spaces (multiple versions)
  [[ "$output" == *" "* ]]
}

@test "list-all versions are sorted" {
  run bash -c "\"${PROJECT_DIR}/bin/list-all\""

  [ "$status" -eq 0 ]

  # Get first and last versions
  first_version=$(echo "$output" | tr ' ' '\n' | head -n1)
  last_version=$(echo "$output" | tr ' ' '\n' | tail -n1)

  # First version should be older (smaller) than last
  # Compare major versions
  first_major=$(echo "$first_version" | cut -d. -f1)
  last_major=$(echo "$last_version" | cut -d. -f1)

  [ "$first_major" -le "$last_major" ]
}
