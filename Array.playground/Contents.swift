//: Playground - noun: a place where people can play

import UIKit
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








