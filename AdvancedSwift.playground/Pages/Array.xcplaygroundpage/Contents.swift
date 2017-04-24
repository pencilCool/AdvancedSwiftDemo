//: Playground - noun: a place where people can play

import UIKit
print("Hello World")
//MARK: Arrays and Mutability
let  fibs = [0, 1, 1, 2, 3, 5]

var mutableFibs = [0, 1, 1, 2, 3, 5]

// error 不可变的 let 不能加东西了
// fibs.append(8)
mutableFibs.append(8)

// NSArray 没有提供更改数据的方法，但是并不意味这些数据不会在底下变动
let a = NSMutableArray(array: [1,2,3])
let b: NSArray = a  // 我们并不想让b 变动。
//但是我们还是可以通过a 来变动b 呀。 (为么不让这种情况出现 OC 里面就有了copy 这个关键字了)
a.insert(4, at: 3)
b

let c = NSMutableArray(array: [1,2,3])
let d = c.copy() as! NSArray // copy 理论上来说是会带来性能问题的，但是swift 做了优化，copy on write
c.insert(4, at: 3)
d



//MARK: Array Options

//:数组的 index 其实很少用。
var optionsArray = [1,2,3,4,5,6]
for element in optionsArray {
    print(element)
}
optionsArray.dropFirst()
optionsArray.dropLast()
optionsArray.dropLast(2)
optionsArray.dropFirst(2)

for (number, element) in optionsArray.enumerated() {
    print("number = \(number) element = \(element)")
}
let findElementIndex = optionsArray.index{
    $0 == 5
}
print(findElementIndex!)

let doubleArray = optionsArray.map{$0 * 2}
print(doubleArray)
let biggerThanThreeArray = optionsArray.filter {
    $0 > 3
}
print(biggerThanThreeArray)
// 总之 少用 for index 的循环

//: 综述了array 没有给出option 的原因
/*
 有些时候你必须使用数组的index，进行更加细致的操作。你需要很仔细的计算index。
 因为多一些index 对应元素的unwrap 会导致overkill 。也就是说你不能信任你的代码。
 如果你要说明你信任 这次 index 索引的结果，那么就需要强制解包 （force - unwrapping）。
 这是一个不好的习惯： 当每一个索引结果都需要解包的时候，这是很烦人的。最终你会由于疏忽而解包了一个错误的值。
 于是   array 干脆不提供 option
 */

/*
 当下标索引出错，抛出一个可控的crash 的时候，我们大体上可以称之为 “unsafe”
 这仅仅是安全性的一方面。下标索引操作，对于内存安全来说是完全安全的。标准库提供的容器类型，总是会检查操作边界的
 */

//FIXME: 需要一个unsafe 的c 操作来作为demo

// 非下标操作可以返回 option ！！

var emptyArray = [String]()
let emptyFirst = emptyArray.dropFirst()
if (emptyFirst.isEmpty) {
    print("emptyFist is empty")
}else{
    print("emptyFirst = \(emptyFirst)")
}
emptyArray.dropLast()

// array 当栈用的时候 ，直接检查 isempty 然后 droplast
// 另一方面 如果 你完全知道 array 是不是空的 ，处理 option 的时候需要非常技巧  ？？(Doubt)


// MARK: 数组转换

var squared: [Int] = []
for fib in fibs {
    squared.append(fib * fib)
}
squared

let otherSquares = fibs.map{
    fib  in fib * fib
}
otherSquares


extension Array {
    func myMap<T>(_ transform: (Element) -> T) -> [T] {
        var result: [T] = []
        result.reserveCapacity(count)
        for x in self {
            result.append(transform(x))
        }
        return result
    }
}


// 其实 map 的定义应该是：
//
//func map<T>( _ transform:(Element)  throws  -> T)  rethrows -> [T]
// 这是为了能处理 转化函数出错的情况    （Doubt）



//MARK: 用函数 来 使得行为参数化

//- map and flatMap
//- filter
//- reduce
//- sequence
//- forEach
//- sort lexicographicallyPrecedies partition (Doubt)
//- index, first contains
//- min max
//- elemensEqual starts (Doubt)
//- split

