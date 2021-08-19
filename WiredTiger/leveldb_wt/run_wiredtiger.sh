#!/bin/bash

set -x

for run in 1 2 3 4 5
do
	for fs in duofs duofs_relaxed nova nova_relaxed pmfs ext4 xfs
	do
		./run_fs.sh $run $fs
	done
done
