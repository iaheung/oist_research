### SATA connector
set_property IOSTANDARD DIFF_HSTL_I_18 [get_ports {daisy_p_o[*]}]
set_property IOSTANDARD DIFF_HSTL_I_18 [get_ports {daisy_n_o[*]}]
set_property IOSTANDARD DIFF_HSTL_I_18 [get_ports {daisy_p_i[*]}]
set_property IOSTANDARD DIFF_HSTL_I_18 [get_ports {daisy_n_i[*]}]

create_clock -period 8.000 -name daisy_clk  [get_ports daisy_p_i[1]]
set_property PULLTYPE PULLUP [get_ports daisy_p_i[1]]
#set_property PULLTYPE PULLDOWN [get_ports daisy_n_i[1]]

set_clock_groups -asynchronous -group [get_clocks clk_125_system_clk_gen_0] -group [get_clocks clk]
#set_clock_groups -asynchronous -group [get_clocks clk_62_5_system_clk_gen_0] -group [get_clocks clk]
set_clock_groups -asynchronous -group [get_clocks m_axi_dac1_aclk] -group [get_clocks clk]
set_clock_groups -asynchronous -group [get_clocks s_axi_reg_aclk] -group [get_clocks clk]
set_clock_groups -asynchronous -group [get_clocks adc_clk] -group [get_clocks clk_125_system_clk_gen_0]
set_clock_groups -asynchronous -group [get_clocks clk] -group [get_clocks clk_125_system_clk_gen_0]
set_clock_groups -asynchronous -group [get_clocks s_axi_reg_aclk] -group [get_clocks clk_125_system_clk_gen_0]
set_clock_groups -asynchronous -group [get_clocks m_axi_dac1_aclk] -group [get_clocks clk_200_system_clk_gen_0]
#set_clock_groups -asynchronous -group [get_clocks s_axi_reg_aclk] -group [get_clocks clk_62_5_system_clk_gen_0]
set_clock_groups -asynchronous -group [get_clocks clk] -group [get_clocks m_axi_dac1_aclk]
set_clock_groups -asynchronous -group [get_clocks clk_125_system_clk_gen_0] -group [get_clocks m_axi_dac1_aclk]
set_clock_groups -asynchronous -group [get_clocks clk_200_system_clk_gen_0] -group [get_clocks m_axi_dac1_aclk]
#set_clock_groups -asynchronous -group [get_clocks clk_62_5_system_clk_gen_0] -group [get_clocks m_axi_dac1_aclk]
set_clock_groups -asynchronous -group [get_clocks clk] -group [get_clocks pll_dac_clk_1x]
set_clock_groups -asynchronous -group [get_clocks clk_125_system_clk_gen_0] -group [get_clocks s_axi_reg_aclk]
#set_clock_groups -asynchronous -group [get_clocks clk_62_5_system_clk_gen_0] -group [get_clocks s_axi_reg_aclk]
set_clock_groups -asynchronous -group [get_clocks clk_200_system_clk_gen_0] -group [get_clocks clk]
set_clock_groups -asynchronous -group [get_clocks clk] -group [get_clocks clk_200_system_clk_gen_0]
set_clock_groups -asynchronous -group [get_clocks clk_fpga_2] -group [get_clocks adc_clk]
set_clock_groups -asynchronous -group [get_clocks adc_clk] -group [get_clocks clk_fpga_2]
set_clock_groups -asynchronous -group [get_clocks clk_fpga_2] -group [get_clocks m_axi_dac1_aclk]
set_clock_groups -asynchronous -group [get_clocks m_axi_dac1_aclk] -group [get_clocks clk_fpga_2]

set_clock_groups -asynchronous -group [get_clocks clk_125_system_clk_gen_0] -group [get_clocks clk_fpga_2]
set_clock_groups -asynchronous -group [get_clocks clk_fpga_2] -group [get_clocks clk_125_system_clk_gen_0]
set_clock_groups -asynchronous -group [get_clocks clk_fpga_2] -group [get_clocks clk]
set_clock_groups -asynchronous -group [get_clocks clk] -group [get_clocks clk_fpga_2]
set_clock_groups -asynchronous -group [get_clocks clk_fpga_2] -group [get_clocks adc_clk]
set_clock_groups -asynchronous -group [get_clocks adc_clk] -group [get_clocks clk_fpga_2]

set_clock_groups -logically_exclusive -group [get_clocks -include_generated_clocks adc_clk] -group [get_clocks -include_generated_clocks daisy_clk]