/*
 
 struct people{
 var name:String
 var age :Int
 
 }
 let p1 = people(name: "tang", age: 26)
 let p2 = people(name: "tom", age: 36)
 let peoples = [p1,p2]
 let ageIncreasePeoples = peoples.sorted {
 $0.age < $1.age
 }
 
 print(ageIncreasePeoples[0].name)
 
 */



// all(matching:) none(macthing:) criterion (Doubt)


//count(where:)
//var countArray = [1,2,3,4,5,6,7,8]
//countArray.count(where: )
//

//indices(where:)
//prefix(where:)
//drop(where:)



let names = ["Paula", "Elena", "Zoe"]
var lastNameEndingInA: String?
for name in names.reversed() where name.hasSuffix("a") {
    lastNameEndingInA = name
    break
}
lastNameEndingInA // Optional("Elena")”

extension Sequence {
    func last(where predicate:(Iterator.Element) -> Bool) -> Iterator.Element?{
        for element in reversed() where predicate(element){
            return element
        }
        return nil
    }
}
let match = names.last{
    $0.hasSuffix("a")
}
match

//MARK: 不可变和状态 闭包

//不推荐的做法   (UnRecommend)

/*
 array.map {
 item in
 table.insert(item)
 }
 要减少map 的副作用， 如果要实现上述功能最好直接用 for in 函数更加清晰
 这种情况更加推荐用forEach 函数
 */


// 保持清晰的代码
//执行函数有作用  与 故意让让闭包获取本地变量是有区别的。
// 能捕获本地变量也是 闭包之所以 成为闭包的关键 ，这样能组成高阶函数

extension Array {
    func accumulate<Result>(_ initalResult: Result,
                    _ nextPartialResult:(Result,Element) -> Result) ->[Result]
    {
        var running = initalResult
        return map {
            next in
            running = nextPartialResult(running,next)
            return running;
        }
    }
}

[1,1,1,1].accumulate(0, +)

// Fileter  use $0 if logical express in on line or name the params

// 100 以下的平方数，且是偶数
let lessHundredSquare = (1 ..< 10).map{$0 * $0}.filter{ $0 / 2 == 0}
lessHundredSquare

extension Array {
    func  myfilter(_ isIncluded: (Element) -> Bool) -> [Element] {
        var result: [Element] = []
        for x in self where isIncluded(x){
            result.append(x)
        }
        return result
    }
}

let testMyfilter = [1,2,3,4,5].myfilter{ $0 > 3}
print(testMyfilter)

// 检查 满足要求的元素是否存在：
// 不合理写法：
[1,2,3,4].filter{$0 > 12}.count
// 合理写法
let contains  = [1,2,3,4].contains{ $0 > 12}
contains


extension Sequence {
    public func myAll(matching predicate:(Iterator.Element) -> Bool) -> Bool {
        return !contains{  // 不存在不满足条件的。 也就是全部满足了
            !predicate($0) // 存在不满足条件的
        }
    }
}

extension Sequence {
    public func myNone(matching predicate:(Iterator.Element) -> Bool) ->Bool {
        return !contains{  // 不存在满足条件的
            predicate($0) // 存在满足条件的
        }
    }
}

let aboveZero = [1,2,3,4,5].myAll{$0 > 0}
aboveZero

let aboveTwelve = [1,2,3,4,5].myNone {$0 > 12}
aboveTwelve


//Reduce
let sum = fibs.reduce(0, +)
let combineString = fibs.reduce(""){
    str, num in
    str + "\(num)"
}

extension Array {
    func myReduce<Result>(_ initialResult: Result, _ nextPartialResult:(Result,Element) -> Result) ->Result
    {
        var result = initialResult
        for x in self {
            result = nextPartialResult(result,x)
        }
        return result;
    }
}

extension Array {
    func map2<T>(_ transform: (Element) -> T) -> [T]{
        return reduce([]){
            $0 + [transform($1)]
        }
    }
    
    func filter2(_ isInclude:(Element) -> Bool) -> [Element] {
        return reduce([]){
            isInclude($1) ? $0 + [$1] : $0
        }
    }
}
let testAddArray = [0] + [1];

// 关于性能  （Doubt）

