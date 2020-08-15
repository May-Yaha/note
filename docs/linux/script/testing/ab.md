# 基于 ab 进行压测的脚本

有时候临时测试，只需要预估值，不需要精确值的时候可以使用该脚本，如：

`./ab.sh -N 100000 -C 10 -R 3 -I 10 -X 50 -J 2 -S 5 -U -T 300 'xxx'`

## `ab` 返回参数解释

~~~bash
Document Path: /phpinfo.php
#测试的页面
Document Length: 50797 bytes
#页面大小
Concurrency Level: 1000
#测试的并发数
Time taken for tests: 11.846 seconds
#整个测试持续的时间
Complete requests: 4000
#完成的请求数量
Failed requests: 0
#失败的请求数量
Write errors: 0
Total transferred: 204586997 bytes
#整个过程中的网络传输量
HTML transferred: 203479961 bytes
#整个过程中的HTML内容传输量
Requests per second: 337.67 [#/sec] (mean)
#最重要的指标之一，相当于LR中的每秒事务数，后面括号中的mean表示这是一个平均值
Time per request: 2961.449 [ms] (mean)
#最重要的指标之二，相当于LR中的平均事务响应时间，后面括号中的mean表示这是一个平均值
Time per request: 2.961 [ms] (mean, across all concurrent requests)
#每个连接请求实际运行时间的平均值
Transfer rate: 16866.07 [Kbytes/sec] received
#平均每秒网络上的流量，可以帮助排除是否存在网络流量过大导致响应时间延长的问题
Connection Times (ms)
min mean[+/-sd] median max
Connect: 0 483 1773.5 11 9052
Processing: 2 556 1459.1 255 11763
Waiting: 1 515 1459.8 220 11756
Total: 139 1039 2296.6 275 11843
~~~


## 简易脚本

~~~bash
#!/bin/bash
echo '*===================================================*'
echo '| 本脚本工具基于ab(Apache benchmark)，请先安装好ab, awk |'
echo '| 注意： |'
echo '| shell默认最大客户端数为1024 |'
echo '| 如超出此限制，请执行以下命令： |'
echo '| ulimit -n 655350 |'
echo '*===================================================*'
function usage() {
 echo ' 命令格式：'
 echo ' ab-test-tools.sh'
 echo ' -N|--count 总请求数，缺省 : 5w'
 echo ' -C|--clients 并发数, 缺省 : 100'
 echo ' -R|--rounds 测试次数, 缺省 : 10 次'
 echo ' -S|-sleeptime 间隔时间, 缺省 : 10 秒'
 echo ' -I|--min 最小并发数,　缺省: 0'
 echo ' -X|--max 最大并发数，缺省: 0'
 echo ' -J|--step 次递增并发数'
 echo ' -T|--runtime 总体运行时间,设置此项时最大请求数为5w'
 echo ' -P|--postfile post数据文件路径'
 echo ' -U|--url 测试地址'
 echo ''
 echo ' 测试输出结果*.out文件'
 exit;
}
# 定义默认参数量
# 总请求数
count=50000
# 并发数
clients=100O
# 测试轮数
rounds=10
# 间隔时间
sleeptime=10
# 最小并发数
min=0
# 最大数发数
max=0
# 并发递增数
step=0
# 测试地址
url=''
# 测试限制时间
runtime=0
# 传输数据
postfile=''
ARGS=`getopt -a -o N:C:R:S:I:X:J:U:T:P:h -l count:,client:,round:,sleeptime:,min:,max:,step:,runtime:,postfile:,help -- "$@"`
[ $? -ne 0 ] && usage
eval set -- "${ARGS}"
while true
do
 case "$1" in
 -N|--count)
 count="$2"
 shift
 ;;

 -C|--client)
 clients="$2"
 shift
 ;;
 -R|--round)
 rounds="$2"
 shift
 ;;
 -S|--sleeptime)
 sleeptime="$2"
 shift
 ;;
 -I|--min)
 min="$2"
 shift
 ;;
 -X|--max)
 max="$2"
 shift
 ;;
 -J|--step)
 step="$2"
 shift
 ;;
 -U|--url)
 url="$2"
 shift
 ;;
 -T|--runtime)
 runtime="$2"
 shift
 ;;
 -P|--postfile)
 postfile="$2"
 shift
 ;;
 -h|--help)
 usage
 ;;
 --)
 shift
 break
 ;;
 esac
