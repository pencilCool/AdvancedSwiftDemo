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

let commonDivisorFunction = sequence(first: (20,30)) {
    tuple  in
    print(tuple)
    guard tuple.0 == 0 else {
        return nil
    }
    let bigNum    = max(tuple.0, tuple.1)
    print("bigNum = \(bigNum)")
    let smallNum  = min(tuple.0, tuple.1)
    print("smallNum = \(smallNum)")
    let newValue  = (bigNum-smallNum, smallNum )
    print("newValue = \(newValue)")
  
    return newValue;  // 这个结果
    
}
Array(commonDivisorFunction)

// 另一个强大的序列发生器

let  fibsSequence2 = sequence(state: (0, 1)) {
    // The compiler needs a little type inference help here 
    (state: inout (Int, Int)) -> Int? in
    let upcomingNumber = state.0
    state = (state.1, state.0 + state.1)  // 这个state的状态，不用return 也能保存给下一个迭代用
    return upcomingNumber
}

Array(fibsSequence2.prefix(10)) // [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]

// 还是求最大公约数

let cmdsequence = sequence(state: (60,24)){
    (state: inout (Int, Int)) -> Int? in
    
    let bigNum     = max(state.0,state.1)
    let smallNum   = min(state.0,state.1)
    state          = (smallNum,bigNum - smallNum)
    let result     = bigNum
    if smallNum == 0 {
        return nil
    }
    return result;
}

Array(cmdsequence.prefix(12))

// 序列发生器 是 lazy 的，别人不问他序列是什么样的，他就不会计算。
// 如果一开始就把计算算了，那么程序可能会因为 溢出 而crash 的
// sequence 能创造 无线的序列 ，而其他的collection 类型却不能。


//MARK: 不稳定的序列
// 序列不仅包括类容器，数据结构，比如array or list
// 他还包括 网络数据流， 磁盘文件，UI的event 消息流，所有的的写数据都可以归类为sequence
// 但是这些和array 是不一样的，你的迭代器可以访问一个元素多次


// 像斐波拉契序列，你遍历他的时候，他的数据不会被你消耗，每一次遍历的结果都一样
// 但是像网络流，你遍历序列的时候，网络流数据就被你消耗了。每一次遍历的结果都不一样
// 这两种都是合法的序列，所以 文档中支持 序列不能保证多次遍历结果的唯一性。

// 这也就解释了为什么 只有colletion 含有 获取first 等方法，而sequence 中没有定义这样的
// 因为 colleciton 能保证get 函数 没有副作用，不会销毁访问的数据


// 考虑一种带有销毁功能的序列：
let standardIn = AnySequence {
    return AnyIterator {
        readLine()
    }
}
// 这样就可以用上给sequence的扩展了。

let numberedStdIn = standardIn.enumerated()
for (i, line) in numberedStdIn {
    print("\(i+1): \(line)")
}

// 实验结果：
//1:
//
//2:
//fdsa
//3: fdsa
//dadas;
//4: dadas;
//ff
//5: ff

// sequence 的实现这不需要总是记住 遍历的副作用(销毁数据) ，但是作为sequence 的调用者，这点必须牢记

// sequence对象 没有副作用的一个信号是：这个对象还实现了 collection 的协议。但是稳定不一定就一定实现了collection协议
// StrideTo  就可以遍历多次，但是它没事实现collection 协议。

// MARK: 序列和迭代器的关系
// 看起来很相似，为什么不把 IteratorProtocol 放到 sequence 里面去呢？
// 其实有些 sequence 是自己带了一个迭代器，在遍历的时候一直改变状态。
// 每一个迭代器在他返回数据之前，可以看做是一个不稳定的sequence 。
// 其实你可以将所有的迭代器 转变成 序列。 只要你实现了协议。  (Doubt)


// MARK: Subsequences

//
//protocol Sequence {
//    associatedtype Iterator: IteratorProtocol
//    associatedtype SubSequence
//    // ...
//}
// 是用来返回slice 和其他元 序列的
// 比如 prefix 和 suffix ， dropFirst 和 dropFirst split
// 如果你不设置特定的 subsequence ，那么编译器的默认实现就是AnySequence<Iterator.Element> 
// 因为sequence 提供了上面个这些函数的默认实现。
// 通常如果 subsequence == self 是很方便的实现。比如 string.CharacterView 


// 讨论了一种理想的情况。(Doubt page 62)

//associatedtype SubSequence: Sequence
//where Iterator.Element == SubSequence.Iterator.Element,
//SubSequence.SubSequence == SubSequence

//1 满足 subsequence 也是一个序列
//2 满足 subsequence 的元素和sequence 的元素是一直的。而他们的subsequence都是一样的。
// 但是这样的定义方式 编译器是不能接受的。   就是 协议递归的定义不支持。

extension Sequence
    where Iterator.Element: Equatable,
    SubSequence: Sequence,
SubSequence.Iterator.Element == Iterator.Element {
    func headMirrorsTail(_ n: Int) -> Bool { let head = prefix(n)
        let tail = suffix(n).reversed()
        return head.elementsEqual(tail)  // elmentsEqual 要求 head 和tail (也就是 subsequence) 也必须是sequence，并且类型也要是和sequnce 的元素类型是相同的，要不然就不能用 Equatable 了
    } }
[1,2,3,4,2,1].headMirrorsTail(2) // true 检查首尾相同数字的个数是不是达到要求

//