//MARK: A Flattening Map  ， Flatten 变平坦的意思。
// map 一个array 对每一个 element 操作的返回值 不是单个的element 了，而是变成 了 array 。
// 场景： 获取markdown 文件中的link 列表 ，而markdown 却又很多个文件。 其实就是把不同单元的同类，聚合到一起来。



/*
 
 func extractLinks(markdownFile:String) -> [Array<URL>]
 {
 let file1_url1 = URL(string: "~/Desktop/file1/url1")!
 let file1_url2 = URL(string: "~/Desktop/file1/url2")!
 
 let file2_url1 = URL(string: "~/Desktop/file2/url1")!
 let file2_url2 = URL(string: "~/Desktop/file2/url2")!
 
 let file1_url = [file1_url1, file1_url2]
 let file2_url = [file2_url1, file2_url2]
 
 return [file1_url, file2_url];
 }
 
 
 extension Array{
 func myFlatMap<T>(_ transform: (Element) ->[T]) ->[T] {
 var result: [T] = []
 for x in self{
 result.append(contentsOf: transform(x))
 }
 return result;
 }
 }
 
 let demo
 */


// (Doubt)
let suits = ["♠︎", "♥︎", "♣︎", "♦︎"]
let ranks = ["J","Q","K","A"]

let result = suits.flatMap{
    suit in ranks.map{
        rank in
        (suit,rank)
    }
}
result

// MARK: 迭代器 forEach  和map 不同的是，不会创建新的数组

for element in [1,2,3] {
    print(element)
}

[1,2,3].forEach{ element in
    print(element)
}

// for loop 和 for each 有细微的区别
// 如果for loop里面有返回值，让for each 来重写会改变代码的行为
// 比如：


// 返回元素在数组中的索引
extension Array where Element: Equatable {
    func index(of element: Element) -> Int? {
        for idx in self.indices where self[idx] == element {
            return idx
        }
        return nil
    }
}

//[2,4,6,8,10].indices

extension Array where Element: Equatable {
    func index_foreach(of element: Element) -> Int? {
        self.indices.filter { // indices 数组中合法的索引数值，从打大到小排
            idx in self[idx] == element
            }.forEach
            { idx in
                return idx
        }
        return nil
    } }

// forEach 中的返回值，没有返回出闭包。 （Doubt）
// 这其实就是一个bug 了，通常编译器会提示我们 返回的参数没有被用到。
// 但是我们不能完全依赖编译器。这里就不会有提示。
print("Test for each: number for 1 to 10 ")
(1..<10).forEach { number in print(number)
    if number > 2 { return } // not break the the for each process
}

// forEach 在调试的过程中很好用。
// 在 map filter 的链式调用中，可以 在其中插入 forEach 作为调试用。
print("use foreach to debug chain")
let originArray = [1,2,3,4,5,6];
let chainResult = originArray.map{ $0 * 2 }.filter{ $0 > 4}.forEach{print($0)}
print(chainResult) //() for Each no return

//MARK: Array Types

//Slice  除了能通过下标，获取到单个的元素外，我们还可以获取摸个区域的元素。
let slice = fibs[1..<fibs.endIndex]
slice
type(of: slice)
// slice 的类型不是array,而是ArraySlice ，slice 是 array 的view，也就是说只是一个概念并无新的实体。
// 他具有array 提供的所有函数。
// 见slice 变成新的实体的操作：
Array(fibs[1..<fibs.endIndex])


// MARK: 桥接
// 之前因为 NSArray只能保存 对象（id）所以 swift 转 OC 的时候，Array 的元素必须转成AnyObject
// 这样也就限制了只有 class 和一些数值类型的桥接到对应的oc 对象了。

// 但是这种情况在swift3的时候改变了， oc 的id 类型在swift 中用Any 而不是AnyObject 来表示了。
// 这也就是说说任何的swift 数组都可以桥接到NSArray 了。(struct ?)
// 当然NSArray的元素还得是对象,所以编译器和runtime 会自动打包（不是对象的）值到一个不透明的box class
// 当然解包也是自动的。 (Doubt： 解包给谁用？ swift 还是oc)

// 全免得bridge，当然不只是对于Array ，还是Dictionary 。未来swift 版本，会让swift 的值类型支持@objc 协议。








