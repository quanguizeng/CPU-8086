# Constrain clock port clk with a 10-ns requirement
create_clock -name clk -period 41.667 [get_ports {clk}]

# Automatically apply a generate clock on the output of phase-locked loops (PLLs)
# derive_pll_clocks 

# This command can be safely left in the SDC even if no PLLs exist in the design
derive_clock_uncertainty

# Constrain the input I/O path
set_input_delay -clock clk -max 3 [all_inputs]
set_input_delay -clock clk -min 2 [all_inputs]

# Constrain the output I/O path
set_output_delay -clock clk 2 [all_outputs]