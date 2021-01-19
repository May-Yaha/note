# 设计原则

[TOC]

---

## ISP（接口隔离原则）

### 问题

设计应用程序时，类的接口不是内聚的。不同的客户端只包含集中的部分功能，但系统会强制客户端实现模块中所有方法，并且还要编写一些哑方法。这样的接口成为胖接口或者是接口污染，这样的接口会给系统引入一些不当的行为，资源浪费，影响其他客户端程序增强了耦合性等

### 定义

- 不应该强迫客户端依赖与他们不需要的方法/功能
- 一个类对一个类的依赖应该建立在最小的接口上
- 接口的实现类应该只呈现为单一职责原则

### 实例

某个人开始创建一个公司，起初只有一个人，它就只有工作和睡觉，如：

~~~php
class Worker{
        public function work()
        {
            return 'Worker work!';
        }

        public function seelp()
        {
            return 'Worker seelp!';
        }
}

class Organization
{
    public function manager(Worker $worker)
    {
        $worker->work();
        $worker->seelp();
    }
}
~~~

突然有一天公司扩大规模，开始分出不同的工作类型(PHP和Python)，他们具有相同的工作类型，都是写代码，但是他们的输出不同，如：

~~~php
class PHPWorker
{
    public function work()
    {
        return 'PHPWorker work!';
    }

    public function seelp()
    {
        return 'PHPWorker seelp!';
    }
}

class PythonWorker
{
    public function work()
    {
        return 'PythonWorker work!';
    }

    public function seelp()
    {
        return 'PythonWorker seelp!';
    }
}

class Organization
{
    public function phpManager(PHPWorker $worker)
    {
        $worker->work();
        $worker->seelp();
    }
    
    public function pythonManager(PythonWorker $worker)
    {
        $worker->work();
        $worker->seelp();
    }

}
~~~

如果上述这样管理就会造成本来可以一个人管理的却要分成两个人，所以对他们的动作进行统一，如：

~~~php
interface Worker
{
    public function work();
    public function seelp();
}

class PHPWorker implements Worker
{
    public function work()
    {
        return 'PHPWorker work!';
    }

    public function seelp()
    {
        return 'PHPWorker seelp!';
    }
}

class PythonWorker implements Worker
{
    public function work()
    {
        return 'PythonWorker work!';
    }

    public function seelp()
    {
        return 'PythonWorker seelp!';
    }
}

class Organization
{
    public function manager(Worker $worker)
    {
        $worker->work();
        $worker->seelp();
    }
}
~~~

通过一个接口让两个类必须实现接口的方式，让后我们管理接口，就相当于制定了一套标准，我不用关心内部实现，我只需要知道他们按照我的标准进行相应的动作，给出输出即可

随着团队的越来越大，我们逐渐出现了QA，由于业务庞大，QA只工作不休息，就会出现入下情况

~~~php
interface Worker
{
    public function work();

    public function seelp();
}

class PHPWorker implements Worker
{
    public function work()
    {
        return 'PHPWorker work!';
    }

    public function seelp()
    {
        return 'PHPWorker seelp!';
    }
}

class PythonWorker implements Worker
{
    public function work()
    {
        return 'PythonWorker work!';
    }

    public function seelp()
    {
        return 'PythonWorker seelp!';
    }
}

class QAWorker implements Worker
{
    public function work()
    {
        return 'QAWorker work!';
    }

    public function seelp()
    {
        return null;
    }
}

class Organization
{
    public function manager(Worker $worker)
    {
        $worker->work();
        $worker->seelp();
    }
}
~~~

上述例子就会导致本不需要`seelp()`方法，却需要强制实现该方法，所以只能`return null;`，所以我们需要对接口进行拆解，从而达到接口隔离

整体优化后如下：

~~~php
interface WorkInterface
{
    public function work();
}

interface SeelpInterface
{
    public function seelp();
}

interface WorkerInterface
{
    public function beManager();
}

class PHPWorker implements WorkerInterface, SeelpInterface, WorkInterface
{
    public function work()
    {
        return 'PHPWorker work!';
    }

    public function seelp()
    {
        return 'PHPWorker seelp!';
    }

    public function beManager()
    {
        $this->work();
        $this->seelp();
    }
}

class PythonWorker implements WorkerInterface, SeelpInterface, WorkInterface
{
    public function work()
    {
        return 'PythonWorker work!';
    }

    public function seelp()
    {
        return 'PythonWorker seelp!';
    }

    public function beManager()
    {
        $this->work();
        $this->seelp();
    }
}

class QAWorker implements WorkerInterface, WorkInterface
{
    public function work()
    {
        return 'QAWorker work!';
    }

    public function beManager()
    {
        $this->work();
    }
}

