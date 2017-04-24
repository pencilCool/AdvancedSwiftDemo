//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, Set"
print(str)

// set 实现了ExpressibleByArrayLiteral 可以用array 的形式赋值
let naturals: Set = [1, 2, 3, 2] // 2可以重复，没事情的
naturals // [2, 3, 1] 
naturals.contains(3) //true 
naturals.contains(0) // false
let doubleNaturals = naturals.map {
    return $0 * 2
}

let bigThanTwo = doubleNaturals.filter{
    return $0 > 2
}

// Set 的数学运算
// 求差集
let iPods: Set = ["iPod touch", "iPod nano", "iPod mini", "iPod shuf e", "iPod Classic"]
let discontinuedIPods: Set = ["iPod mini", "iPod Classic"]
let currentIPods = iPods.subtracting(discontinuedIPods)

// 求交集
let touchscreen: Set = ["iPhone", "iPad", "iPod touch", "iPod nano"]
let iPodsWithTouch = iPods.intersection(touchscreen)

// 求并集合
var discontinued: Set = ["iBook", "Powerbook", "Power Mac"]
discontinued.formUnion(discontinuedIPods) // ()
// 上面我们用var 来保存并集。 因为并集合是并到了调用者的身上的。
// 所有的set 操作，都有可变和不可变的形式。 查看 ： 
//SetAlgebra


// MARK: Index Sets and Character Sets
// 除了set以外的 还实现了 setAlgebra protocol 的对象。
// 在swift 出来之前就有他的雏形了。
// indexSets 代表了一组正数值。 你当然可以用 Set<Int>来实现。
// 但是 indexSets 它的存储效率更加的高。
// because it uses a list of ranges internall(Doubt)
// 假设 有 一个 1000 个元素的 tableView ，你需要一个Set<Int> 来保存被选中的
// rows . Set<Int>需要存储 1000 个元素。

// 而 indexSets 只需要存储 连续的区间。前 500 个rows 的选择，只需要存储两个数值就可以了


var indices = IndexSet()
indices.insert(integersIn: 1..<7)
indices.insert(integersIn: 11..<15)
indices

let evenIndices = indices.filter{ $0 % 2 == 0 } // [2, 4, 6, 12, 14]
evenIndices;


// CharacterSet 能高效的存储 unicode 字符
// 主要是他用来检测 一个特定的字符串 只含有特定的字符集合里面的字符。 比如字母和十进制数字


// MARK: Using Sets Inside Closures
// 字典和set 在闭包里经常用到
// 场景：选取 sequence 的元素，结果中每个元素具有唯一性元素，还要保持软来 sequence 的顺序
// 给协议增加特性，而且对协议的实现者有要求
extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter {
        if seen.contains($0) {
            return false
        } else {
            seen.insert($0)
            return true
        } }
    } }
[1,2,3,12,1,3,4,5,6,4,6].unique() // [1, 2, 3, 12, 4, 5, 6]


// Range :


let singleDigitNumbers = 0..<10

// "z" is included
let lowercaseLetters = Character("a")...Character("z")

// tableview 中的rows 和一般的ranges 不一样。它只实现了
// Comparable 
// 协议。 最后的总结不太懂 (Doubt)




