 //: [Previous](@previous)
 
 import Foundation
 import UIKit
 import PlaygroundSupport
 PlaygroundPage.current.needsIndefiniteExecution = true
 
 var str = "Hello, A Tour of Optional Techniques"
 
 //: [Next](@next)
 
 //: if let
 var array = ["one", "tow", "three", "four"]
 
 if let index = array.index(of: "four"){
    print("index is not nil")
    let element = array.remove(at: index)
 }
 
 print(array)
 
 if let index = array.index(of: "one"), index != array.startIndex {
    print("index is not the first ")
 }else{
    print("fun")
 }
 print(array)
 //后面的依赖于前面的正确的解包了
 
 let urlString = "https://koenig-media.raywenderlich.com/uploads/2016/07/rage_patterns.png"
 if let url = URL(string: urlString),
    let data = try? Data(contentsOf: url),
    let image = UIImage(data: data)
 {
    print("image fun")
    let view = UIImageView(image: image)
    
 }
 
 // let urlString2 = "https://koenig-media.raywenderlich.com/uploads/2016/07/rage_patterns.png",
 //    url2 = URL(string: urlString2),
 //    data2 = try? Data(contentsOf: url2),
 //    image2 = UIImage(data: data2)
 // {
 //    print("image fun")
 //    let view = UIImageView(image: image2)
 //
 // }
 //
 
 
 let scanner = Scanner(string: "myUserName123$$$")
 var username: NSString?
 let alphas = CharacterSet.alphanumerics
 print(alphas)
 if  scanner.scanCharacters(from: alphas, into: &username),
    let name = username {
    print(name)
 }
 
 
 while let line = readLine() {
    print(line)
 }
 
 // ❌
 while let line = readLine(), !line.isEmpty {
    print(line)
 }
 
 
 let array2 = [1,2,3]
 var iterator2 = array2.makeIterator()
 while let i = iterator2.next() {
    print(i, terminator: " test ")
 }
 
 var iterator = (0..<10).makeIterator()
 while let i = iterator.next() {
    if i%2==0 {
        print(i)
    }
 }
 
 
 //: for in (Doubt)
 
 
 
 //: Doubly Nested Optional
 let stringNumbers = ["1", "2", "three"]
 let maybeInts = stringNumbers.map { Int($0) }
 print(maybeInts, terminator: "\n")
 print("----------------")
 
 // for in 对应的 while let 实现方式
 var iterator3 = maybeInts.makeIterator()
 while let maybeInt = iterator3.next() {
    // 这里next 的返回值是 Optional<Optional<Int>> 被let 解包成了Optional<Int>
    print(maybeInt)
    // 第三next的返回结果是 Optional<nil> ，被解包成了nil
    
 }
 print("⚡️---------1")
 for case let i? in maybeInts {
    //i will be an Int,no tan Int?
    print(i)
 }
 
 
 print("⚡️---------2")
 // Or only the nil values:
 for case nil in maybeInts {
    // Will run once for each nil
    print("No value")
 }
 // No value
 
 print("⚡️---------3")
 for case let .some(i) in maybeInts {
    print(i)
 }
 print("⚡️---------4")
 let j = 5
 if case 0..<10 = j {
    print("\(j) within range")
 } // 5 within range
 
 
 print("⚡️---------5")
 // 既然 case 的匹配是 对操作符  ~= 的扩展，我们可以来做一些有趣的事情
 // if case 和 for case 的扩展。
 
 struct Substring {
    let s: String
    init(_ s: String) { self.s = s }
 }
 
 func ~=(pattern: Substring, value: String) -> Bool {
    return value.range(of: pattern.s) != nil
 }
 
 let s = "Taylor Swift"
 if case Substring(" Swift") = s {
    
    print("has substring \" Swift\"")
 }
 // has substring "Swift"
 
 
 //: if var and while var
 print("⚡️---------6")
 let number = "1"
 if var i = Int(number) { // let 是编译不过的
    i+=1  // i 被修改了 用var
    print(i)
 }//2
 
 //: Scoping of Unwrapped Optionals
 // 解包的作用域
 print("⚡️---------7")
 let array4 = [1,2,3]
 if !array4.isEmpty {
    print(array4[0]) // 在这个block外不能保证 array[0] 是可以访问的
 }else{
    array[0]
 }
 
 let firstElement = array4[0]  // 非 optional
 print("⚡️---------8")
 if let  firstElement = array4.first {
    print(firstElement)
 }else{
    let tmp = firstElement
 }
 
 print("⚡️---------9")
 func doStuff(withArray a: [Int]) {
    guard !a.isEmpty else { return } // Now use a[0] safely
 }
 
 
 //: optional chain
 
 
 let str2: String? = "Never say never"
 let result2 = str2?.uppercased()//
 
 
 let lower = str2?.uppercased().lowercased()
 //为什么不需要再uppercased后面加上一个问号呢
 // 这是因为optional chain 是一个flatten 操作
 // 如果你调用
 //let lower2 = str2?.uppercased()?.lowercased() //编译不通过。会得到一个optional<optioanl>
 // 得到的结果会是
 
 // 为了得到正常的optional ，(只有一层，而不是嵌套的)所以第二个问号就不写了
 
 // 当然如果uppercased 本身返回结果就是一个optional 的话，那么 还是需要些第二个问号的。
 
 extension Int {
    var half: Int? {
    guard self > 1 else { return nil }
    return self / 2
    }
 }
 
 let testHalf = 20.half?.half?.half // Optional(2)
 print(testHalf)
 //let testHalf2 = 20.half?.half.half 少一个都是编译错误
 
 
 
 // 字典中也能用到 问号
 let dictOfArrays = ["nine": [0, 1, 2, 3]]
 dictOfArrays["nine"]?[3] // Optional(3)

 
 
 let dictOfFuncs: [String: (Int, Int) -> Int] =
 [
   "add"     : (+),
   "subtract": (-)
 ]
 dictOfFuncs["add"]?(1, 1) // Optional(2)
 
 
 //: The nil-Coalescing Operator
  