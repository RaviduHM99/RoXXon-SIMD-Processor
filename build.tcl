

create_project project_2 C:/Academic_Projects/ADS_Projects/AXI_IP/project_2 -part xc7z010clg400-1

set_property board_part digilentinc.com:zybo:part0:2.0 [current_project]

# Engine
add_files  [glob $CONFIG_DIR/*.svh] [glob $RTL_DIR/*] [glob $RTL_DIR/ext/*]
set_property top dnn_engine [current_fileset]


# Implementation
reset_run impl_1
reset_run synth_1
launch_runs impl_1 -to_step write_bitstream -jobs 10
wait_on_run -timeout 360 impl_1
write_hw_platform -fixed -include_bit -force -file $PROJECT_NAME/design_1_wrapper.xsa

# Reports
open_run impl_1
if {![file exists $PROJECT_NAME/reports]} {exec mkdir $PROJECT_NAME/reports}
report_timing_summary -delay_type min_max -report_unconstrained -check_timing_verbose -max_paths 100 -input_pins -routable_nets -name timing_1 -file $PROJECT_NAME/reports/${PROJECT_NAME}_${BOARD}_${FREQ}_timing_report.txt
report_utilization -file $PROJECT_NAME/reports/${PROJECT_NAME}_${BOARD}_${FREQ}_utilization_report.txt -name utilization_1
report_power -file $PROJECT_NAME/reports/${PROJECT_NAME}_${BOARD}_${FREQ}_power_1.txt -name {power_1}
report_drc -name drc_1 -file $PROJECT_NAME/reports/${PROJECT_NAME}_${BOARD}_${FREQ}_drc_1.txt -ruledecks {default opt_checks placer_checks router_checks bitstream_checks incr_eco_checks eco_checks abs_checks}

exec mkdir -p $PROJECT_NAME/output
exec cp "$PROJECT_NAME/$PROJECT_NAME.runs/impl_1/design_1_wrapper.bit" $PROJECT_NAME/output/design_1.bit
