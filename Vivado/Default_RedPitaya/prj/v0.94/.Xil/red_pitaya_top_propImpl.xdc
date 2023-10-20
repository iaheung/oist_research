set_property SRC_FILE_INFO {cfile:c:/Users/Ian/Desktop/OIST/RedPitaya/ReferenceTest/prj/v0.94/project/redpitaya.srcs/sources_1/bd/system/ip/system_processing_system7_0/system_processing_system7_0.xdc rfile:../project/redpitaya.srcs/sources_1/bd/system/ip/system_processing_system7_0/system_processing_system7_0.xdc id:1 order:EARLY scoped_inst:ps/system_i/processing_system7/inst} [current_design]
set_property SRC_FILE_INFO {cfile:C:/Users/Ian/Desktop/OIST/RedPitaya/ReferenceTest/prj/v0.94/project/redpitaya.srcs/constrs_1/imports/ReferenceTest/sdc/red_pitaya.xdc rfile:../project/redpitaya.srcs/constrs_1/imports/ReferenceTest/sdc/red_pitaya.xdc id:2} [current_design]
set_property SRC_FILE_INFO {cfile:C:/Users/Ian/Desktop/OIST/RedPitaya/ReferenceTest/prj/v0.94/project/redpitaya.srcs/constrs_1/imports/ReferenceTest/prj/v0.94/sdc/red_pitaya.xdc rfile:../project/redpitaya.srcs/constrs_1/imports/ReferenceTest/prj/v0.94/sdc/red_pitaya.xdc id:3} [current_design]
current_instance ps/system_i/processing_system7/inst
set_property src_info {type:SCOPED_XDC file:1 line:21 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter clk_fpga_3 0.15
set_property src_info {type:SCOPED_XDC file:1 line:24 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter clk_fpga_2 0.6
set_property src_info {type:SCOPED_XDC file:1 line:27 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter clk_fpga_0 0.24
set_property src_info {type:SCOPED_XDC file:1 line:30 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter clk_fpga_1 0.12
current_instance
set_property src_info {type:XDC file:2 line:19 export:INPUT save:INPUT read:READ} [current_design]
set_property IOB        TRUE     [get_ports {adc_dat_i[*][*]}]
set_property src_info {type:XDC file:2 line:114 export:INPUT save:INPUT read:READ} [current_design]
set_property IOB        TRUE     [get_ports {dac_pwm_o[*]}]
set_property src_info {type:XDC file:2 line:206 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -from [get_clocks adc_clk]     -to [get_clocks dac_clk_o]
set_property src_info {type:XDC file:2 line:207 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -from [get_clocks adc_clk]     -to [get_clocks dac_clk_2x]
set_property src_info {type:XDC file:2 line:208 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -from [get_clocks adc_clk]     -to [get_clocks dac_clk_2p]
set_property src_info {type:XDC file:2 line:212 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -from [get_clocks clk_fpga_0]  -to [get_clocks dac_clk_1x]
set_property src_info {type:XDC file:2 line:213 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -from [get_clocks clk_fpga_0]  -to [get_clocks dac_clk_2x]
set_property src_info {type:XDC file:2 line:214 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -from [get_clocks clk_fpga_0]  -to [get_clocks dac_clk_2p]
set_property src_info {type:XDC file:2 line:215 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -from [get_clocks clk_fpga_0]  -to [get_clocks ser_clk]
set_property src_info {type:XDC file:2 line:216 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -from [get_clocks clk_fpga_0]  -to [get_clocks pdm_clk]
set_property src_info {type:XDC file:2 line:217 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -from [get_clocks dac_clk_o] -to [get_clocks dac_clk_2x]
set_property src_info {type:XDC file:2 line:218 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -from [get_clocks dac_clk_o] -to [get_clocks dac_clk_2p]
set_property src_info {type:XDC file:3 line:1 export:INPUT save:INPUT read:READ} [current_design]
set_property LOC XADC_X0Y0 [get_cells i_ams/XADC_inst]
set_property src_info {type:XDC file:3 line:7 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -from [get_clocks adc_clk]     -to [get_clocks dac_clk_out]
set_property src_info {type:XDC file:3 line:8 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -from [get_clocks clk_fpga_0]  -to [get_clocks ser_clk_out]
set_property src_info {type:XDC file:3 line:9 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -from [get_clocks clk_fpga_0]  -to [get_clocks dac_2clk_out]
set_property src_info {type:XDC file:3 line:11 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -from [get_clocks clk_fpga_0]  -to [get_clocks par_clk]
set_property src_info {type:XDC file:3 line:12 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -from [get_clocks dac_clk_out] -to [get_clocks dac_2clk_out]
set_property src_info {type:XDC file:3 line:13 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -from [get_clocks dac_clk_out] -to [get_clocks dac_2ph_out]
