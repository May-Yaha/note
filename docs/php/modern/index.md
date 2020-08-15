# PHP

## PHP简介

### 1、过去

PHP是一门解释型[服务器](http://url.cn/5kIOhst)端脚本语言

- 编译型：

  运行前先由编译器将高级语言代码编译为对应机器的cpu汇编指令集，再由汇编器汇编为目标机器码，生成可执行文件，然最后运行生成的可执行文件。

- 解释型：
  
  在运行时由翻译器将高级语言代码翻译成易于执行的中间代码，并由解释器（例如浏览器、虚拟机）逐一将该中间代码解释成机器码并执行（可看做是将编译、运行合二为一了）。
  

### 2、PHP解释器

- HipHop Virtual Machine：HHVM，是PHP和[Hack](https://blog.csdn.net/qq_38559709/article/details/78044401)的解释器，使用即时编译器提升应用性能，减少内存用量。
- Zend

## 特性

### 3.命名空间

类似Java的jar包名，如`namespace Sysfony\Component\HttpFoundation`

#### 导入和别名

- 直接使用

```
$obj = new PHPno1\App\Index(test,123);
$obj->send();
```

- 导入

```
// 单个导入
use PHPno1\App\Index;

$obj = new Index(test,123);
$obj->send();

// 导入加别名
use PHPno1\App\Index as Ts;

$obj = new Ts(test,123);
$obj->send();

// 多重导入
use PHPno1\App\{Index,Test}

$obj = new Test(test,123);
$obj1 = new Index(index,123);
$obj->send();
$obj1->send();
```

### 4.自动加载



### 5.接口

接口是两个对象之间的契约， 让一个对象依赖另一个对象的能力。


```
imterface Test{
	public function getName();
	public function getTitle();
}

class Index implements Test{
	protected $url;
	
	punblic function __construct($url){
		$this->url = $url;
	}
	
	public function getName(){
		return $this->url;
	}
	
	public function getTitle(){
		$ch = curl_init();
		curl_setpot($ch,CURLOPT_URL,$this->url);
		
		curl_close($ch);
		
		return $html;
	}
}
```

### 6.形状

性状是类的部分实现，在PHP5.4中引入。把模块化的实现方式注入到多个无关的类中，这样满足DRY原则（Don't Repeat Youself）。

**作用：**

- 表明类可以做什么
- 提供模块化实现

```
trait Geocodable{
	protected $address;
	protected $geocoder;
	protected $grocoderResult;
	
	public function setGeocoder($geocoder){
		$this->geocoder = $geocoder;
	}

	public function setAddress($address){
		$this->address = $address;
	}
}


class Test{
	use Geocodable;
	
	// TOOD:类的实现

}

```

PHP解释器在编译时会将形状复制粘贴到类的定义体中，但是不会处理这个操作引入的不兼容问题。如果性状假定类中有特定的属性和方法，要确定相应的类中有对应的属性和方法。


### 7.生成器

生成器在PHP5.5.0中引入

创建生成器

```
function test(){
	yield 'value1';
	yield 'value2';
	yield 'value3';
}
```

使用生成器处理CSV文件

```
function getRows($file){
	$hand = fopen($file,'rb');
	
	if($handle === false){
		throw new Exception();
	}
	
	while(feof($handle) === false){
		yield fgetcsv($handle);
	}
	
	fclose($handle);
}


foreach(getRows('data.csv') as $row){
	print_r($row);
}
```

### 8.闭包

闭包和匿名函数在PHP5.3.0。闭包是指在创建时封装周围状态的函数，匿名函数就是没有名称的函数。理论上闭包和匿名函数是不同的概念，但是PHP将其视作相同概念。

创建闭包

```
$nums = array_map(function($number){
	return $number + 1;
},[1,2,3]);

var_dump($nums);
```

### 9.Zend OPcache

PHP5.5.0引入，内置字节码缓存功能。

PHP是解释型语言，PHP解释器执行PHP脚本时会解析PHP脚本代码，把PHP代码编译成一系列的Zend操作码，然后执行字节码。字节码缓存能够存储预先编译好的PHP字节码，不用每次都读取、解析和编译PHP代码。

启用Zend OPcache

编译PHP时执行`.configure`命令时必须包含`--enable-opcache`选项，并且需要在php.ini中指定Zend OPcache扩展路径，如`zend_extension=/path/to/opcache.so`

配置Zeng OPcache：


[Zend Opcache推荐设置](https://segmentfault.com/a/1190000005844450)

```
opcache.revalidate_freq=0
opcache.validate_timestamps=0
opcache.max_accelerated_files=7963
opcache.memory_consumption=192
opcache.interned_strings_buffer=16
opcache.fast_shutdown=1
```

### 10.内置PHP服务器

从5.4.0开始PHP开始内置了服务器

启动`php -S localhost:8080`

监听所有端口`php -S 0.0.0.0:8080`

配置启动`php -S localhost:8080 -c app/config/php.ini`，开发可以将php.ini文件放在项目中，自定义配置内存用量、文件上传、分析或字节码缓存

利用`php_sapiname()`函数可以查明使用的是那个服务器

```
if(php_sapi_name() === 'cli-server'{
	// 内置的PHP服务器
}else{
	// 其他web服务器
}
```

**内置的服务器一次只能处理一个请求，其他请求会受到阻碍**

## 实践

### 1.标准

#### PHP-FIG

PHP Framework Interop Group，为了实现框架的互操作性，通过接口、自动加载机制和标准风格，让框架相互合作。

#### PSR

[PHP Standards Recommendation(PHP推荐标准)](http://psr.phphub.org/)

- PSR-1 基础编码规范
- PSR-2 编码风格规范
- PSR-3 日志接口规范
- PSR-4 自动加载规范
- PSR-6 缓存接口规范
- PSR-7 HTTP 消息接口规范

### 2.组件

组件是打包代码，用于帮你解决PHP应用中某个具体的问题。[查找组件](https://packagist.org) 、[组件推荐](https://github.com/ziadoz/awesome-php)

特征：

- 作用单一
- 小型
- 合作
- 测试良好
- 文档完善

#### composer

PHP包管理工具

### 3.过滤、验证和转义

不要相信任何来自不受自己直接控制的数据源中的数据，例如：

- $_GET
- $_POST
- $_REQUEST
- $_COOKIE
- $argv
- php://stdin   标准输入(只读)
- [php://input](http://php.net/manual/zh/wrappers.php.php)
- file_get_contents()

```
<?php
//PHP CLI中，有三个系统常量，分别是STDIN、STDOUT、STDERR，代表文件句柄。
 
/**
 *@ 标准输入
 *@ php://stdin & STDIN
 *@ STDIN是一个文件句柄，等同于fopen("php://stdin", 'r')
 */
$fh = fopen('php://stdin', 'r');
echo "[php://stdin]请输入任意字符：";
$str = fread($fh, 1000);
echo "[php://stdin]你输入的是：".$str;
fclose($fh);
echo "[STDIN]请输入任意字符：";
$str = fread(STDIN, 1000);
echo "[STDIN]你输入的是：".$str;
 
/**
 *@ 标准输出
 *@ php://stdout & STDOUT
 *@ STDOUT是一个文件句柄，等同于fopen("php://stdout", 'w')
 */
$fh = fopen('php://stdout', 'w');
fwrite($fh, "标准输出php://stdout/n");
fclose($fh);
fwrite(STDOUT, "标准输出STDOUT/n");
 
/**
 *@ 标准错误，默认情况下会发送至用户终端
 *@ php://stderr & STDERR
 *@ STDERR是一个文件句柄，等同于fopen("php://stderr", 'w')
 */
$fh = fopen('php://stderr', 'w');
fwrite($fh, "标准错误php://stderr/n");
fclose($fh);
fwrite(STDERR, "标准错误STDERR/n");
```

由于外界传过来的数据会有注入的脚本，所以在处理数据上应该过滤输入、验证数据和转义输出

- **过滤输入：**可使用`htmlentities`函数，尽量不要使用正则表达式过滤HTML，例如`preg_replace`、`preg_replace_all`、`preg_replace_call back()`，正则表达式比较复杂，而且出错几率高
- **过滤查询：**可以使用PDO预处理语句

### SQL查询

`filter_var`
