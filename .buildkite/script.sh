
BUILD_STATE=$(buildkite-agent meta-data get "build-state")
echo "BUILD_STATE: $BUILD_STATE.\nRunning CASE statement..."
case "$BUILD_STATE" in
  "passed")
    echo "Executing passed state"
    exit 0
    ;;
  "failed")
    echo "Executing failed state"
    exit 1
    ;;
  "soft-failed")
    echo "Executing soft failed state"
    buildkite-agent pipeline upload .buildkite/soft_fail.yaml
    ;;
  "blocked-failed")
    echo "Adding blocked step"
    buildkite-agent pipeline upload << 'INNEREOF'
    steps:
      - block: "This build is now blocked"
        blocked_state: "failed"
    INNEREOF
    ;;
  "blocked-passed")
    echo "Adding blocked step"
    buildkite-agent pipeline upload << 'INNEREOF'
    steps:
      - block: "This build is now blocked"
        blocked_state: "passed"
    INNEREOF
    ;;
  "blocked-running")
    echo "Adding blocked step"
    buildkite-agent pipeline upload << 'INNEREOF'
    steps:
      - block: "This build is now blocked"
        blocked_state: "running"
    INNEREOF
    ;;
  "canceled")
    echo "Canceling build"
    buildkite-agent build cancel
    ;;
  "running")
    echo "Setting build to running state"
    sleep 10
    ;;
  "skipped")
    echo "Skipping remaining steps"
    buildkite-agent pipeline upload << 'INNEREOF'
    steps:
      - command: "echo 'This step will be skipped'"
        skip: true
    INNEREOF
    ;;
esac