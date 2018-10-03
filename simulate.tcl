#exec xvlog -sv aes_encrypt_stage.sv gcm_aes.sv testbench.sv
exec xvlog -sv clk_gen.sv test128.sv aes_pipeline_stage8.sv aes_pipeline_stage7.sv aes_pipeline_stage6.sv aes_pipeline_stage5.sv aes_pipeline_stage4.sv aes_pipeline_stage3.sv aes_pipeline_stage2.sv aes_pipeline_stage12.sv aes_pipeline_stage13.sv aes_pipeline_stage14.sv aes_pipeline_stage1.sv ./fn_aes_encrypt_stage.sv ./fn_aes_key_expansion.sv fn_aes_ghash_multiplication.sv display.sv aes.sv gcm_aes.sv  
#exec xelab testbench
exec xelab -debug all testbench
exec xsim -gui  work.testbench
#exec xsim work.testbench
