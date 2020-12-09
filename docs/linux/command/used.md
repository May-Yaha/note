# 常用命令汇聚

* [nginx 耗时统计](#nginx耗时统计)
* [生成8位随机字符串](#生成8位随机字符串)
* [生成8位随机字符串~数字](#生成8位随机字符串~数字)
* [按颜色输出](#按颜色输出)
* [批量创建用户](#批量创建用户)
* [检查包是否安装](#检查包是否安装)
* [检查服务状态](#检查服务状态)
* [免密码登录](#免密码登录)
* [统计词频](#统计词频)

---

## nginx耗时统计

~~~bash
awk '{s[$1]+=$2;sum[$1]=sum[$1]+1}END{for(i in s){print sum[i],i,s[i]/sum[i]}}' yangzh.log|sort -k1rn
~~~

[`回到顶部`](#常用命令汇聚)

## 生成8位随机字符串

~~~bash
// method 1
echo $RANDOM|md5sum|cut -c 1-8

// method 2
openssl rand -base64 4

// method 3
cat /proc/sys/kernel/random/uuid | cut -c 1-8
~~~

[`回到顶部`](#常用命令汇聚)

## 生成8位随机字符串~数字

~~~bash
// method 1
echo $RANDOM|cksum|cut -c 1-8

// method 2
openssl rand -base64 4|cksum |cut -c 1-8

// method 3
date +%N| cut -c 1-8
~~~

[`回到顶部`](#常用命令汇聚)

## 按颜色输出

~~~bash
// method 1
function echo color() {
    if [ "${1}" == "green" ]; then
        echo —e "\033[32;40m${2}\033[Om"
    elif [ "${1}" == "red" ]; then
        echo —e "\033[31;4Orn${2}\033[Om"
    fi
}

// method 2
function echo color() {
    case "${1}" in
        green)
            echo —e "\033[32;40m${2}\033[Om"
        red)
            echo —e "\033[31;40m${2}\033[Om"
        *)
            echo "Example: echo color red string"
    esac
}
~~~

[`回到顶部`](#常用命令汇聚)

## 批量创建用户

~~~bash
#!/bin/bash
DATE=$(date +%F_%T)
USER_FILE=user.txt
echo color(){
    if [ "${1}" == "green" ]; then
        echo —e "\033[32;40m${2}\033[Om"
    elif [ "${1}" == "red" ]; then
        echo —e "\033[31;40m${2}\033[Om"
    fi
}

# Backup the file first if the userfile exists and its size is larger

if [ -s "${USER_FILE}" ]; then
    mv "${USER_FILE}" "${USER FILE}-${DATE}.bak"
    echo_color green "${UER_FILE} exist, rename ${USER_FILE}-${DATE}.bak"
fi

echo -e "User\tPassword" >> "${USER_FILE}"
echo "-----------------" >> "${USER_FILE}"

for USER in user{1..10}; do
    if ! id ${USER} &>/dev/null; then
        PASS=$(echo ${RANDOM}|md5sunt|cut -c 1-8)
        useradd ${USER}
        echo ${PASS}|passwd --stdin ${USER} &> /dev/null
        echo -e "${USER}\t${PASS}" >> ${USER_FILE}
        echo "${USER} User create successful."
    else
        echo_color red "${USER} User already exists!"
    fi
done
~~~

[`回到顶部`](#常用命令汇聚)

## 检查包是否安装

~~~bash
#!/bin/bash
if rpm -q sysstat &> /dev/null; then
    echo "sysstat is already installed"
else
    echo "sysstat is not installed"
fi
~~~

[`回到顶部`](#常用命令汇聚)

## 检查服务状态

~~~bash
#!/bin/bash
PORT_C=`ss -anu|grep -c 123`
PS_C=`ps -ef|grep ntpd|grep -vc grep`

if [ ${PORT_C} -eq 0 -o ${PS_C} -eq 0 ]; then
    echo "Body" | mail -s "Subject" dst@example.com
fi
~~~

[`回到顶部`](#常用命令汇聚)

## 免密码登录

1. 检查远程服务器`/ect/ssh/sshd.config`下`PasswordAuthentication`状态是否为yes，可以关闭，则禁用密码登录
2. 删除远程服务器中原有的`.ssh`目录及其子文件，然后分别执行`mkdir ~/.ssh` 和 `touch ~/.ssh/authorized_keys`命令
3. 删除本地的.ssh目录及其子文件，利用`ssh-keygen -t rsa`生成密钥
4. 在本地利用`scp ~/.ssh/id_rsa.pub xx@xxxx:` 记得末尾加上`":"`
5. 远程服务器上将上传的公钥复制在`authorized_keys`中，`cat ~/id_rsa.pub >> ~/.ssh/authorized_keys`
6. 更改服务器`.ssh`文件权限，`chmod 700 ~/.ssh` , `chmod 600 ~/.ssh/authorized_keys`

[`回到顶部`](#常用命令汇聚)

## 统计词频

### 题目

写一个 bash 脚本以统计一个文本文件 words.txt 中每个单词出现的频率。

~~~bash
# 输出：
the day is sunny the the
the sunny is is

# 输出：
the 4
is 3
sunny 2
day 1

# code
cat words.txt |xargs -n1|sort|uniq -c|sort -k1rn|awk '{print $2" "$1}'
~~~

[`回到顶部`](#常用命令汇聚)
