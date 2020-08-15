# 负载均衡算法

## 1 什么是负载均衡？

## 2 常见的负载均衡算法有哪些？

- 随机算法
- 轮询算法
- 加权随机算法
- 加权轮询算法
- 一致性哈希算法
- 最小路径算法

### 2.1 随机算法

指的是生成一个ipList，然后根据随机值来直接获取对应ip，在没有权重配置时，随机出来的值，在循环次数越大，越趋近于各自平衡

```go
// ############# PROGECT ##############

var ipList = []string{
	"192.168.1.1",
	"192.168.1.2",
	"192.168.1.3",
	"192.168.1.4",
	"192.168.1.5",
	"192.168.1.6",
	"192.168.1.7",
	"192.168.1.8",
	"192.168.1.9",
	"192.168.1.10",
}

// 随机算法
func GetIp() string {
	// 获取0到ip列表长度的随机数
	pos := rand.Intn(len(ipList))

	return ipList[pos]
}


// ############## TEST #################

// 随机算法测试
func TestGetIp(t *testing.T) {
	res := make(map[string]int)
	for i := 0; i < 10000; i++ {
		if _, ok := res[GetIp()]; ok {
			res[GetIp()] += 1
		} else {
			res[GetIp()] = 1
		}
	}

	for s := range res {
		fmt.Printf("Count:%d\t\tIP：%v\n", res[s], s)
	}
}

// ################ RESULT ##################

=== RUN   TestGetIp
Count:942		IP：192.168.1.3
Count:912		IP：192.168.1.10
Count:999		IP：192.168.1.9
Count:988		IP：192.168.1.4
Count:968		IP：192.168.1.5
Count:1042		IP：192.168.1.6
Count:1038		IP：192.168.1.7
Count:1043		IP：192.168.1.8
Count:1037		IP：192.168.1.1
Count:1028		IP：192.168.1.2
--- PASS: TestGetIp (0.00s)
PASS

```

### 2.2 加权随机算法

在实际的工业场景下，往往每台机器的性能不一致，则无法使用随机算法来直接进行使用，而是进行按需分配，及加上权重的概念

```go
// ############# PROGECT ##############

// 加权随机算法
func GetRandWeight() string {

	ipList := map[string]int{
		"192.168.1.1":  2,
		"192.168.1.2":  8,
		"192.168.1.3":  1,
		"192.168.1.4":  9,
		"192.168.1.5":  3,
		"192.168.1.6":  7,
		"192.168.1.7":  4,
		"192.168.1.8":  6,
		"192.168.1.9":  2,
		"192.168.1.10": 8,
	}

	ip := make([]string, 0)

	for s := range ipList {
		for i := 0; i < ipList[s]; i++ {
			ip = append(ip, s)
		}
	}

	pos := rand.Intn(len(ip))

	return ip[pos]
}

// ########### TEST ###########

func TestGetRandWeight(t *testing.T) {
	res := make(map[string]int)
	for i := 0; i < 10000; i++ {
		ip := GetRandWeight()
		if _, ok := res[ip]; ok {
			res[ip] += 1
		} else {
			res[ip] = 1
		}
	}

	for s := range res {
		fmt.Printf("Count:%d\t\tIP：%v\n", res[s], s)
	}
}

// ########## RESULT ###########

=== RUN   TestGetRandWeight
Count:837		IP：192.168.1.7
Count:614		IP：192.168.1.5
Count:1445		IP：192.168.1.6
Count:371		IP：192.168.1.9
Count:396		IP：192.168.1.1
Count:1625		IP：192.168.1.2
Count:1513		IP：192.168.1.10
Count:1233		IP：192.168.1.8
Count:1758		IP：192.168.1.4
Count:208		IP：192.168.1.3
--- PASS: TestGetRandWeight (0.03s)
PASS

```

从上述程序可以看出来，当我们每次配置一个权重时，都需要将IP进行重组并冗余一个新的List，这样会造成我们的**内存开销增大**

所以我们可以优化算法

1. 计算总的权重
2. 然后在随机生成一个 [0,总权重] 的随机数
3. 循环iplist，如果不在第一个范围则直接舍去第一个权重，并将随机出来的数减去第一个权重值

