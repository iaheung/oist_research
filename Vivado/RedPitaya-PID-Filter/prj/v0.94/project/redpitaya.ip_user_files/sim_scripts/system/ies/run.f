-makelib ies_lib/xilinx_vip -sv \
  "C:/Xilinx/Vivado/2020.1/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
  "C:/Xilinx/Vivado/2020.1/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
  "C:/Xilinx/Vivado/2020.1/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
  "C:/Xilinx/Vivado/2020.1/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
  "C:/Xilinx/Vivado/2020.1/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
  "C:/Xilinx/Vivado/2020.1/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
  "C:/Xilinx/Vivado/2020.1/data/xilinx_vip/hdl/axi_vip_if.sv" \
  "C:/Xilinx/Vivado/2020.1/data/xilinx_vip/hdl/clk_vip_if.sv" \
  "C:/Xilinx/Vivado/2020.1/data/xilinx_vip/hdl/rst_vip_if.sv" \
-endlib
-makelib ies_lib/xpm -sv \
  "C:/Xilinx/Vivado/2020.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "C:/Xilinx/Vivado/2020.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "C:/Xilinx/Vivado/2020.1/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/generic_baseblocks_v2_1_0 \
  "../../../../redpitaya.srcs/sources_1/bd/system/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \
-endlib
-makelib ies_lib/fifo_generator_v13_2_5 \
  "../../../../redpitaya.srcs/sources_1/bd/system/ipshared/276e/simulation/fifo_generator_vlog_beh.v" \
-endlib
-makelib ies_lib/fifo_generator_v13_2_5 \
  "../../../../redpitaya.srcs/sources_1/bd/system/ipshared/276e/hdl/fifo_generator_v13_2_rfs.vhd" \
-endlib
-makelib ies_lib/fifo_generator_v13_2_5 \
  "../../../../redpitaya.srcs/sources_1/bd/system/ipshared/276e/hdl/fifo_generator_v13_2_rfs.v" \
-endlib
-makelib ies_lib/axi_data_fifo_v2_1_20 \
  "../../../../redpitaya.srcs/sources_1/bd/system/ipshared/47c9/hdl/axi_data_fifo_v2_1_vl_rfs.v" \
-endlib
-makelib ies_lib/axi_infrastructure_v1_1_0 \
  "../../../../redpitaya.srcs/sources_1/bd/system/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \
-endlib
-makelib ies_lib/axi_register_slice_v2_1_21 \
  "../../../../redpitaya.srcs/sources_1/bd/system/ipshared/2ef9/hdl/axi_register_slice_v2_1_vl_rfs.v" \
-endlib
-makelib ies_lib/axi_protocol_converter_v2_1_21 \
  "../../../../redpitaya.srcs/sources_1/bd/system/ipshared/8dfa/hdl/axi_protocol_converter_v2_1_vl_rfs.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../bd/system/ip/system_axi_protocol_converter_0_0/sim/system_axi_protocol_converter_0_0.v" \
-endlib
-makelib ies_lib/lib_cdc_v1_0_2 \
  "../../../../redpitaya.srcs/sources_1/bd/system/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \
-endlib
-makelib ies_lib/proc_sys_reset_v5_0_13 \
  "../../../../redpitaya.srcs/sources_1/bd/system/ipshared/8842/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../bd/system/ip/system_proc_sys_reset_0/sim/system_proc_sys_reset_0.vhd" \
-endlib
-makelib ies_lib/axi_vip_v1_1_7 -sv \
  "../../../../redpitaya.srcs/sources_1/bd/system/ipshared/ce6c/hdl/axi_vip_v1_1_vl_rfs.sv" \
-endlib
-makelib ies_lib/processing_system7_vip_v1_0_9 -sv \
  "../../../../redpitaya.srcs/sources_1/bd/system/ipshared/6b56/hdl/processing_system7_vip_v1_0_vl_rfs.sv" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../bd/system/ip/system_processing_system7_0/sim/system_processing_system7_0.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../bd/system/ip/system_xadc_0/proc_common_v3_30_a/hdl/src/vhdl/system_xadc_0_conv_funs_pkg.vhd" \
  "../../../bd/system/ip/system_xadc_0/proc_common_v3_30_a/hdl/src/vhdl/system_xadc_0_proc_common_pkg.vhd" \
  "../../../bd/system/ip/system_xadc_0/proc_common_v3_30_a/hdl/src/vhdl/system_xadc_0_ipif_pkg.vhd" \
  "../../../bd/system/ip/system_xadc_0/proc_common_v3_30_a/hdl/src/vhdl/system_xadc_0_family_support.vhd" \
  "../../../bd/system/ip/system_xadc_0/proc_common_v3_30_a/hdl/src/vhdl/system_xadc_0_family.vhd" \
  "../../../bd/system/ip/system_xadc_0/proc_common_v3_30_a/hdl/src/vhdl/system_xadc_0_soft_reset.vhd" \
  "../../../bd/system/ip/system_xadc_0/proc_common_v3_30_a/hdl/src/vhdl/system_xadc_0_pselect_f.vhd" \
  "../../../bd/system/ip/system_xadc_0/axi_lite_ipif_v1_01_a/hdl/src/vhdl/system_xadc_0_address_decoder.vhd" \
  "../../../bd/system/ip/system_xadc_0/axi_lite_ipif_v1_01_a/hdl/src/vhdl/system_xadc_0_slave_attachment.vhd" \
  "../../../bd/system/ip/system_xadc_0/interrupt_control_v2_01_a/hdl/src/vhdl/system_xadc_0_interrupt_control.vhd" \
  "../../../bd/system/ip/system_xadc_0/axi_lite_ipif_v1_01_a/hdl/src/vhdl/system_xadc_0_axi_lite_ipif.vhd" \
  "../../../bd/system/ip/system_xadc_0/system_xadc_0_xadc_core_drp.vhd" \
  "../../../bd/system/ip/system_xadc_0/system_xadc_0_axi_xadc.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../bd/system/ip/system_xadc_0/system_xadc_0.v" \
-endlib
-makelib ies_lib/xlconstant_v1_1_7 \
  "../../../../redpitaya.srcs/sources_1/bd/system/ipshared/fcfc/hdl/xlconstant_v1_1_vl_rfs.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../bd/system/ip/system_xlconstant_0/sim/system_xlconstant_0.v" \
  "../../../bd/system/sim/system.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

