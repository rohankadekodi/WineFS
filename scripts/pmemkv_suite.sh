#!/bin/bash

if [ "$#" -ne 4 ]; then
	echo "Usage: ./pmemkv_suite.sh <fs> <pmemkv_dir> <result_dir> <run>"
	exit 1
fi

set -e

fs=$1
pmemkvDir=$2
resultDir=$3/$fs/pmemkv
run=$4

curDir=`readlink -f ./`

mkdir -p $resultDir

for workload in fillseq 
do
	echo "$fs PMEMKV workload $workload Run $run"
	cd $curDir
	./pmemkv_workload.sh $fs $pmemkvDir $workload $resultDir $run
	cd $curDir
done
