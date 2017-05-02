

import Foundation

/*
 我们可以使用很多数据结构来存储数据：
 structs ，enums，class ，closure
 
 很多标准库里面的类型都被定义成为 structs 
 
 */

/*
 structs 是值类型，class 是引用类型。当我们定义structs的时候，我们能够让编译器
 强制 不变。
 当定义class 的时候，我们强制不变性，则需要我们自己来强制了
 
 内存管理。structs 是直接获取，而class 则是通过引用来做的。

 在class 中我们能够通过继承来共享代码，在structs 和 enum 中是不能继承的。
 为了能够在structs 和enum 中共享代码，我们是通过其他技术手段比如： 组合，泛型，协议扩展等
 
 */

/*
 在这个章节中，我们将会深入的探索不同
 我们从 entitis 和 value 的查边 开始算起，
 然后我们讨论 可变性
 然后我们讨论structs 的可变性。
 接着我们演示 怎么在结构体 中 包裹一个 引用，用来作为一个有效的值类型。
 最后 我们将会 比较内存管理的不同。还包括了闭包的内存管理和避免循环引用的问题
 */


/*
 值类型，
 */

// it’s important to understand that the mutability only refers
struct TestStruct{
    var name:String;
}
var tang = TestStruct(name: "tangyuhu")
print(tang)
//UnsafePointer(tang)

tang.name = "pencilCool"
print(tang)

// struct 是shallow bitwise copy ，浅拷贝， 拷贝二进制字节？
// 除非它的成员包含class 会使得引用计数增加。
// 当structs 被申明为let 的时候，编译器会知道，接下来的自己不会被改变。

// 我们没有办法知道copy 到底是在什么时候进行的。




