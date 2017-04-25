import Foundation
var str = "Hello, Sequences heheda"
// Sequences 协议 就是 同一类元素，你可以在他们上面用迭代器。
print(str)

//protocol IteratorProtocol {
//    associatedtype Element
//    mutating func next() -> Element? // 当没有下一个元素的时候，返回空的对象。
//}
//
//protocol Sequence{
//    associatedtype Iterator: IteratorProtocol
//    func makeIterator() -> Iterator;
//}

// associatedtype 元素的类型 定义了迭代器返回结果的类型。

let characterString: String = "characterString" // 15 charaters
let characters = characterString.characters
print(characters)
print(type(of: characters)) // element type of String.characters in CharacterView


// 通过扩展iterator 定义了sequence 的 元素 elment 的类型 (Doubt： 扩展谁？)
// 其实 elment 是IteratorProtocol(迭代器协议的) 的 associatedtype (关联类型)
// 这就是你为什么总是能看到 sequence 的迭代器是总是引用 Iterator.Element

// 你只有当需要实现自己的 Sequence 类型 的时候才需要 考虑 迭代器。
// 除此之外，你很少需要直接用到迭代器，因为用 for  loop 就能很好的遍历 sequence 类型了。
// 事实上。 for loop 编译器你 会 自动帮你生成一个迭代器， 然后调用 next 方法，直到 next
// 的返回结果 为nil

// 就啊好像是这个样子的：

//```
//var iterator = someSequence.makeIterator()
//while let element = iterator.next() {
//    doSomething(whit:element)
//}
//```
var myIterator = [1,2,3,4].makeIterator()
var preCopyIterator = myIterator
while let element = myIterator.next() {
    print("\(element)")
}

// Doubt: How to define my  sequence protocl

//protocol MySequence {
//    associatedtype myIterator: IteratorProtocol
//    func myMakeIterator() -> myIterator;
//}
//
//extension Array: MySequence {
//    typealias myIterator = Int
//
//}

// 迭代器只能单向迭代，不能反响或者重新设置。
// 大多数的迭代器都是有限的，最终总会有一个next() 的返回值会是 nil
// 没有谁会阻止你创建一个停不下来的迭代器。
// 实际上，可以想到的最简单的迭代器就是，就是next 立马返回一个nil ，
// 还有就是没完没了的返回同一个结果。

struct ConstantIterator: IteratorProtocol {
    typealias Element = Int
    mutating func next()->Int? {
        return 1
    }
}

// typealias 的显示 的制定 Element类型是可选的
// 但是为了文档规范，通常写上是很好的，尤其是那种 比较大型的协议。
// 如果我们忽略不写，编译器也会为我们推断elment的实际类型
// 当然推断的依据是 next 函数的返回值类型。

struct NOExplictTypeIterator:IteratorProtocol
{
    // without typealies Element = Int is OK
    mutating func   next() -> Int? { // mutating 是很有必要的，虽然这里没什么作用
        return 1
    }
}

// 死循环了
//var constanIteator = ConstantIterator()
//while let x = constanIteator.next(){
//    print(x)
//}

struct FibsIteator: IteratorProtocol {
    var state = (0,1)
    mutating func next() -> Int? {
        let upcomingNumber = state.0
        state = (state.1,state.0 + state.1)
        return upcomingNumber
    }
}

//var fibsIteator = FibsIteator()
//while let x = fibsIteator.next(){
//    print(x)
//}

// conforming Sequence协议
// 遍历字符串返回 前缀
struct PrefixIterator: IteratorProtocol {
    let string:String
    var offset: String.Index
    
    init(string: String) {
        self.string = string
        offset = string.startIndex
    }
    mutating func next() -> String? {
        guard offset < string.endIndex else { return nil }
        offset = string.index(after: offset)
        return string[string.startIndex ..< offset]
    }
    
}


struct PrefixSequence: Sequence {
    let string: String
    func makeIterator() -> PrefixIterator {
        return PrefixIterator(string: string)
    }
}

