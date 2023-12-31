################################################################################
# HSI tcl script for building RedPitaya FSBL
#
# Usage:
# hsi -mode tcl -source red_pitaya_hsi_fsbl.tcl -tclargs projectname
################################################################################

cd prj/$::argv

set path_sdk sdk

hsi open_hw_design $path_sdk/red_pitaya.sysdef
hsi generate_app -hw system_0 -os standalone -proc ps7_cortexa9_0 -app zynq_fsbl -compile -sw fsbl -dir $path_sdk/fsbl

exit
