#!/bin/bash

if [ "$#" -ne 5 ]; then
	echo "Usage: ./fs_setup.sh <start-run-id> <num-runs> <result-dir> <dev> <mnt>"
	exit 1
fi

set -e

startRunId=$1
resultDir=$2
numRuns=$3
dev=$4
mnt=$5

curDir=`readlink -f ./`

./cpu_scaling_governer.sh

for ((i = $startRunId ; i < $((startRunId + numRuns)) ; i++)); do
	# for fs in nova duofs ext4 xfs
	for fs in nova duofs
	do
		./mount_fs.sh $fs $dev $mnt 0
		./run_mmap_applications.sh $fs $mnt $resultDir $i 
		sleep 30
		
		# for workload in varmail.f fileserver.f webserver.f webproxy.f
		# do
		#	./mount_fs.sh $fs $dev $mnt 1
		#	cd $curDir
		#	echo "$fs FILEBENCH workload $workload Run $run"
		#	./filebench_workload.sh $fs /mnt/ssd/saurabh/filebench $mnt $workload $resultDir/$fs/filebench $i
		#	cd $curDir
		#	sleep 30
		# done

		# ./mount_fs.sh $fs $dev $mnt 1
		# ./wiredtiger_suite.sh $fs /mnt/ssd/saurabh/leveldb_wt $mnt $resultDir $i
		# sleep 30
	done
done

cd $curDir
