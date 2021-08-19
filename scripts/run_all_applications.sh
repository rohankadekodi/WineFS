#!/bin/bash

if [ "$#" -ne 5 ]; then
	echo "Usage: sudo ./run_all_applications.sh <start-run-id> <num-runs> <result-dir> <dev> <mnt>"
	exit 1
fi

set -e

./run_mmap_applications $1 $2 $3 $4 $5
./run_syscall_applications $1 $2 $3 $4 $5
