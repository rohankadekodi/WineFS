## Desired system configurations for reproducing results mentioned in the paper
- Ubuntu 18.04.1 LTS
- \>= 64GB DRAM
- 2 sockets (28 cores per socket)
- 112 threads (2 threads per core)
- \>= 500GiB Intel Optane DC PM module in each socket
- Support for clwb instructions (Intel cascadelake processor)

## Compile Kernel
Follow steps mentioned in [Linux-5.1](https://github.com/rohankadekodi/WineFS/tree/main/Linux-5.1)

## Performance Benchmarks
We evaluate the performance of WineFS against ext4-DAX, NOVA and xfs-DAX. We do not include SplitFS in the evaluation, as the performance of SplitFS is similar to ext4-DAX for the memory-mapped applications as SplitFS does not optimize memory-mapped applications, which is the main use-case for WineFS. We do not include PMFS because PMFS is not able to finish the process of aging after even a week, due to poor metadata indexing structures.

The list of benchmarks and the major performance results presented in the paper are as follows:

### Memory-mapped applications

We evaluate the performance of **aged** file systems on 2 major memory-mapped applications mentioned in the paper: RocksDB running with the entire YCSB suite and LMDB with the fillseqbatch workload.

#### Aging Process

We age the images of all file systems using the Geriatrix aging framework and the Agrawal aging profile such that 75% of the file systems are utilized. Each file system takes approximately 2 days to age. We have uploaded the aged images of file systems in the `Images/` directory.

#### Setup RocksDB with YCSB
Follow steps mentioned in [RocksDB](https://github.com/rohankadekodi/WineFS/blob/main/RocksDB)

#### Setup LMDB with fillseqbatch
Follow steps mentioned in [LMDB](https://github.com/rohankadekodi/WineFS/blob/main/LMDB)

#### Run memory-mapped applications

```
cd scripts/
sudo ./run_mmap_applications.sh <start-run-id> <num-runs> <result-dir> /dev/pmem0 /mnt/pmem0
cd ..

# For example: sudo ./run_mmap_applications.sh 10 3 ../results/ /dev/pmem0 /mnt/pmem0 
(This will run RocksDB and LMDB for all aged file systems for 3 runs (Run ID 10, 11, 12) and the results will be stored in the results/ directory)
```

Note: Please make sure that the 500 GB PM partition is created on /dev/pmem0, and that the directory /mnt/pmem0 exists. Also, please keep in mind that RocksDB Run C workload has high variance, all others have low variance. For reliable results of Run C, it is advisable to run the RocksDB benchmarks multiple times.

For parsing results, use the following scripts:
```
cd scripts/
python3 parse_rocksdb.py <number-of-filesystems> <fs1> <fs2> ... <num-runs> <start-run-id> <result-dir> <output-csv-file>
cd ..

# For example: python3 parse_rocksdb.py 4 winefs nova ext4 xfs 3 10 ../results/ ../results/rocksdb_output.csv
(This will parse all the rocksdb output files and generate a CSV file)

# For example: python3 parse_lmdb.py 4 winefs nova ext4 xfs 3 10 ../results/ ../results/lmdb_output.csv
(This will parse all the LMDB output files and generate a CSV file)

```

![YCSB-RocksDB-LMDB](https://github.com/rohankadekodi/WineFS/blob/main/graphs/rocksdb-ycsb-lmdb.png)
<p align="center"> Figure 1 - YCSB suite on RocksDB and LMDB fillseqbatch </p>


### POSIX Applications

We evaluate the performance of **fresh** file systems on 2 major system-call workloads mentioned in the paper: Filebench suite with varmail, fileserver, webserver and webproxy; WiredTiger with fillrandom and readrandom.

#### Setup Filebench
Follow steps mentioned in [Filebench](https://github.com/rohankadekodi/WineFS/tree/main/Filebench)

#### Setup WiredTiger

Follow steps mentioned in [WiredTiger](https://github.com/rohankadekodi/WineFS/tree/main/WiredTiger)

#### Run POSIX applications

```
cd scripts/
sudo ./run_syscall_applications.sh <start-run-id> <num-runs> <result-dir> /dev/pmem0 /mnt/pmem0
cd ..

# For example: sudo ./run_syscall_applications.sh 10 3 ../results/ /dev/pmem0 /mnt/pmem0 
(This will run Filebench and WiredTiger for all fresh file systems for 3 runs (Run ID 10, 11, 12) and the results will be stored in the results/ directory)
```

Note: Please make sure that the 500 GB PM partition is created on /dev/pmem0, and that the directory /mnt/pmem0 exists. 

For parsing results, use the following scripts:
```
cd scripts/
python3 parse_filebench.py <number-of-filesystems> <fs1> <fs2> ... <num-runs> <start-run-id> <result-dir> <output-csv-file>
cd ..

# For example: python3 parse_filebench.py 4 winefs nova ext4 xfs 3 10 ../results/ ../results/rocksdb_output.csv
(This will parse all the Filebench output files and generate a CSV file)

# For example: python3 parse_wiredtiger.py 4 winefs nova ext4 xfs 3 10 ../results/ ../results/lmdb_output.csv
(This will parse all the WiredTiger output files and generate a CSV file)

```
