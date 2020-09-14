# 面向对象基本思想

## 基本特征

- 封装
- 继承
- 多态

---

## 封装

把客观事物封装成抽象的类，并且类可以把自己的数据和方法只让可信的类或者对象操作，对不可信的进行信息隐藏。
是对象和类概念的主要特性。

### 优点

- 变化隔离
- 便于使用
- 提高重用性
- 提高安全性

### 缺点

将变量等使用private修饰，或者封装进方法内，使其不能直接被访问，增加了访问步骤与难度！

### 实现形式

- 使用访问权限修饰符private 在定义JavaBean时对于成员变量使用private进行修饰，同时对外提供set、get方法 使用了private修饰的成员在其他类中不能直接访问，此时需要使用set、get方法进行。
- 定义一个Java类与Java的方法就是最简单最常见的面向对象的封装操作，这些操作符合隐藏实现细节，提供访问方式的思路。

### ​​示例

```php
​<?php/** 
* @file           Leads.php 
* @description    描述
* @author         yangzuhao <yangzuhao@zuoyebang.com> 
* @date           2020/9/7 
*/
class Service_Filter_Event_Leads{
    private $wxId;
    /**     
    * @description    微信ID（资产），一个老师可能会同时带多个资产，所以需要根据不同的资产去区分例子     
    * @return array     
    * @author         yangzuhao <yangzuhao@zuoyebang.com>     
    * @date           2020/9/11     
    */    
    public function getWxId()    
    {
        if ( ! $this->wxId) {
            return [];
        }
        return ['wxId' => $this->wxId];
    }    
    /**
     * @description    微信资产字段校验
     * @param   string  $wxId
     * @author         yangzuhao <yangzuhao@zuoyebang.com>
     * @date           2020/9/11
     */
    public function setWxId($wxId)
    {
        if ( ! $wxId) {
            $this->wxId = $wxId;
        }
    }
}​
```

## 继承

- 面向对象编程 (OOP) 语言的一个主要功能就是“继承”。
- 继承是指这样一种能力：它可以使用现有类的所有功能，并在无需重新编写原来的类的情况下对这些功能进行扩展。
- 通过继承创建的新类称为“子类”或“派生类”。
- 被继承的类称为“基类”、“父类”或“超类”。
- 继承的过程，就是从一般到特殊的过程。
- 要实现继承，可以通过“继承”（Inheritance）和“组合”（Composition）来实现。
- 一个类只能单继承，可以实现多个接口。
- 继承就是子类继承父类的特征和行为，使得子类对象具有父类的非private属性和方法。

### 示例

```php
​class Service_Filter_Event_Leads extends Service_Filter_Event_Abstract{
    // code
}
```

### 优点

- 减少代码重复、臃肿
- 提高代码可维护性。

### 特性

- 子类拥有父类非private的属性和方法；
- 子类可以拥有完全属于自己的属性和方法（对父类扩展）；
- Java是单继承(每个子类只能继承一个父类)；但是Java可以是多重继承（如A继承B，B继承C）。

### Super和this关键字

- Super关键字：我们可以通过super关键字来实现子类对父类成员的访问，引用当前实例对象的父类。
- This关键字：指向实例对象自己的引用。

## 多态

多态就是同一个接口，使用不同的实现，而执行不同的操作。

### 必要条件

- 继承（extends）
- 重写（子类重写父类的同名方法）
- 父类引用指向子类的对象，如：子类继承父类，重写父类的方法，当子类对象调用重写的方法时，调用的是子类的方法，而不是父类的方法，当想要调用父类中被重写的方法时，则需使用关键字super。