# 【软件设计之美】理论知识

[TOC]

---

## 如何了解软件设计

三个方面

* 模型
* 接口
* 实现

### 模型

一个软件的核心，也有人称之为抽象。理解一个设计中的模型，可以帮助我们建立起对这个软件整体的认知。

### 接口

它决定了软件通过怎样的方式，将模型提供的能力暴露出去。它是我们与这个软件交互的入口。

如：

* 程序库的API接口
* 工具软件的命令行接口
* 业务系统对外暴露的REST API
* ......

### 实现

指软件提供的模型和接口在内部是如何实现的，这是软件能力得以发挥的根基。

如：

* 业务系统收到一个请求之后，是把信息写到数据库，还是转发给另外的系统。
* 算法的实现，是选择调用与别人已有的程序库，还是需要自己实现一个特定的算法。
* 系统中的功能，哪些应该做成分布式的，哪些应该由一个中央节点统一处理。
* 业务处理，是应该做成单线程，还是多线程的。
* 当资源有竞争，是每个节点自己处理，还是交由一个中间件统一处理。
* 不同系统之间的连接，该采用哪种协议，是自己实现，还是找一个中间件。
* ......

### 三者之间的关系

由于三者之间的关注点不同，所以需要对其区分（模型、接口和实现），顺序应该先模型，再接口，最后是实现

![7](image/7.jpg)

### 业务实例分析

![8](image/8.jpg)

由于Kafka 的出现，就把实现层面的东西拉了进来。这样模型和实现就混淆在一起了，Kafka 只是实现这个功能时的一个技术选型，实现这段代码的时候，必须把 Kafka 相关的代码进行封装，不能在系统各处随意地调用，因为它属于实现，是可能被替换的。

### 操作系统实例分析

如果你去了解它的内部，就知道它有内存管理、进程调度、文件系统等模块。我们可以按照模型、接口和实现去理解每个模块，就以进程管理为例：

* 进程管理的核心模型就包括进程模型和调度算法；
* 它的接口就包括，进程的创建、销毁以及调度算法的触发等；
* 不同调度算法就是一个个具体的实现。

### HashMap实例分析

* 模型：HashMap
* 接口：get、put等
* 实现：原来是用标准的 HashMap 实现，后来则借鉴了红黑树

### 总结

* 模型，也可以称为抽象，是一个软件的核心部分，是这个系统与其它系统有所区别的关键，是我们理解整个软件设计最核心的部分。
* 接口，是通过怎样的方式将模型提供的能力暴露出去，是我们与这个软件交互的入口。
* 实现，就是软件提供的模型和接口在内部是如何实现的，是软件能力得以发挥的根基。

## 以Spring Di容器为例分析模型

分析之前，应该要先知道项目提供了哪些模型，模型又提供了怎样的能力。理解一个模型的关键在于，要了解这个模型设计的来龙去脉，知道它是如何解决相应的问题。

### 耦合的依赖

在编程时，最常遇到的问题就是耦合，Di容器解决的问题是组件创建和组装。

假设我们有一个文章服务（ArticleService）提供根据标题查询文章的功能。

~~~java
class ArticleService {
  //提供根据标题查询文章的服务
  Article findByTitle(final String title) {
    ...
  }
}

interface ArticleRepository {
  //在持久化存储中，根据标题查询文章
  Article findByTitle(final String title)；
}
~~~

在 ArticleService 处理业务的过程中，需要用到ArticleRepository 辅助它完成功能，也就是说，ArticleService 要依赖于 ArticleRepository。这时你该怎么做呢？一个直接的做法就是在 ArticleService 中增加一个字段表示 ArticleRepository。

~~~java
class ArticleService {
  private ArticleRepository repository;
  
  public Article findByTitle(final String title) {
    // 做参数校验
    return this.repository.findByTitle(title);
  }
}
~~~

`repository` 字段怎么初始化呢？直接赋值？

~~~java
class ArticleService {
  private ArticleRepository repository = new DBArticleRepository();
  
  public Article findByTitle(final String title) {
    // 做参数校验
    return this.repository.findByTitle(title);
  }
}
~~~

不够优雅？改为传参？

~~~java
class ArticlService {
  private ArticleRepository repository;
  
  public ArticlService(final Connection connection) {
    this.repository = new DBArticleRepository(connection);
  }
  
  public Article findByTitle(final String title) {
    // 做参数校验
    return this.repository.findByTitle(title);
  }
}
~~~

如何进行测试呢？每一个程序都应该是测试驱动开发，测试时还需要关注DB连接对象么？

### 分离的依赖

当我们创建一个对象时，就必须要有一个具体的实现类，对应到我们这里，就是那个 DBArticleRepository。虽然我们的 ArticleService 写得很干净，其他部分根本不依赖于 DBArticleRepository，只在构造函数里依赖了，但依赖就是依赖。由于要构造 DBArticleRepository 的缘故，我们这里还引入了 Connection 这个类，这个类只与 DBArticleRepository 的构造有关系，与我们这个 ArticleService 的业务逻辑一点关系都没有。

~~~java
class ArticleService {
  private ArticleRepository repository;
  
  public ArticleService(final ArticleRepository repository) {
    this.repository = repository;
  }
  
  public Article findByTitle(final String title) {
    // 做参数校验
    return this.repository.findByTitle(title);
  }
}
~~~

修改过后，ArticleService 就只依赖 ArticleRepository。而测试 ArticleService 也很简单，只要用一个对象将 ArticleRepository 的行为模拟出来就可以了。通常这种模拟对象行为的工作用一个现成的程序库就可以完成，这就是那些 Mock 框架能够帮助你完成的工作。

~~~java
...
ArticleRepository repository = new DBArticleRepository(connection);
AriticleService service = new ArticleService(repository);
...
~~~

至此容器的概念也衍生出来

~~~java
Container container = new Container();
container.bind(Connection.class).to(connection);
container.bind(ArticleReposistory.class).to(DBArticleRepository.class);
container.bind(ArticleService.class).to(ArticleService.class)

ArticleService service = container.getInstance(ArticleService.class);
~~~

具体可参考文章：[反转控制容器和依赖注入模式](http://www.martinfowler.com/articles/injection.html)

### 总结

1. 理解模型，要知道项目提供了哪些模型，这些模型都提供了怎样的能力。
2. 了解模型设计的来龙去脉

### 加餐

1. 依赖注入相对于依赖查找，透明度更好，调用方对ioc容器的api和具体接口实现的查表获取被隐藏了（技术与业务的解耦最终都该透明无感）。但依赖查找在需要动态选择策略时依旧有其用武之地。

## 以Ruby on Rails分析接口

### 找主线

你需要找到一条功能主线，建立起对这个项目结构性的认知，而不是一上来就把精力放在每一个接口的细节上。

### 看风格

通过项目的接口看到设计者的编码风格，实现思路没这样有助于了解整体架构

Ruby on Rails 模型

Rails 是标准的基于 MVC 模型进行开发的 Web 框架，Rails 一个重要的设计理念就是约定优于配置。通过Rails的文档可以了解开发的基本过程

Rails 提供的接口风格

* Web 应用对外暴露的接口：REST API；
* 程序员写程序时用到的接口：API；
* 程序员在开发过程中用到的接口：命令行。

具体参考：[ruby on rails指南](https://ruby-china.github.io/rails-guides/)

### 总结

理解一个项目的接口，先找主线，再看风格。

## 以Kafka分析实现

