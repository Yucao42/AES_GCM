# Synthesis and Implementation script

#Set part number
#set_part xc7a35tcpg236-1
set_part xcku035-fbva900-3-e 


# Read verilog source files
read_verilog -sv  clk_gen.sv
read_verilog -sv  fn_aes_ghash_multiplication.sv
read_verilog -sv  fn_aes_encrypt_stage.sv
read_verilog -sv  fn_aes_key_expansion.sv
read_verilog -sv  aes_signal_passing.sv
read_verilog -sv  aes_pipeline_stage1.sv
read_verilog -sv  aes_pipeline_stage12.sv
read_verilog -sv  aes_pipeline_stage13.sv
read_verilog -sv  aes_pipeline_stage14.sv
read_verilog -sv  aes_pipeline_stage2_pre.sv
read_verilog -sv  aes_pipeline_stage3_pre.sv
read_verilog -sv  aes_pipeline_stage4_pre.sv
read_verilog -sv  aes_pipeline_stage5_pre.sv
read_verilog -sv  aes_pipeline_stage6_pre.sv
read_verilog -sv  aes_pipeline_stage7_pre.sv
read_verilog -sv  aes_pipeline_stage2.sv
read_verilog -sv  aes_pipeline_stage3.sv
read_verilog -sv  aes_pipeline_stage4.sv
read_verilog -sv  aes_pipeline_stage5.sv
read_verilog -sv  aes_pipeline_stage6.sv
read_verilog -sv  aes_pipeline_stage7.sv
read_verilog -sv  aes_pipeline_stage8.sv
read_verilog -sv  aes_pipeline_stage9.sv
read_verilog -sv  aes_key_gen.sv
read_verilog -sv  gcm_aes.sv
read_verilog -sv  display.sv
read_verilog -sv  aes.sv

#Read constraints file
read_xdc constraints_artix_7.xdc

# Run Synthesis
synth_design -top aes

# Create reports directory
exec mkdir -p -- ./reports

# Reports after synthesis
report_timing -setup  -file ./reports/synth_aes_setup_report.txt
report_timing -hold   -file ./reports/synth_aes_hold_report.txt
report_timing_summary -file ./reports/synth_timing_report_aes.txt -delay_type min_max -max_path 50
report_utilization    -file ./reports/synth_utilization_report.txt
report_utilization -hierarchical  -file ./reports/synth_utilization_report_submodule.txt

# show_schematic [get_nets -hier]
write_schematic -format pdf -orientation portrait /home/yu/projects/AES_GCM/schematic_1.pdf
