# 常用命令汇聚

## nginx 耗时统计
```
awk '{s[$1]+=$2;sum[$1]=sum[$1]+1}END{for(i in s){print sum[i],i,s[i]/sum[i]}}' yangzh.log|sort -k1rn
```

## 生成8位随机字符串(数字)

```
echo $RANDOM|md5sum|cut -c 1-8
openssl rand -base64 6
cat /proc/sys/kernel/random/uuid | cut -c 1-8
```

```
echo $RANDOM|cksum |cut -c 1-8
openssl rand -base64 8|cksum |cut -c 1-8
cat /proc/sys/kernel/random/uuid |cksum| cut -c 1-8
date +%N|cut -c 1-8
```

## 免密码登录

1. 检查远程服务器`/ect/ssh/sshd.config`下`PasswordAuthentication`状态是否为yes，可以关闭，则禁用密码登录
2. 删除远程服务器中原有的`.ssh`目录及其子文件，然后分别执行`mkdir ~/.ssh` 和 `touch ~/.ssh/authorized_keys`命令
3. 删除本地的.ssh目录及其子文件，利用`ssh-keygen -t rsa`生成密钥
4. 在本地利用`scp ~/.ssh/id_rsa.pub xx@xxxx:` 记得末尾加上`":"`
5. 远程服务器上将上传的公钥复制在`authorized_keys`中，`cat ~/id_rsa.pub >> ~/.ssh/authorized_keys`
6. 更改服务器`.ssh`文件权限，`chmod 700 ~/.ssh` , `chmod 600 ~/.ssh/authorized_keys`

## 统计词频

### 题目

写一个 bash 脚本以统计一个文本文件 words.txt 中每个单词出现的频率。

输出：

```
the day is sunny the the
the sunny is is
```

输出：

```
the 4
is 3
sunny 2
day 1
```

```shell
cat words.txt |xargs -n1|sort|uniq -c|sort -k1rn|awk '{print $2" "$1}'
```