class Organization
{
    public function manager(WorkerInterface $worker)
    {
         $worker->beManager();
    }
}
~~~

---

## DIP（依赖倒置）

### 问题

软件开发设计中，总是倾向于创建一些高层模块依赖底层模块，底层模块更改时直接影响到高层模块，从而迫使他们改变。DIP原则描述了高层次模块怎样调用低层次模块。

### 定义

- 高层模块不应该依赖与底层模块，二者都应该依赖于抽象
- 抽象不应该依赖与细节，细节应该依赖于抽象

### 实例

创建一个类，想使用Mysql连接时，如

~~~php
class Person
{
    private $dbConnect;

    public function __construct(MysqlConnect $dbConnect)
    {
        $this->dbConnect = $dbConnect;
    }
}
~~~

突然想从Mysql切换到PgSQL上，这就需要修改所有使用的地方，这样很容易忘记修改某个地方导致出现问题

我们首先将其抽象，如下

~~~php
interface ConnectInterface
{
    public function connect();
}

class MySQLConnect implements ConnectInterface
{
    public function connect()
    {
        return 'Mysql Connect';
    }
}

class RedisConnect implements ConnectInterface
{
    public function connect()
    {
        return 'Redis Connect';
    }
}

class Person
{
    private $dbConnect;

    public function __construct(ConnectInterface $dbConnect)
    {
        $this->dbConnect = $dbConnect;
    }
}
~~~

---

## SRP（单一职责原则）

### 问题

一个类承担的职责过多，多个职责间相互依赖，一个职责的变换会影响这个类完成其他职责的能力，当引起类变化的原因发生时，会遭受到意想不到的破坏

### 定义

- 仅有一个引起类变化的原因
- 一个类只承担一项职责（职责：变化的原因）
- 避免相同的职责分散到不同的类，功能重复

### 实例

一个人有吃饭、睡觉、说话等方式，于是有了下面操作

~~~php
class Person
{
    public function say()
    {
        return 'say';
    }
    
    public function eat()
    {
        return 'eat';
    }
}
~~~

突然间发现有了分化，出现了说英语、汉语，吃中餐、西餐等方式，于是就只能在原有的基础上进行修改，这样就会使得原有的类越来越重，因此对其优化

~~~php
interface Human
{
    public function behavior();
}

class ChineseHuman implements Human
{

    private $say;
    private $eat;

    public function __construct()
    {
        $this->say = new Say();
        $this->eat = new Eat();
    }

    public function behavior()
    {
        $this->say->sayChinese();
        $this->eat->eatChineseFood();
    }
}

class Say
{
    public function sayChinese()
    {
        return 'Chinese';
    }

    public function sayEnglish()
    {
        return 'English';
    }
}

class Eat
{
    public function eatChineseFood()
    {
        return 'Chinese Food';
    }
}
~~~

---

## OCP（开放-封闭原则）

### 问题

随着软件系统规模的不断扩大，系统的维护和修改的复杂性不断提高。系统一处的更改往往会影响到其他模块。正确的运用OCP原则可以解决此类问题。

### 定义

一个模块在扩展行为方面应该是开放的而在更改性方面应该是封闭的

### 实例

---

## LSP（里式替换原则）

### 问题

面向对象中大量的继承关系十分普遍和简单，这种继承规则是什么，最佳的继承层次的规则又是什么，怎样优雅的设计继承关系，子类能正确的对基类中的某些方法进行重新，这是LSP原则所要处理的问题。

### 定义

- 子类必须能够替换掉他们的基类型：任何出现基类的地方都可以替换成子类并且客户端程序不会改变基类行为或者出现异常和错误，反之不行。
- 客户端程序只应该使用子类的抽象父类，这样可以实现动态绑定（php多态）

### 实例

创建了一个人类，人类分为男和女，我们直接继承人类，但是发现男人需要一些特殊的检查来做自己的操作，这样就会重新对应的方法，如下：

~~~php
class Person
{
    public function say($sex)
    {
        return 'Hello Person';
    }
}

class Man extends Person
{
    public function say($sex)
    {
        if ($sex != 1){
            throw new Exception();
        }
        
        return 'Hello Man';
    }
}
~~~

如果我在多一个女人，那么我就需要再次重写，所以我们可以做一次抽象，如：

~~~php
interface PersonInterface{
    public function say($sex);
}

class Man implements PersonInterface
{
    public function say($sex)
    {
        if ($sex != 1){
            throw new Exception();
        }

        return 'Hello Man';
    }
}

class Woman implements PersonInterface{
    public function say($sex)
    {
        if ($sex != 2){
            throw new Exception();
        }

        return 'Hello Woman';
    }
}
~~~