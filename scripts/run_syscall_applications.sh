#!/bin/bash

if [ "$#" -ne 5 ]; then
	echo "Usage: ./run_syscall_applications.sh <start-run-id> <num-runs> <result-dir> <dev> <mnt>"
	exit 1
fi

set -e

startRunId=$1
numRuns=$2
resultDir=$3
dev=$4
mnt=$5

filebenchDir=../Filebench
wiredTigerDir=../WiredTiger

./cpu_scaling_governer.sh

for ((i = $startRunId ; i < $((startRunId + numRuns)) ; i++))
do
	for fs in duofs nova ext4 xfs
	do
		./mount_fs.sh $fs $dev $mnt 1
		./filebench_suite.sh $fs $filebenchDir/filebench $mnt $resultDir $i
		./wiredtiger_suite.sh $fs $wiredTigerDir/leveldb_wt $mnt $resultDir $i
	done
done