for prefix in PrefixSequence(string: "Hello") {
    print(prefix)
}

PrefixSequence(string: "Hello").map{ $0.uppercased()}

// Iterators and Value Semantics

// 迭代器有 值 语意， 可以copy ，copy 之后两个迭代器是独立的。但是也有例外。
// 先看copy吧。
var copyedIterator = myIterator //copy
while let element = copyedIterator.next() {
    print("⚡️\(element)")  // 没有输出
}
// 上下两个例子 验证 iterator 's entire state will copy
while let element = preCopyIterator.next() {
    print("🔴\(element)")  // 这里有输出了
}

// 检测 值和引用属性的差异
// sequence for 0 to 9
let seq = stride(from: 0, to: 10, by: 1)
var i1 = seq.makeIterator()
i1.next()
i1.next()
var i2 = i1
i1.next()
i1.next()
i2.next()
i2.next() // i2 和 i1 相互独立了

// 迭代器的引用语义
// AnyIterator 是一个包裹了其他迭代器的迭代器，因此，它消除了base iterator 的
// 实际类型。
// 你能用到的地方是： 你想隐藏复杂迭代器的实际类型，以防止在公有的API 接口中暴露了你实现的方式
// AnyIterator 的实现凡是是，包裹base iterator 在一个内部的box object 中，这个box object
// 是一个引用类型。 相知到怎么做到的请看 type earasue in protocol chapter

var i3 = AnyIterator(i1)
var i4 = i3

// 这种情况下，原来的和copy的就不在是独立的了。
// 尽管是一个结构(Doubt)， 但是 AnyIterator 没有值语义
// AnyIterator 是一个box 存放了基础的迭代器，他是一个引用类型。
i3.next()
i4.next()
i3.next()
i3.next()

// 这样很容易导致bug，其实你很少会用到这个特性
// 迭代器你通常是本地用，显式的来做for loop的，用完就扔了
// 如果你返现自己导出都要用到这个迭代器，考虑将这个迭代器包裹在sequence 里面吧。
// MARK: Function-Based Iterators and Sequences
// AnyIterator 还有初始化的方式是，是直接传入next 函数给它
// 这里就没有 值语义

func  fbsIterator() -> AnyIterator<Int> {
    var state = (0, 1)
    return AnyIterator {
        let upcomingNumber = state.0
        state = (state.1, state.0 + state.1)
        return upcomingNumber
    }
}

let  fbsSequence = AnySequence(fbsIterator)
let  testFibsArray = Array(fbsSequence.prefix(10))

// 做一个练习，求公约数，那么问题来着，这个迭代器怎么终止呢。(Doubt)
func commonDivisor( _ num1: Int, _ num2 :Int) -> AnyIterator<Int> {
    var state = (num1 ,num2)
    return AnyIterator {
        let bigNum     = max(state.0 , state.1)
        let smallNum   = min(state.0 , state.1)
        state         =  (bigNum-smallNum, smallNum)
        return bigNum
    }
}

let commonDivisorSequence = AnySequence(commonDivisor(60, 24))
let commonDivisorArray    = Array(commonDivisorSequence.prefix(10))


//  感觉这个有点像信号与系统里的序列发生器 阻尼包络曲线
let randomNumbers = sequence(first: 100) { (previous: UInt32) in
    let newValue = arc4random_uniform(previous)
    guard newValue > 0 else {
        return nil
    }
    return newValue
}
Array(randomNumbers) // [100, 83, 27, 13, 10, 2, 1]

//  还是写一个求最大公约数
func nextTuple(_ tuple :(Int,Int)) -> (Int,Int)? {
        let bigNum    = max(tuple.0, tuple.1)
        let smallNum  = max(tuple.0, tuple.1)
        let newValue  = (bigNum-smallNum, smallNum )
        return newValue;
}
let commonDivisorFunction = sequence(first: (5,8), next:nextTuple)
Array(commonDivisorFunction)


