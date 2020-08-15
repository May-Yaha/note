# 使用 shell 编写一个钉钉值班机机器人脚本

## 思路

1. init.sh用于执行，发送
2. name.data 存放值班人信息花名册
3. queue.pid用于本周排队值
4. queue.sh用于修改队列顺序

## `init.sh`

~~~bash
#!/bin/sh

DD_URL=https://oapi.dingtalk.com/robot/send?access_token=
PID_PATH='queue.pid'
NAME_DATA='name.data'
QUEUE_PID=`cat ${PID_PATH}`
NAME=`sed -n "${QUEUE_PID},${QUEUE_PID}p" ${NAME_DATA}|awk '{print $1}'`
PHONE=`sed -n "${QUEUE_PID},${QUEUE_PID}p" ${NAME_DATA}|awk '{print $2}'`

curl ${DD_URL} \
    -H 'Content-Type: application/json' \
    -d "{\"msgtype\": \"text\",
          \"text\": {
               \"content\": \"【本周值班】${NAME}\"
          },\"at\": {\"atMobiles\": [\"${PHONE}\"]}
        }"
~~~


## `name.data`

~~~bash
张三 12345678901
李四 12345678902
王五 12345678903
赵六 12345678904
~~~

### `queue.sh`

~~~bash
#!/bin/sh

PID_PATH='queue.pid'
QUEUE_PID=`cat ${PID_PATH}`

if [[ ${QUEUE_PID} -gt 3 ]]; then
    echo '1' > ${PID_PATH}
    exit
fi

NEW_QUEUE_PID=$[ `expr ${QUEUE_PID} + 1` ]
echo ${NEW_QUEUE_PID} > ${PID_PATH}
~~~