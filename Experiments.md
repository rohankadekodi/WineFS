## Desired system configurations for reproducing results mentioned in the paper
- Ubuntu 18.04.1 LTS
- \>= 64GB DRAM
- 2 sockets (28 cores per socket)
- 112 threads (2 threads per core)
- \>= 500GiB Intel Optane DC PM module in each socket
- Support for clwb instructions (Intel cascadelake processor)

## Compile Kernel
Follow steps mentioned in [Linux-5.1](https://github.com/rohankadekodi/WineFS/blob/main/Linux-5.1/README.md)

## Performance Benchmarks
We evaluate the performance of WineFS against ext4-DAX, NOVA and xfs-DAX. We do not include SplitFS in the evaluation, as the performance of SplitFS is similar to ext4-DAX for the memory-mapped applications, which is the main use-case for WineFS. We do not include PMFS because PMFS is not able to finish the process of aging after even a week, due to poor metadata indexing structures.

The list of benchmarks and the major performance results presented in the paper are as follows:

### Memory-mapped applications

We evaluate the performance of aged file systems on 2 major memory-mapped applications mentioned in the paper: RocksDB running with the entire YCSB suite and LMDB with the fillseqbatch workload.

#### Setup RocksDB with YCSB
Follow steps mentioned in [RocksDB](https://github.com/rohankadekodi/WineFS/blob/main/RocksDB/README.md)

#### Setup LMDB with fillseqbatch
Follow steps mentioned in [LMDB](https://github.com/rohankadekodi/WineFS/blob/main/LMDB/README.md)

#### Run memory-mapped applications

```
cd scripts/
sudo ./run_mmap_applications.sh <run-id> <result-dir> <dev (/dev/pmem0)> <mnt (/mnt/pmem0)>
```

![YCSB-RocksDB-LMDB](https://github.com/rohankadekodi/WineFS/blob/main/graphs/rocksdb-ycsb-lmdb.png)
<p align="center"> Figure 1 - YCSB suite on RocksDB and LMDB fillseqbatch </p>


### POSIX Applications

We evaluate the performance of fresh file systems on 2 major system-call workloads mentioned in the paper: Filebench suite with varmail, fileserver, webserver and webproxy; WiredTiger with fillrandom and readrandom.

#### Setup Filebench

1. Install Filebench dependencies: `cd scripts/filebench; ./install_dependencies.sh; cd ../..` -- This will install Filebench dependencies
2. Compile Filebench: `cd scripts/filebench; ./compile_filebench.sh <num-threads>; cd ../..` -- This will compile filebench

#### Setup WiredTiger

1. Compile and install WiredTiger: `cd scripts/wiredtiger; sudo ./compile_wiredtiger.sh <num-threads>; cd ../..` -- This will compile and install WiredTiger in the system
2. Compile benchmarking suite: `cd scripts/wiredtiger; ./compile_benchmark.sh; cd ../..` -- This will compile the benchmarking suite for WiredTiger

#### Run system-call applications

```
cd scripts/
sudo ./run_syscall_applications.sh <run-id> <result-dir> <dev (/dev/pmem0)> <mnt (/mnt/pmem0)>
```
