# This is intended to be run after "hw.tcl", triggering a complete bitstream generation.
launch_runs impl_1 -to_step write_bitstream -jobs 8

# These wait_on_run commands surface stdout/stderr - we really only need the
# impl_1 but would rather see what's happening on the way there.
wait_on_run synth_1
wait_on_run impl_1
