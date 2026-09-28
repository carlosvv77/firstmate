#!/usr/bin/env bash
# Drives the real bin/fm-spawn.sh with the REAL teamclaude CLI/proxy on PATH.
# Only tmux is a recording double (captures the launch command fm-spawn sends);
# treehouse is a no-op because the worktree is prepared by the fixture.
set -u
ROOT=$1; H=$2; ID=$3
shift 3
. "$ROOT/tests/fixtures.sh"
TMP_ROOT=$(fm_test_tmproot fm-tc-live)
case_dir="$TMP_ROOT/$H"; home="$case_dir/home"; proj="$case_dir/project"; wt="$case_dir/wt"
fakebin=$(fm_test_make_spawn_fakebin "$case_dir/fake")
fm_test_spawn_home "$home" "$H"
fm_git_worktree "$proj" "$wt" "wt-$H" >/dev/null 2>&1
fm_test_spawn_brief "$home" "$ID" >/dev/null
: > "$case_dir/launch.log"
out=$(FM_FAKE_LAUNCH_LOG="$case_dir/launch.log" fm_test_run_spawn "$home" "$wt" "$fakebin" "$ID" "$proj" --mode no-mistakes --yolo off "$@")
rc=$?
printf '== fm-spawn rc=%s\n' "$rc"
printf '%s\n' "$out" | tail -8
printf '== launch command sent to the pane:\n'
cat "$case_dir/launch.log"
printf '\n== record exists: '; [ -f "$home/state/$ID.meta" ] && echo yes || echo no
printf 'LAUNCHFILE=%s\n' "$case_dir/launch.log"
