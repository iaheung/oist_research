# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
namespace eval ::optrace {
  variable script "C:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.runs/synth_1/red_pitaya_top.tcl"
  variable category "vivado_synth"
}

# Try to connect to running dispatch if we haven't done so already.
# This code assumes that the Tcl interpreter is not using threads,
# since the ::dispatch::connected variable isn't mutex protected.
if {![info exists ::dispatch::connected]} {
  namespace eval ::dispatch {
    variable connected false
    if {[llength [array get env XILINX_CD_CONNECT_ID]] > 0} {
      set result "true"
      if {[catch {
        if {[lsearch -exact [package names] DispatchTcl] < 0} {
          set result [load librdi_cd_clienttcl[info sharedlibextension]] 
        }
        if {$result eq "false"} {
          puts "WARNING: Could not load dispatch client library"
        }
        set connect_id [ ::dispatch::init_client -mode EXISTING_SERVER ]
        if { $connect_id eq "" } {
          puts "WARNING: Could not initialize dispatch client"
        } else {
          puts "INFO: Dispatch client connection id - $connect_id"
          set connected true
        }
      } catch_res]} {
        puts "WARNING: failed to connect to dispatch server - $catch_res"
      }
    }
  }
}
if {$::dispatch::connected} {
  # Remove the dummy proc if it exists.
  if { [expr {[llength [info procs ::OPTRACE]] > 0}] } {
    rename ::OPTRACE ""
  }
  proc ::OPTRACE { task action {tags {} } } {
    ::vitis_log::op_trace "$task" $action -tags $tags -script $::optrace::script -category $::optrace::category
  }
  # dispatch is generic. We specifically want to attach logging.
  ::vitis_log::connect_client
} else {
  # Add dummy proc if it doesn't exist.
  if { [expr {[llength [info procs ::OPTRACE]] == 0}] } {
    proc ::OPTRACE {{arg1 \"\" } {arg2 \"\"} {arg3 \"\" } {arg4 \"\"} {arg5 \"\" } {arg6 \"\"}} {
        # Do nothing
    }
  }
}

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
OPTRACE "synth_1" START { ROLLUP_AUTO }
set_param chipscope.maxJobs 2
set_param synth.incrementalSynthesisCache C:/Users/Ian/AppData/Roaming/Xilinx/Vivado/.Xil/Vivado-11644-DESKTOP-UF70E69/incrSyn
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000
OPTRACE "Creating in-memory project" START { }
create_project -in_memory -part xc7z010clg400-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir C:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.cache/wt [current_project]
set_property parent.project_path C:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo c:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
OPTRACE "Creating in-memory project" END { }
OPTRACE "Adding files" START { }
read_verilog -library xil_defaultlib -sv {
  C:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.srcs/sources_1/imports/RedPitaya-FilterTest/rtl/interface/axi4_if.sv
  C:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.srcs/sources_1/imports/RedPitaya-FilterTest/rtl/axi4_slave.sv
  C:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.srcs/sources_1/imports/RedPitaya-FilterTest/rtl/interface/gpio_if.sv
  C:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.srcs/sources_1/imports/RedPitaya-FilterTest/rtl/red_pitaya_dfilt1.sv
  C:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.srcs/sources_1/imports/RedPitaya-FilterTest/rtl/classic/red_pitaya_pdm.sv
  C:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.srcs/sources_1/imports/RedPitaya-FilterTest/rtl/red_pitaya_pll.sv
  C:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.srcs/sources_1/imports/RedPitaya-FilterTest/prj/v0.94/rtl/red_pitaya_ps.sv
  C:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.srcs/sources_1/imports/RedPitaya-FilterTest/rtl/interface/sys_bus_if.sv
  C:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.srcs/sources_1/imports/RedPitaya-FilterTest/rtl/sys_bus_interconnect.sv
  C:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.srcs/sources_1/imports/RedPitaya-FilterTest/rtl/sys_bus_stub.sv
  C:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.srcs/sources_1/imports/RedPitaya-FilterTest/prj/v0.94/rtl/red_pitaya_top.sv
}
read_verilog -library xil_defaultlib {
  C:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.srcs/sources_1/imports/RedPitaya-FilterTest/rtl/classic/axi_master.v
  C:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.srcs/sources_1/imports/RedPitaya-FilterTest/rtl/classic/axi_wr_fifo.v
  C:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.srcs/sources_1/imports/RedPitaya-FilterTest/rtl/divide.v
  C:/Users/Ian/Desktop/OIST/MATLAB/Filters/hdlsrc/fir_821_3.v
  C:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.srcs/sources_1/new/fir_custom_filter.v
  C:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.srcs/sources_1/imports/RedPitaya-FilterTest/rtl/classic/red_pitaya_ams.v
  C:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.srcs/sources_1/imports/RedPitaya-FilterTest/rtl/classic/red_pitaya_asg.v
  C:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.srcs/sources_1/imports/RedPitaya-FilterTest/rtl/classic/red_pitaya_asg_ch.v
  C:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.srcs/sources_1/imports/RedPitaya-FilterTest/rtl/classic/red_pitaya_daisy.v
  C:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.srcs/sources_1/imports/RedPitaya-FilterTest/rtl/classic/red_pitaya_daisy_rx.v
  C:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.srcs/sources_1/imports/RedPitaya-FilterTest/rtl/classic/red_pitaya_daisy_test.v
  C:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.srcs/sources_1/imports/RedPitaya-FilterTest/rtl/classic/red_pitaya_daisy_tx.v
  C:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.srcs/sources_1/imports/RedPitaya-FilterTest/rtl/classic/red_pitaya_hk.v
  C:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.srcs/sources_1/imports/RedPitaya-FilterTest/rtl/classic/red_pitaya_scope.v
}
add_files C:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.srcs/sources_1/bd/system/system.bd
set_property used_in_implementation false [get_files -all c:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.srcs/sources_1/bd/system/ip/system_axi_protocol_converter_0_0/system_axi_protocol_converter_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.srcs/sources_1/bd/system/ip/system_proc_sys_reset_0/system_proc_sys_reset_0_board.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.srcs/sources_1/bd/system/ip/system_proc_sys_reset_0/system_proc_sys_reset_0.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.srcs/sources_1/bd/system/ip/system_proc_sys_reset_0/system_proc_sys_reset_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.srcs/sources_1/bd/system/ip/system_processing_system7_0/system_processing_system7_0.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.srcs/sources_1/bd/system/ip/system_xadc_0/system_xadc_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.srcs/sources_1/bd/system/ip/system_xadc_0/system_xadc_0.xdc]
set_property used_in_implementation false [get_files -all C:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.srcs/sources_1/bd/system/system_ooc.xdc]

OPTRACE "Adding files" END { }
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.srcs/constrs_1/imports/RedPitaya-FilterTest/sdc/red_pitaya.xdc
set_property used_in_implementation false [get_files C:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.srcs/constrs_1/imports/RedPitaya-FilterTest/sdc/red_pitaya.xdc]

read_xdc C:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.srcs/constrs_1/imports/RedPitaya-FilterTest/prj/v0.94/sdc/red_pitaya.xdc
set_property used_in_implementation false [get_files C:/Users/Ian/Desktop/OIST/RedPitaya/RedPitaya-FilterTest/prj/v0.94/project/redpitaya.srcs/constrs_1/imports/RedPitaya-FilterTest/prj/v0.94/sdc/red_pitaya.xdc]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]
set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

OPTRACE "synth_design" START { }
synth_design -top red_pitaya_top -part xc7z010clg400-1
OPTRACE "synth_design" END { }


OPTRACE "write_checkpoint" START { CHECKPOINT }
# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef red_pitaya_top.dcp
OPTRACE "write_checkpoint" END { }
OPTRACE "synth reports" START { REPORT }
create_report "synth_1_synth_report_utilization_0" "report_utilization -file red_pitaya_top_utilization_synth.rpt -pb red_pitaya_top_utilization_synth.pb"
OPTRACE "synth reports" END { }
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
OPTRACE "synth_1" END { }