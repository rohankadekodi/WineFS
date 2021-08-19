#!/bin/bash

if [ "$#" -ne 5 ]; then
	echo "Usage: ./pmemkv_workload.sh <fs> <pmemkvDir> <workload> <result_dir> <run>"
	exit 1
fi

set -e 

fs=$1
pmemkvDir=$2
workload=$3
resultDir=$4
run=$5

cd $pmemkvDir

export PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig

echo "PMEM_IS_PMEM_FORCE=1 numactl --cpubind=0 ./pmemkv_bench --db=./pmemkvdir.poolset --num=5000000 --benchmarks=$workload --threads=16 --value_size=4096 --db_size_in_gb=0 2>&1 | tee $resultDir/${workload}_Run$run.out"