```go

// ########## PROJECT ###########

func GetRandWeightPlus() string {

	ipList := map[string]int{
		"192.168.1.1":  2,
		"192.168.1.2":  8,
		"192.168.1.3":  1,
		"192.168.1.4":  9,
		"192.168.1.5":  3,
		"192.168.1.6":  7,
		"192.168.1.7":  4,
		"192.168.1.8":  6,
		"192.168.1.9":  2,
		"192.168.1.10": 8,
	}

	totalWeight := 0

	for s := range ipList {
		totalWeight += ipList[s]
	}

	pos := rand.Intn(totalWeight)

	for s := range ipList {
		if pos < ipList[s] {
			return s
		}

		pos -= ipList[s]
	}

	return ""
}

// ########### TEST ##########

func TestGetRandWeightPlus(t *testing.T) {
	res := make(map[string]int)
	for i := 0; i < 10000; i++ {
		ip := GetRandWeightPlus()
		if _, ok := res[ip]; ok {
			res[ip] += 1
		} else {
			res[ip] = 1
		}
	}

	for s := range res {
		fmt.Printf("Count:%d\t\tIP：%v\n", res[s], s)
	}
}

// ######## RESULT ########
=== RUN   TestGetRandWeightPlus
Count:1431		IP：192.168.1.6
Count:388		IP：192.168.1.9
Count:1583		IP：192.168.1.10
Count:1173		IP：192.168.1.8
Count:390		IP：192.168.1.1
Count:1827		IP：192.168.1.4
Count:193		IP：192.168.1.3
Count:1599		IP：192.168.1.2
Count:833		IP：192.168.1.7
Count:583		IP：192.168.1.5
--- PASS: TestGetRandWeightPlus (0.01s)
PASS
```

### 2.3 轮询算法

轮询则是按照数据直接进行输出，依次遍历即可

```go
// ######### PROGECT #########

var pos = 0

func GetRobinIp() string {
	ipList := []string{
		"192.168.1.1",
		"192.168.1.2",
		"192.168.1.3",
		"192.168.1.4",
		"192.168.1.5",
		"192.168.1.6",
		"192.168.1.7",
		"192.168.1.8",
		"192.168.1.9",
		"192.168.1.10",
	}

	if pos >= len(ipList) {
		pos = 0
	}

	ip := ipList[pos]

	pos++

	return ip
}

// ############ TEST #############

func TestGetRobinIp(t *testing.T) {
	res := make(map[string]int)
	for i := 0; i < 100; i++ {
		ip := robin.GetRobinIp()
		if _, ok := res[ip]; ok {
			res[ip] += 1
		} else {
			res[ip] = 1
		}
	}

	for s := range res {
		fmt.Printf("Count:%d\t\tIP：%v\n", res[s], s)
	}
}

// ######## RESULT ########

=== RUN   TestGetRobinIp
Count:10		IP：192.168.1.6
Count:10		IP：192.168.1.9
Count:10		IP：192.168.1.10
Count:10		IP：192.168.1.1
Count:10		IP：192.168.1.2
Count:10		IP：192.168.1.5
Count:10		IP：192.168.1.7
Count:10		IP：192.168.1.8
Count:10		IP：192.168.1.3
Count:10		IP：192.168.1.4
--- PASS: TestGetRobinIp (0.00s)
PASS

```

### 2.4 加权轮询算法

```go

// ######## PROGECT ########

var weightPos = 0

func GetRobinWeightIp() string {

	ipList := map[string]int{
		"192.168.1.1":  2,
		"192.168.1.2":  8,
		"192.168.1.3":  1,
		"192.168.1.4":  9,
		"192.168.1.5":  3,
		"192.168.1.6":  7,
		"192.168.1.7":  4,
		"192.168.1.8":  6,
		"192.168.1.9":  2,
		"192.168.1.10": 8,
	}

	ip := make([]string, 0)

	for s := range ipList {
		for i := 0; i < ipList[s]; i++ {
			ip = append(ip, s)
		}
	}

	if weightPos >= len(ipList) {
		weightPos = 0
	}

	host := ip[weightPos]

	weightPos++

	return host
}

// ######### TEST #########

func TestGetRobinWeightIp(t *testing.T)  {
	res := make(map[string]int)
	for i := 0; i < 100; i++ {
		ip := robin.GetRobinWeightIp()
		if _, ok := res[ip]; ok {
			res[ip] += 1
		} else {
			res[ip] = 1
		}
	}

	for s := range res {
		fmt.Printf("Count:%d\t\tIP：%v\n", res[s], s)
	}
}

// ######## RESULT ########

=== RUN   TestGetRobinWeightIp
Count:8		IP：192.168.1.10
Count:2		IP：192.168.1.3
Count:1		IP：192.168.1.9
Count:13		IP：192.168.1.6
Count:14		IP：192.168.1.8
Count:23		IP：192.168.1.4
Count:5		IP：192.168.1.1
Count:7		IP：192.168.1.5
Count:20		IP：192.168.1.2
Count:7		IP：192.168.1.7
--- PASS: TestGetRobinWeightIp (0.00s)
PASS

// ######### PROGECT ########


// ######### TEST #########

func TestGetRobinWeightIp(t *testing.T)  {
	res := make(map[string]int)
	for i := 0; i < 100; i++ {
		ip := robin.GetRobinWeightIp()
		if _, ok := res[ip]; ok {
			res[ip] += 1
		} else {
			res[ip] = 1
		}
	}

	for s := range res {
		fmt.Printf("Count:%d\t\tIP：%v\n", res[s], s)
	}
}
```