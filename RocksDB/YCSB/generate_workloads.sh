#!/bin/bash

workload_dir=../ycsb_workloads
mkdir -p $workload_dir

./run_ycsb_for_trace.sh
./generate_trace_files.sh 8 50M 50M 50M 50M 50M 10M $workload_dir
./command_file.sh
