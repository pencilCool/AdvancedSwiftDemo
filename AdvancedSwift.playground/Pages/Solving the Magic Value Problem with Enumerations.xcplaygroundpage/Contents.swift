//: [Previous](@previous)

import Foundation

var str = "Hello, Solving the Magic Value Problem with Enumerations"

//: [Next](@next)


/*: 
获取包里面的值的方法只有： 用switch 或者 if case let
一个没有解包的值，你是不能直接用的。
所以寻找一个对象在数组中的位置 ，返回的结果不是一个index。而是一个Option<index>
 */

let array = [1,2,3,4,5,6]
let optionIndex = array.index(of: 7)


//extension Collection where Iterator.Element: Equatable {
//    func index(of element: Iterator.Element) -> Optional<Index> {
//        var idx = startIndex
//        while idx != endIndex {
//            if self[idx] == element { return .some(idx)
//            }
//            formIndex(after: &idx) }
//        // Not found, return .none
//        return .none }
//}


var literalTest:Int? = 3;
literalTest = .none
//literalTest = 3?
literalTest = 3
literalTest = nil

//: 现在朋友你想犯错都难
var array1 = ["one", "two", "three"]
let idx = array1.index(of: "four")
//:Compile-time error: removeIndex takes an Int, not an Optional<Int>
//array1.remove(at: idx)


var array2 = ["one","two","three"]
switch array2.index(of: "four")
{
    case .some(let idx):
        array2.remove(at: idx)
    case .none: print("none")
    break // do nothing 
}



