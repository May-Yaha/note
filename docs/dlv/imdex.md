# DLV

dlv 是一个命令行断点调试工具

## 环境

![go](https://img.shields.io/badge/%3E%3D-go%201.10-blue)

## 安装

~~~bash
go get github.com/go-delve/delve/cmd/dlv

# 设置环境变量，默认加载 $GOPATH/bin 下命令
echo 'export PATH=$GOPATH/bin:$PATH' >> ~/.bashrc

source ~/.bashrc
~~~

## 查看安装

~~~bash
[bae@yangzh]$ dlv version
Delve Debugger
Version: 1.5.1
Build: $Id: bca418ea7ae2a4dcda985e623625da727d4525b5 $
~~~

## 案例

### 简单案例

~~~go
// test.go

package main 
import "fmt"
 
func main() {
 nums := make([]int, 5)
 for i := 0; i < len(nums); i++ {
  nums[i] = i * i
 }
 fmt.Println(nums)
}
~~~

~~~bash
# 进行debug
dlv debug test.go

# 添加断点
(dlv) b test.go:6
Breakpoint 2 set at 0x4aa15f for main.main() ./test.go:6

# 运行断点
(dlv) c
> main.main() ./test.go:6 (hits goroutine(1):1 total:1) (PC: 0x4aa15f)
     1:	package main
     2:
     3:	import "fmt"
     4:
     5:	func main() {
=>   6:	 nums := make([]int, 5)
     7:	 for i := 0; i < len(nums); i++ {
     8:	  nums[i] = i * i
     9:	 }
    10:	 fmt.Println(nums)
    11:	}

# 打印变量
(dlv) p nums
[]int len: 1, cap: 0, [0]
~~~

### 类似 go test 进行断点调试

~~~bash
# 类似 go test 单个文件单个方法命令，具体可以自行参考百度或google
dlv test case_test.go case.go -test.run TestCase
~~~

其他流程如上个案例

### 通过结合 Goland 进行远程 remote debug 调试

1. 同步代码（可采用 fis3、ftp、smba 等）
2. 进行go remote 配置
3. 服务端运行 `dlv debug --headless --listen=:2345 --api-version=2 --accept-multiclient`

## 常用命令

命令 | 缩写 | 说明 | 示例
 --- | --- | --- | ---
break | b | 设置断点 | break [文件名:行数]
condition | cond | 设置断点的条件 | condition [断点名称/编号] [判断条件]（如i==3）
breakpoints | bp | 显示已经设置的断点 | breakpoints
clear | | 删除断点 | bp显示的断点有名称，clear [断点名称]
continue | c | 让程序运行到下一个断点处 | continue
next | n | 单步执行 | next
step | s | 进入某个函数内部，无法进入goroutine中 | step（在函数入口出执行）
stepout | so | 退出当前函数，回到进入点 | so
print | p | 打印变量的值 | print
goroutine | gr | 显示当前go协程或切换go协程 | goroutine [协程编号]
goroutines|grs | 显示全部go协程 | goroutines
restart | r | 重新运行 | 上次设置的断点依然有效
args | | 输出函数参数 |
locals | | 输出函数局部变量 |
