# CI源码分析

## 1. Ci的加载流程

## 2. CI的优势

## 3. Router（路由）

Router 检查 HTTP 请求，以确定如何处理该请求；
如果存在缓存文件，将直接输出到浏览器，不用走下面正常的系统流程；

## 4. security（参数处理、安全性检测）

在加载应用程序控制器之前，对 HTTP 请求以及任何用户提交的数据进行安全检查；

## 5. Controller（应用控制器）

控制器加载模型、核心类库、辅助函数以及其他所有处理请求所需的资源；

## 6. View（视图渲染）

最后一步，渲染视图并发送至浏览器，如果开启了缓存，视图被会先缓存起来用于 后续的请求。


## 一、加载index.php文件

1. 从`$_SERVER['CI_ENV']`中获取`ENVIRONMENT`，来判断是生产还是开发模式
2. 根据模式设置日志错误级别，如下：

```
switch (ENVIRONMENT)
{
    case 'development':
        error_reporting(-1);
        ini_set('display_errors', 1);
    break;

    case 'testing':
    case 'production':
        ini_set('display_errors', 0);
        error_reporting(E_ALL & ~E_NOTICE & ~E_DEPRECATED & ~E_STRICT & ~E_USER_NOTICE & ~E_USER_DEPRECATED);
    break;

    default:
        header('HTTP/1.1 503 Service Unavailable.', TRUE, 503);
        echo 'The application environment is not set correctly.';
        exit(1); // EXIT_ERROR
}
```
3. 定义一些基础的文件路径变量
- `$system_path = 'system';`
- `$application_folder = 'application';`
- `$view_folder = '';`
4. `defined('STDIN')`定义标准输入，使其ci能够在CLI模式下正常运行
5. 设置ci框架system核心目录文件路径
6. 检查system文件夹是否存在
7. 设置基本环境路径

- ` define('SELF', pathinfo(__FILE__, PATHINFO_BASENAME));`定义常量index.php
- `define('BASEPATH', $system_path);`定义`system`路径常量
- `define('FCPATH', dirname(__FILE__).DIRECTORY_SEPARATOR);`定义项目根目
- `define('SYSDIR', basename(BASEPATH));`定义`system`常量

输出结果按顺序如下：

```
string(9) "index.php"
string(34) "/data/code/php/CodeIgniter/system/"
string(27) "/data/code/php/CodeIgniter/"
string(6) "system"
```
8. 检查app目录，将完整路径定义为常量`APPPATH`
9. 查看views目录，将完整的路径定义为常量`VIEWPATH`
10. 加载`CodeIgniter.php`文件
## 二、core/CodeIgniter.php文件
1. 定义`CI_VERSION`版本号
2. 加载配置文件
- 加载development模式配置文件
```
    if (file_exists(APPPATH.'config/'.ENVIRONMENT.'/constants.php'))
    {
        require_once(APPPATH.'config/'.ENVIRONMENT.'/constants.php');
    }
```
- 加载其他模式配置文件
```
    if (file_exists(APPPATH.'config/constants.php'))
    {
        require_once(APPPATH.'config/constants.php');
    }
```
3. 加载`core/Common.php`文件
4. 通过`set_error_handler()`函数设置用户自定义的错误处理程序，触发Common错误处理函数`_error_handler`
6. 通过`set_exception_handler()`函数设置用户定义的异常处理函数，触发Common
    `_exception_handler`
7. 通过`register_shutdown_function()`注册一个会在php中止时执行的函数，触发Common`_shutdown_handler`
8. 添加子类前缀
```
    if ( ! empty($assign_to_config['subclass_prefix']))
    {
        get_config(array('subclass_prefix' => $assign_to_config['subclass_prefix']));
    }

```
9. 检查是否使用composer的psr-4自动加载机制
10. 启动计时器
```
    // 实例化core中的Benchmark类
    $BM =& load_class('Benchmark', 'core');
    // 启动计时
    $BM->mark('total_execution_time_start');
    $BM->mark('loading_time:_base_classes_start');
```
11. 初始化配置相关类
12. 初始化HOOKS相关类
13. 设置字符集
14. 引入扩展兼容包
```
    require_once(BASEPATH.'core/compat/mbstring.php');
    require_once(BASEPATH.'core/compat/hash.php');
    require_once(BASEPATH.'core/compat/password.php');
    require_once(BASEPATH.'core/compat/standard.php');
```
15. 加载Utf8、URL、Router、Output类
16. 检查app是否有缓存文件
17. 加载Security、Input、Lang类
18. 引入`require_once BASEPATH.'core/Controller.php';`基础控制器
19. 返回当前`CI_Controller`实例对象
20. 路由检查

## 三、core/Common.php文件

1. 添加常用的函数

- `is_php`：检查当前php版本是否满足框架版本
- `is_really_writable`：检查对`/data/code/php/CodeIgniter/application/logs/`文件夹是否具有读写权限
- `load_class`：加载系统自带的类你自己扩展类
- `is_loaded`：追踪所有已加载的class
- `get_config`：加载`config/config.php`
- `config_item`：将对应的配置转化为数组形式
- `get_mimes`：返回从配置/ mimes.php MIME类型的数组
- `is_https`：检查是否是HTTPS方式请求
- `is_cli`：检查是否是CLI模式请求
- `show_error`：展示错误信息
- `show_404`：定义错误信息
- `log_message`：调用Log组件记录log信息
- `set_status_header`：设置HTTP响应头信息
- `_error_handler`、`_exception_handler`：根据当前设置的error_reporting的设置和配置文件中threshold的设置来决定PHP错误的显示和记录
- `_shutdown_handler`：中断程序执行
- `remove_invisible_characters`：去除不可见字符
- `html_escape`：返回HTML转义变量
- `_stringify_attributes`：函数stringify使用HTML标签属性，用于将字符串、数组或属性的对象转换为字符串的辅助函数
- `function_usable`：检查可用函数%