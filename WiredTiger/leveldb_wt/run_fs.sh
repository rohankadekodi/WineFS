#!/bin/bash

set -x

run=$1
fs=$2

config_dir=/ssd0/saurabh/fs_configs
result=/ssd0/saurabh/results/$fs/wiredtiger
mkdir -p $result

resultfile=$result/fillread_run$run
sudo rm $resultfile
$config_dir/setup_${fs}.sh
numactl --cpubind=0 ./db_bench_wiredtiger --use_lsm=0 --db=/mnt/pmem0/wt-db --value_size=1024 --benchmarks=fillrandom,readrandom --use_existing_db=0 --num=1000000 --threads=4 2>&1 | tee $resultfile

