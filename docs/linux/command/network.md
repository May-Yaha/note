# `dig` 域名解析

`dig nlogtj.zuoyebang.cc/log/yikenotice.gif`

```
[na-cs-0-122 ~ $] dig nlogtj.zuoyebang.cc/log/yikenotice.gif

; <<>> DiG 9.8.2rc1-RedHat-9.8.2-0.47.rc1.el6 <<>> nlogtj.zuoyebang.cc/log/yikenotice.gif
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NXDOMAIN, id: 23806
;; flags: qr rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 0

;; QUESTION SECTION:
;nlogtj.zuoyebang.cc/log/yikenotice.gif.    IN A

;; AUTHORITY SECTION:
.           10800   IN  SOA a.root-servers.net. nstld.verisign-grs.com. 2019030101 1800 900 604800 86400

;; Query time: 4 msec
;; SERVER: 10.16.87.28#53(10.16.87.28)
;; WHEN: Sat Mar  2 12:10:56 2019
;; MSG SIZE  rcvd: 131
```

- `status`:`NOERROR`表示查询没有什么错误
- `QUESTION SECTION`:表示需要查询的内容，这里需要查询域名的A记录
- `ANSWER SECTION`:表示查询结果，返回A记录的IP地址。600表示本次查询缓存时间，在600秒本地DNS服务器可以直接从缓存返回结果
- `Query time`:表示查询完成时间
- `SERVER`:10.16.87.28#53(10.16.87.28)，表示本地DNS服务器地址和端口号
- `AUTHORITY SECTION`:表示从那台DNS服务器获取到具体的A记录信息。