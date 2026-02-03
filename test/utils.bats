#!/usr/bin/env bats

load test_helpers

@test "TOOL_NAME is set correctly" {
  run bash -c 'source "'"${PROJECT_DIR}"'/lib/utils.bash" && echo "$TOOL_NAME"'

  [ "$status" -eq 0 ]
  [ "$output" = "oxlint" ]
}

@test "GH_REPO is set correctly" {
  run bash -c 'source "'"${PROJECT_DIR}"'/lib/utils.bash" && echo "$GH_REPO"'

  [ "$status" -eq 0 ]
  [ "$output" = "https://github.com/oxc-project/oxc" ]
}

@test "TOOL_TEST is set correctly" {
  run bash -c 'source "'"${PROJECT_DIR}"'/lib/utils.bash" && echo "$TOOL_TEST"'

  [ "$status" -eq 0 ]
  [ "$output" = "oxlint --version" ]
}

@test "sort_versions sorts correctly" {
  run bash -c 'source "'"${PROJECT_DIR}"'/lib/utils.bash" && echo -e "1.10.0\n1.2.0\n1.1.0" | sort_versions'

  [ "$status" -eq 0 ]

  first_version=$(echo "$output" | head -n1)
  [ "$first_version" = "1.1.0" ]
}

@test "get_platform returns valid platform" {
  run bash -c 'source "'"${PROJECT_DIR}"'/lib/utils.bash" && get_platform'

  [ "$status" -eq 0 ]
  [[ "$output" =~ ^(darwin|linux)$ ]]
}

@test "get_arch returns valid architecture" {
  run bash -c 'source "'"${PROJECT_DIR}"'/lib/utils.bash" && get_arch'

  [ "$status" -eq 0 ]
  [[ "$output" =~ ^(x64|arm64)$ ]]
}

@test "list_github_tags returns versions" {
  run bash -c 'source "'"${PROJECT_DIR}"'/lib/utils.bash" && list_github_tags | head -5'

  [ "$status" -eq 0 ]
  [ -n "$output" ]
}

@test "fail function exits with error" {
  run bash -c 'source "'"${PROJECT_DIR}"'/lib/utils.bash" && fail "test error"'

  [ "$status" -eq 1 ]
  [[ "$output" == *"test error"* ]]
}
