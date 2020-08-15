# 使用redis-benchmark进行压力测试

## 命令解释

`root@b0e6164d93cd:/data# redis-benchmark -h`


## 测试步骤

1. 安装docker，并拉取redis
2. run docker ps
2. 测试命令

## 压测命令

使用命令：`redis-benchmark -h 127.0.0.1 -p 6379 -c 50 -n 10000`

```
[root@rdqa-rd-test294 ~]# docker pull redis

[root@rdqa-rd-test294 ~]# docker run -d --name myredis -p 6379:6379 redis
b0e6164d93cda262739cdcdc749e27e9d1b229f20d4be0c048f1cbd6b29e96a9
[root@rdqa-rd-test294 ~]# docker exec -it myredis bash

root@b0e6164d93cd:/data# redis-benchmark -h 127.0.0.1 -p 6379 -c 50 -n 10000
====== PING_INLINE ======
  10000 requests completed in 0.31 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

91.25% <= 1 milliseconds
99.55% <= 2 milliseconds
100.00% <= 2 milliseconds
31746.03 requests per second

====== PING_BULK ======
  10000 requests completed in 0.33 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

84.67% <= 1 milliseconds
99.91% <= 2 milliseconds
100.00% <= 2 milliseconds
30581.04 requests per second

====== SET ======
  10000 requests completed in 0.31 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

98.72% <= 1 milliseconds
100.00% <= 2 milliseconds
32467.53 requests per second

====== GET ======
  10000 requests completed in 0.31 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

97.21% <= 1 milliseconds
99.97% <= 2 milliseconds
100.00% <= 2 milliseconds
32154.34 requests per second

====== INCR ======
  10000 requests completed in 0.30 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

97.92% <= 1 milliseconds
100.00% <= 1 milliseconds
32894.74 requests per second

====== LPUSH ======
  10000 requests completed in 0.31 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

97.90% <= 1 milliseconds
99.95% <= 2 milliseconds
100.00% <= 2 milliseconds
32362.46 requests per second

====== RPUSH ======
  10000 requests completed in 0.31 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

98.99% <= 1 milliseconds
99.98% <= 2 milliseconds
100.00% <= 2 milliseconds
32573.29 requests per second

====== LPOP ======
  10000 requests completed in 0.31 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

97.45% <= 1 milliseconds
99.90% <= 2 milliseconds
100.00% <= 2 milliseconds
31746.03 requests per second

====== RPOP ======
  10000 requests completed in 0.31 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

97.30% <= 1 milliseconds
99.95% <= 2 milliseconds
100.00% <= 2 milliseconds
32051.28 requests per second

====== SADD ======
  10000 requests completed in 0.30 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

96.97% <= 1 milliseconds
100.00% <= 1 milliseconds
33112.59 requests per second

====== HSET ======
  10000 requests completed in 0.33 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

87.78% <= 1 milliseconds
99.99% <= 2 milliseconds
100.00% <= 2 milliseconds
30487.80 requests per second

====== SPOP ======
  10000 requests completed in 0.31 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

97.55% <= 1 milliseconds
99.97% <= 2 milliseconds
100.00% <= 2 milliseconds
32362.46 requests per second

====== LPUSH (needed to benchmark LRANGE) ======
  10000 requests completed in 0.31 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

96.91% <= 1 milliseconds
99.89% <= 2 milliseconds
100.00% <= 2 milliseconds
32154.34 requests per second

====== LRANGE_100 (first 100 elements) ======
  10000 requests completed in 0.41 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

47.84% <= 1 milliseconds
99.37% <= 2 milliseconds
99.96% <= 3 milliseconds
100.00% <= 3 milliseconds
24691.36 requests per second

====== LRANGE_300 (first 300 elements) ======
  10000 requests completed in 0.72 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

0.16% <= 1 milliseconds
87.04% <= 2 milliseconds
97.05% <= 3 milliseconds
99.68% <= 4 milliseconds
99.96% <= 5 milliseconds
100.00% <= 5 milliseconds
13812.16 requests per second

====== LRANGE_500 (first 450 elements) ======
  10000 requests completed in 0.87 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

0.14% <= 1 milliseconds
27.94% <= 2 milliseconds
95.97% <= 3 milliseconds
98.15% <= 4 milliseconds
98.90% <= 5 milliseconds
99.38% <= 6 milliseconds
99.70% <= 7 milliseconds
99.98% <= 8 milliseconds
100.00% <= 8 milliseconds
11481.06 requests per second

====== LRANGE_600 (first 600 elements) ======
  10000 requests completed in 1.11 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

0.04% <= 1 milliseconds
2.99% <= 2 milliseconds
82.11% <= 3 milliseconds
92.64% <= 4 milliseconds
99.27% <= 5 milliseconds
99.57% <= 6 milliseconds
99.67% <= 7 milliseconds
99.77% <= 8 milliseconds
99.82% <= 9 milliseconds
99.86% <= 10 milliseconds
99.90% <= 11 milliseconds
99.97% <= 12 milliseconds
100.00% <= 12 milliseconds
8984.73 requests per second

====== MSET (10 keys) ======
  10000 requests completed in 0.32 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

97.37% <= 1 milliseconds
99.85% <= 2 milliseconds
100.00% <= 2 milliseconds
31055.90 requests per second
```