shift
done
# 参数检查
if [ x$url = x ]
then
 echo '请输入测试url，非文件/以为结束'
 exit
fi
flag=0
if [ $min != 0 -a $max != 0 ]
then
 if [ $max -le $min ]
 then
 echo '最大并发数不能小于最小并发数'
 exit
 fi
 if [ $step -le 0 ]
 then
 echo '并发递增步长不能<=0'
 exit
 fi
 if [ $min -lt $max ]
 then
 flag=1
 fi
fi
# 生成ab命令串
cmd="ab -k -r"
#　数据文件
if [ x$postf != x ]
then
 cmd="$cmd -p $postf"
fi
if [ x$tl != x -a $tl != 0 ]
then
 max=50000;
 cmd="$cmd -t$tl"
fi
cmd="$cmd -n$count"
echo '-----------------------------';
echo '测试参数';
echo " 总请求数：$count";
echo " 并发数：$clients";
echo " 重复次数：$rounds 次";
echo " 间隔时间：$sleeptime 秒";
echo " 测试地址：$url";
if [ $min != 0 ];then
echo " 最小并发数：$min";
fi
if [ $max != 0 ];then
echo " 最大并发数：$max";
fi
if [ $step != 0 ];then
echo " 每轮并发递增：$step"
fi
# 指定输出文件名
datestr=`date +%Y%m%d%H%I%S`
outfile="$datestr.out";
# runtest $cmd $outfile $rounds $sleeptime
function runtest() {
 # 输出命令
 echo "";
 echo ' 当前执行命令：'
 echo " $cmd"
 echo '------------------------------'
 # 开始执行测试
 cnt=1
 while [ $cnt -le $rounds ];
 do
 echo "第 $cnt 轮 开始"
 $cmd >> $outfile
 echo "

" >> $outfile
 echo "第 $cnt 轮 结束"
 echo '----------------------------'
 cnt=$(($cnt+1))
 if [ $cnt -le $rounds ]; then
 echo "等待 $sleeptime 秒"
 sleep $sleeptime
 fi
 done
}
temp=$cmd;
if [ $flag != 0 ]; then
 cur=$min
 over=0
 while [ $cur -le $max ]
 do
 cmd="$temp -c$cur $url"
 runtest $cmd $outfile $rounds $sleeptime
 cur=$(($cur+$step))
 if [ $cur -ge $max -a $over != 1 ]; then
 cur=$max
 over=1
 fi
 done
else
 cmd="$cmd -c$clients $url"
 runtest $cmd $outfile $rounds $sleeptime
fi
# 分析结果
if [ -f $outfile ]; then
echo '本次测试结果如下：'
echo '+------+----------+----------+---------------+---------------+---------------+--------------------+--------------------+'
echo '| 序号 | 总请求数 | 并发数 | 失败请求数 | 每秒事务数 | 平均事务(ms) | 并发平均事务数(ms) |　 总体传输字节数 |'
echo '+------+----------+----------+---------------+---------------+---------------+--------------------+--------------------+'
comp=(`awk '/Complete requests/{print $NF}' $outfile`)
concur=(`awk '/Concurrency Level:/{print $NF}' $outfile`)
fail=(`awk '/Failed requests/{print $NF}' $outfile`)
qps=(`awk '/Requests per second/{print $4F}' $outfile`)
tpr=(`awk '/^Time per request:(.*)(mean)$/{print $4F}' $outfile`)
tpr_c=(`awk '/Time per request(.*)(mean, across all concurrent requests)/{print $4F}' $outfile`)
trate=(`awk '/Transfer rate/{print $3F}' $outfile`)
for ((i=0; i<${#comp[@]}; i++))
do
 echo -n "|"
 printf '%6s' $(($i+1))
 printf "|"
 printf '%10s' ${comp[i]}
 printf '|'

 printf '%10s' ${concur[i]}
 printf '|'
 printf '%15s' ${fail[i]}
 printf '|'
 printf '%15s' ${qps[i]}
 printf '|'
 printf '%15s' ${tpr[i]}
 printf '|'
 printf '%20s' ${tpr_c[i]}
 printf '|'
 printf '%20s' ${trate[i]}
 printf '|'
 echo '';
 echo '+-----+----------+----------+---------------+---------------+---------------+--------------------+--------------------+'
done
echo ''
fi
~~~