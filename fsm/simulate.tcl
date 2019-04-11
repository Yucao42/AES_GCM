#exec xvlog -sv aes_encrypt_stage.sv gcm_aes.sv testbench.sv
exec xvlog  -sv edge.v test.v clk_gen.sv
#exec xelab testbench
exec xelab -debug all testbench
exec xsim -gui  work.testbench
#exec xsim work.testbench
