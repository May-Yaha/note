# awk

## awk 实例

~~~bash
~ » cat mi_info
# mi6-1 5.15" 835 6G 64G 3350mAh 2499
# mi6-2 5.15" 835 6G 128G 3350mAh 2899
# minote3-1 5.5" 660 6G 64G 3500mAh 2499
# minote3-2 5.5" 660 6G 128G 3500mAh 2899
# mix2-1 5.99" 835 6G 64G 3400mAh 3299
# mix2-2 5.99" 835 6G 128G 3400mAh 3599
# mix2-3 5.99" 835 6G 256G 3400mAh 3999

# 字符串查找，默认的模式匹配中就已经包含了 if 的意思了
awk '/2499/' mi_info

# mi6-1 5.15" 835 6G 64G 3350mAh 2499
# minote3-1 5.5" 660 6G 64G 3500mAh 2499

awk '$5=="256G"' mi_info
# mix2-3 5.99" 835 6G 256G 3400mAh 3999

awk '$1 ~ "note"{print}' mi_info
# minote3-1 5.5" 660 6G 64G 3500mAh 2499
# minote3-2 5.5" 660 6G 128G 3500mAh 2899

awk '$0 ~ /note/{print $1, "MEMSIZE->", $3, "Price->", $NF}' mi_info
# minote3-1 MEMSIZE-> 6G Price-> 2499
# minote3-2 MEMSIZE-> 6G Price-> 2899


## -f 示例

# cat awkfile
/note/{
        test="price is"
        print $1, test, $NF
}

awk -f awkfile mi_info
# minote3-1 price is 2499
# minote3-2 price is 2899

## -v 示例
awk -v test="price is" '/note/{ print $1, test, $NF}' mi_info
# minote3-1 price is 2499
# minote3-2 price is 2899


cat showargs.awk

BEGIN {
    print "ARGC= ", ARGC
    for (k=0; k<ARGC; k++) {
        print "ARGV["k"]=["ARGV[k]"]"
        }
}

awk -f showargs.awk mi_info
# ARGC=  2# ARGV[0]=[awk]
# ARGV[1]=[mi_info]
## 求和
awk '{sum+=$NF} END {print "Sum = ", sum}' mi_info
# Sum =  21693


## 求平均
awk '{sum+=$NF} END {print "Average = ", sum/NR}' mi_info
# Average =  3099


## 求最大值
awk 'BEGIN {max = 0} {if ($NF>max) max=$NF fi} END {print "Max=", max}' mi_info 
# Max= 3999


## 求最小值（min的初始值设置一个超大数即可）
awk 'BEGIN {min = 1999999} {if ($NF<min) min=$NF fi} END {print "Min=", min}' mi_info
# Min= 2499


# 求访问次数的Top 10 Resource，可以根据此进行优化
cat logs/`date +%u`.log | grep -v '172.16' |grep -v '127.0.0.1' \
    | awk '{ if(index($1,"219.141.246")!=0) print $2; else print $1 }' \
    | sort | uniq -c | sort -n | tail -n 10


# awk的范围模式也是封闭范围。
# 在所有记录中他们会顺序进行多次匹配，第一次匹配完后还可以进行下面接下来的第二次、第三次可能的匹配范围。
# 如果开头匹配到了，但是没有结尾的话，会把整个文件记录的末尾当作是这次匹配的结尾作为范围
awk '/mi6/,/note/ {print NR, $1, $NF}' mi_info 
# 1 mi6-1 2499
# 2 mi6-2 2899
# 3 minote3-1 2499

# 忽略大小写
awk '{IGNORECASE=1}; $1~"MI" {print NR,$0}' mi_info
# "所有信息"


# 每 5 行合并为 1 行
BEGIN {
    a = 0;
    s = "";
}
{
    a += 1;
    s = s" | "$0
    if (a % 5 == 0) {
        print s;
        s = "";
    }
}
END {
    print s
}


awk 'BEGIN{a="100"; b="10test10"; print (a+b+0);}'
# 110
# 只需要将变量通过 "+" 连接运算。自动强制将字符串转为整型。
# 非数字变成 0，发现第一个非数字字符，后面自动忽略。


awk 'BEGIN{a=100;b=100;c=(a""b);print c}'
# 100100
# 只需要将变量与 "" 符号连接起来运算即可。


awk 'BEGIN{a="a";b="b";c=(a+b);print c}'
# 0
# 字符串连接操作通"二"，"+"号操作符。模式强制将左右2边的值转为 数字类型。然后进行操作。
~~~

## split（按特定字符串切分）

~~~bash
awk '{split($7,a,"?");print a[1]}'
~~~

## match（正则匹配）

~~~bash
awk 'match($0,/(module=[a-zA-Z0-9]+).*(curl_errmsg=[a-zA-Z0-9_\+]*).*(uri=[a-zA-Z0-9\/_]+).*(err_no=[\-0-9]+).*(err_info=[a-zA-Z0-9_\+]*)/,a){print a[1]"\t"a[2]"\t"a[3]"\t"a[4]"\t"a[5]}'
~~~

## 实例

### 耗时统计

~~~bash
awk '{s[$1]+=$2;sum[$1]=sum[$1]+1}END{for(i in s){print sum[i],i,s[i]/sum[i]}}' yangzh.log|sort -k1rn
~~~

## 行列转换

给定一个文件 file.txt，转置它的内容。

你可以假设每行列数相同，并且每个字段由 ' ' 分隔.

~~~bash
# 输入
name age
alice 21
ryan 30

# 输出
name alice ryan
age 21 30

# code
awk 'BEGIN{
        c=0;
    } {
        for(i=1;i<=NF;i++) {
            num[c,i] = $i;
        } 
        c++;
    } END{ 
        for(i=1;i<=NF;i++){
            str=""; 
            for(j=0;j<NR;j++){ 
                if(j>0){
                    str = str" "
                } 
                str= str""num[j,i]
            }
            printf("%s\n", str)
        }
    }' file.txt
~~~

## 过滤电话号码

给定一个包含电话号码列表（一行一个电话号码）的文本文件 file.txt，写一个 bash 脚本输出所有有效的电话号码。

你可以假设一个有效的电话号码必须满足以下两种格式： (xxx) xxx-xxxx 或 xxx-xxx-xxxx。

~~~bash
# 输入
987-123-4567
123 456 7890
(123) 456-7890

# 输出
987-123-4567
(123) 456-7890

# code
grep -wE '([0-9]{3}-[0-9]{3}-[0-9]{4})|(\([0-9]{3}\) [0-9]{3}-[0-9]{4})' file.txt
~~~
