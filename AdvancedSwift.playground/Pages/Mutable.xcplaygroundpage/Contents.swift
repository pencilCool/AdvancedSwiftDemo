//: [Previous](@previous)

import Foundation

var str = "Hello, Mutable"

//: [Next](@next)

//let mutableArray: NSMutableArray = [1,2,3]
//for in mutableArray
//{
//    mutableArray.removeLastObject()
//}
// 你不允许在遍历的时候修改 可变数组
// 但是如果你在遍历的时候，不是用的removeLastObject 这个函数而是用的其他修改数组的方法，这种侵犯就是很难直接看出来的。
// 除非你知道这个函数做了些什么事情。

// 但是如果我们用swift 的数组，
var mutaleArray = [1,2,3]
for _ in mutaleArray {
    mutaleArray.removeLast()
}
print(mutaleArray)
// 这个就不会crash 了。因为迭代器用一份对array 的独立的拷贝
// 比如执行 全部删除，迭代器也是会执行 3次的

var mutaleArrayRemoveAll = [1,2,3]
for _ in mutaleArrayRemoveAll {
    mutaleArrayRemoveAll.removeAll()
}
print(mutaleArrayRemoveAll)

// class 是引用类型，如果我们创造类的实例，赋值给一个新的变量，那么这个两个变量指向的都是同一个变脸。
let mutableArrayRefSame: NSMutableArray = [1,2,3]
let otherArray = mutableArrayRefSame
mutableArrayRefSame.add(4)
print(otherArray)
// 这是一个非常强大的特性，同时也是一个制造bug 的源泉。

// 在class 的内部，我们能够控制属性的可变和不可变用var 和let，比如
// 我们可以创造一个Scanner 的变量，但是是为二进制数据创造scanner 变量。
// Scannner 允许scan来看一个string 的value， 我们能保存这个string ，并且记住当前的位置。
class BinaryScanner {
    var position: Int
    let data: Data
    init(data:Data) {
        self.position = 0
        self.data = data
    }
}
// 上面 position 是var 是可变的， data 是 let 是不可变的
// 我们也可以也可以给添加方法来，scanner 函数

extension BinaryScanner {
    func scanbyte() -> UInt8? {
        guard position < data.endIndex else {
            return nil
        }
        position += 1
        return data[position - 1 ]
    }
}

// 为了测试这个函数， 我们可以写一个 scans 所有剩下 bytes 的方法
func scanRemainingBytes(scanner: BinaryScanner)
{
    while let byte = scanner.scanbyte() {
        print(byte)
    }
}

let scanner = BinaryScanner(data: "abc".data(using: .utf8)!)
scanRemainingBytes(scanner: scanner)
//这个能很好的完成工作，
// 但是如果scanRemaining 是在多个线程中执行就会出现竞争的时候。
// 在下面的代码中，在一个线程A中 postion < data.endIndex
// 但是在线程B中可能这个浏览最后一个元素了。postion 加上1 到了最后的一个元素。
// 回到线程A中，这个postion 已经是最后一个一个位置了，还被 +1 ，这个时候就超出边界了。
for _ in 0 ..< Int.max {
    let newScanner = BinaryScanner(data: "hi".data(using: .utf8)!)
    DispatchQueue.global().async {
        scanRemainingBytes(scanner: newScanner)
    }
    scanRemainingBytes(scanner: newScanner)
}
// 竞争不会那么常见， 因此在测试中是很难发现的。但是如果将BinaryScanner 改成 struct 。这个
// 竞争更本就不会出现。下一章我们来讲解为什么















