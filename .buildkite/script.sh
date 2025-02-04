BUILD_STATE=$(buildkite-agent meta-data get "build-state")

buildkite-agent pipeline upload << 'INNEREOF'
  notify:
    - slack:
        channels:
          - "#general"
        message: "Selected build state is: $BUILD_STATE"
INNEREOF

echo -e "BUILD_STATE: $BUILD_STATE.\nRunning CASE statement..."

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
        label: "blocked failed"
INNEREOF
    ;;
  "blocked-passed")
    echo "Adding blocked step"
    buildkite-agent pipeline upload << 'INNEREOF'
    steps:
      - block: "This build is now blocked"
        blocked_state: "passed"
        label: "blocked passed"
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
esac

