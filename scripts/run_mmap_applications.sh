#!/bin/bash

if [ "$#" -ne 5 ]; then
	echo "Usage: ./run_mmap_applications.sh <start-run-id> <num-runs> <result-dir> <dev> <mnt>"
	exit 1
fi

set -e

startRunId=$1
numRuns=$2
resultDir=$3
dev=$4
mnt=$5

rocksdbDir=../RocksDB
ycsbWorkloadDir=../RocksDB/ycsb_workloads
lmdbDir=../LMDB

./cpu_scaling_governer.sh

for ((i = $startRunId ; i < $((startRunId + numRuns)) ; i++))
do
	for fs in duofs nova ext4 xfs
	do
		./mount_fs.sh $fs $dev $mnt 0
		./rocksdb_suite.sh $fs $mnt $rocksDbDir $ycsbWorkloadDir $resultDir $i
		./lmdb_suite.sh $fs $lmdbDir/dbbench/bin $mnt $resultDir $i
	done
done
