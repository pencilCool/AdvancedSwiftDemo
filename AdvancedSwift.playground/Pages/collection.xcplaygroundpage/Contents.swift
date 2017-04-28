//: [Previous](@previous)

import Foundation

var str = "Hello, collection"

//: [Next](@next)
extension Collection {
    // 来自 sequence
}
// collection 添加了 count 等


// 即使你不需要colletion 协议提供的功能
// 你也可以让你的sequence 符合 colletion 协议， 
// 用来保证sequence 是 有限的 切 遍历没有副作用的。（可以多次遍历）

// 不过比较奇怪的一点是，如果你只想 保证sequence 可多次遍历的，而实现了colletion 协议
// 你还不得让这个sequence 实现一个 index 。
// 这么做其实是swift team 不想 再另外实现了个支持 多次遍历的协议了

//:标准库实现了的colletion
//Array
//Dictionary
//String
//Set
//CountableRange  (Doubt)
//UnsafeBufferPointer  (Doubt)
// string 也是一个collection 呀

//:标准库之外的实现了colletion的典型例子
/*:
 - Data
 - IndexSet
*/



//: 为队列定义一个协议
protocol Queue {
    associatedtype Element
    mutating func enqueue( _ newElement: Element)
    mutating func dequeue() -> Element?
}

