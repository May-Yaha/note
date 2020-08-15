该文档参考代码大全，以下是自己觉得不错的整理出来的，也会不定时更新，如有造成你的损失请联系我，我们谈谈人生
# 代码调整技术 #

## 一、逻辑 ##

### 短路求值 ###

`if(5>x) and (x<10)`

等同于

```
if (5<x) then
if(x<10) then...
```

### 停止 ###

1. 当知道结果立即停止
2. 将`for`改为`while`，`for`需要进行循环计数并检查
3. 适当`break`或者`goto`

### 频率 ###

根据运行时执行的先后顺序、频率出现次数来调整`case`或`if-then-elses`语句

### 逻辑结构性能 ###

PHP条件语句性能:

| 语言 | 类型 | 效率 |
|:--|:--|:--|
| switch | 常量（固定不变） | 高 |
| if-else | 变量 | 高 |

### 查询表代替复杂表达式 ###

![](http://i.imgur.com/rIoZ2Fp.png)

原始逻辑：

```
if((a && !c) || (a && b && c)){
    num = 1;
}else if((!a && b) || (a && !b && c)){
    num = 2;
}else if(c && !a && !b){
    num = 3;
}else{
    num = 0;
}
```

查询表：

1. 根据真值表建立数组关系
2. 建立表结构（数组）
3. 梳理关系逻辑
4. 利用下标查询

```
    categoryTable[2][2][2] = {
        // !b!c  !bc  !b!c  bc
             0    3    2    2  //!a
             1    2    1    1  //a
    }
    /**
    categoryTable[][][] = {
    // !b!c  !bc  !b!c  bc
        {{0,3},{2,2}},  //!a
        {{1,2},{1,1}}   //a
    }
    */
    num = categoryTable[a][b][c];
```

### 惰性求值 ###

当程序需要执行时开始执行或计算 

## 二、循环 ##

**循环内的判断等同于切换**

```       
//在循环里做判断
for ($i = 0; $i < count(); $i++) {
    if ($sumType == SUMTYPE_NET) {
        $netSum += $amount[i];
    } else {
        $grossSum += $amount[i];
    }
}
```

适当的将循环里的判断外提，减少重复的判断

```
//在循环外做判断
if ($sumType == SUMTYPE_NET) {
    for ($i = 0; $i < count(); $i++) {
        $netSum += $amount[i];
    }
} else {
    for ($i = 0; $i < count(); $i++) {
        $grossSum += $amount[i];
    }
}
```

*注意：以上优化代码可以提高效率，但是会降低可维护性*

###  高效率循环 ###
 
尽可能的减少在循环内部做的工作

### 合并 ###

 计数器是否相同？yes：no；
 
 *注意:*

  - 1. *合并后各自下标可能发生变化*
  - 2. *无法使用同一个循环下标*

### 展开 ###

用于少量元素、可预知元素数量适用

```
//可展开的循环
$i = 0;
while($i < $count){
    a[$i] = $i;
    $i = $i + 1;
}
```

展开后步进值从1变为n，减少了循环执行次数

```   
//展开后
$i = 0;
while($i < $count-1){
    a[$i] = $i;
    a[$i+1] = $i+1;
    $i = $i + 2;
}
if($i == $count-1){
    a[$count-1] = $count-1;
}
```

### 复合判断 ###

```
$found = FALSE;
$i = 0;
while((!$found)&&($i<count)){    //此处为复合判断
    if($item[i] == $testValue){
        $found = TRUE;
    }else{
        $i++;
    }
}   
if($found){
...
```

### 哨兵值 ###

哨兵值主要用来做遍历,可以判断长度

**具体后面研究**

###  循环多的放在内层 ###
内外层的不同次数，会极大影响循环执行次数

```
for ($i = 0; $i < 100; $i++) {
    for ($j = 0; $j < 10; $j++) {
        $netSum = $i+j;
    }
}
```

**部分用不上，暂不编写**

# 变量定义规范 #

-  变量的定义应能够完全、准确的描述该变量所代表的事物
-  通过变量名表达出'what'，而不是'how'
-  适当的长度（9-15、10-16）
-  使用对仗词

```
add/remove          添加/移除
add/delete          添加/删除
insert/delete       插入/删除
start/stop          开始/停止
begin/end           开始/结束
send/receive        发送/接收
get/set             取出/设置
get/release         获取/释放
put/get             放入/取出
up/down             向上/向下
show/hide           显示/隐藏
open/close          打开/关闭
source/target       源/目标
source/destination  源/目的地
source/sink         来源/接收器
increment/decrement 增加/减少
lock/unlock         锁/解锁
old/new             旧的/新的
first/last          第一个/最后一个
next/previous       下一个/前一个
create/destroy      创建/销毁
min/max             最小/最大
visible/invisible   可见/不可见
pop/push            出栈/入栈
store/query         存储/查询
```

- 给变量添加前缀

```
g_  全局变量
t_  类变量
m_  成员变量
c_  常量
e_  枚举型变量
```

- 缩写的原则
    - 标准缩写（字典常见的缩写）
    - 去掉前置原音（computer->cmptr,screen->scrn,apple->appl）
    - 去掉虚词（and,or,the）
    - 使用每个单词的第一个或前几个字母
    - 统一在每个单词的第几个字母截断
    - 保留第一个或最后一个字母
    - 使用名字中最重要的单词不的超过三个
    - 去除无用后缀（-ing，-ed）
    - 确保不改变变量的含义
    - 确保在8-20个字符