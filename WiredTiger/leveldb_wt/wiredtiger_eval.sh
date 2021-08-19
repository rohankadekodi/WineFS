#!/bin/bash

set -x

echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

e2fsprogsDir=/ssd0/saurabh/e2fsprogs/misc
pmem_device=/dev/mapper/linear-pmem
mount_point=/mnt/pmem0

duofs_result_dir=/ssd0/saurabh/results/duofs/wired_tiger
nova_result_dir=/ssd0/saurabh/results/nova/wired_tiger
ext4_result_dir=/ssd0/saurabh/results/ext4/wired_tiger
xfs_result_dir=/ssd0/saurabh/results/xfs/wired_tiger
pmfs_result_dir=/ssd0/saurabh/results/pmfs/wired_tiger

mkdir -p $duo_result_dir
mkdir -p $nova_result_dir
mkdir -p $ext4_result_dir
mkdir -p $xfs_result_dir
mkdir -p $pmfs_result_dir
mkdir -p $duofs_result_dir

for run in 1 2 3 4 5
do
    :'
    sudo umount /mnt/pmem0
    $e2fsprogsDir/mke2fs -t ext4 -b 4096 -O fast_commit -F $pmem_device
    mount -t ext4_allocator -o dax,fc_pmem $pmem_device $mount_point
    ./db_bench_wiredtiger --use_lsm=0 --db=/mnt/pmem0/wt-db --value_size=1024 --benchmarks=fillrandom --use_existing_db=0 --num=1000000 --threads=4 2>&1 | tee $duo_result_dir/fillrandom.$run
    ./db_bench_wiredtiger --use_lsm=0 --db=/mnt/pmem0/wt-db --value_size=1024 --benchmarks=readrandom --use_existing_db=1 --num=1000000 --threads=4 2>&1 | tee $duo_result_dir/readrandom.$run

    sudo umount /mnt/pmem0
    mount -t NOVA -o init $pmem_device $mount_point
    ./db_bench_wiredtiger --use_lsm=0 --db=/mnt/pmem0/wt-db --value_size=1024 --benchmarks=fillrandom --use_existing_db=0 --num=1000000 --threads=4 2>&1 | tee $nova_result_dir/fillrandom.$run
    ./db_bench_wiredtiger --use_lsm=0 --db=/mnt/pmem0/wt-db --value_size=1024 --benchmarks=readrandom --use_existing_db=1 --num=1000000 --threads=4 2>&1 | tee $nova_result_dir/readrandom.$run

    sudo umount /mnt/pmem0
    $e2fsprogsDir/mke2fs -t ext4 -b 4096 -F $pmem_device
    mount -o dax $pmem_device $mount_point
    ./db_bench_wiredtiger --use_lsm=0 --db=/mnt/pmem0/wt-db --value_size=1024 --benchmarks=fillrandom --use_existing_db=0 --num=1000000 --threads=4 2>&1 | tee $ext4_result_dir/fillrandom.$run
    ./db_bench_wiredtiger --use_lsm=0 --db=/mnt/pmem0/wt-db --value_size=1024 --benchmarks=readrandom --use_existing_db=1 --num=1000000 --threads=4 2>&1 | tee $ext4_result_dir/readrandom.$run

    sudo umount /mnt/pmem0
    mkfs.xfs -b size=4096 -f $pmem_device
    mount -o dax $pmem_device $mount_point
    ./db_bench_wiredtiger --use_lsm=0 --db=/mnt/pmem0/wt-db --value_size=1024 --benchmarks=fillrandom --use_existing_db=0 --num=1000000 --threads=4 2>&1 | tee $xfs_result_dir/fillrandom.$run
    ./db_bench_wiredtiger --use_lsm=0 --db=/mnt/pmem0/wt-db --value_size=1024 --benchmarks=readrandom --use_existing_db=1 --num=1000000 --threads=4 2>&1 | tee $xfs_result_dir/readrandom.$run

    sudo umount /mnt/pmem0
    mount -t pmfs -o init $pmem_device $mount_point
    ./db_bench_wiredtiger --use_lsm=0 --db=/mnt/pmem0/wt-db --value_size=1024 --benchmarks=fillrandom --use_existing_db=0 --num=1000000 --threads=4 2>&1 | tee $pmfs_result_dir/fillrandom.$run
    ./db_bench_wiredtiger --use_lsm=0 --db=/mnt/pmem0/wt-db --value_size=1024 --benchmarks=readrandom --use_existing_db=1 --num=1000000 --threads=4 2>&1 | tee $pmfs_result_dir/readrandom.$run
    '
    
    sudo umount /mnt/pmem0
    mount -t pmfs -o init,strict,num_numas=2 $pmem_device $mount_point
    ./db_bench_wiredtiger --use_lsm=0 --db=/mnt/pmem0/wt-db --value_size=1024 --benchmarks=fillrandom --use_existing_db=0 --num=10000000 --threads=4 2>&1 | tee $duofs_result_dir/fillrandom.$run
done

