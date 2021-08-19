#!/bin/bash

set -e

./run_mmap_applications 1 1 /home/sdp/winefs/results /home/sdp/images /dev/pmem0 /mnt/pmem0
./run_syscall_applications 1 1 /home/sdp/winefs/results /dev/pmem0 /mnt/pmem0
