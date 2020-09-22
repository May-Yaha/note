# sed

## 替换字符串

~~~bash
[yaha@Yaha ~]$ echo SELECT+xxx+as+xxx%2C+FROM+***+WHERE+%28xxx+in+%281234567%29+limit+0%2C+1000 | sed 's/%2C/,/g' | sed 's/+/ /g' |sed 's/%28/(/g'|sed 's/%29/)/g'
SELECT xxx as xxx FROM ***** WHERE (xxx in (1234567)) limit 0, 1000
~~~

**注意**

Mac下参数略微不同，-i后需要接上备份输出文件后缀，如：

~~~bash
 sed -i "" "s/h5bp/yuan/g" `grep -rl 'h5bp' ./`
~~~

## 查看指定行数

`sed -n '2,2p' ./test.log`