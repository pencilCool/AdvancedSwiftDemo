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
 
 let stringteger = "1"
 
 let number3 = Int(stringteger) ?? 0  // number3 是解包了的
 
 // 这个和oc 中的 三目运算符还是有一些差别的。
 // 是的，options 不是一个指针
 // 是的，你在oc 中总是能遇到optinals 和references 的结合。
 // 但是，optionals ，也能包裹 值 类型。所以 上面的number3 是一个Int ，而不是NSNumber
 
 let array5 = [1,2,3]
 !array5.isEmpty ? array5[0] : 0 // 这里你可能会忘了 array5 可能是一个空的
 array5.first ?? 0 // 这个你不会不记得first 是一个optional 的
 
 array5.count > 5 ? array5[5] : 0
 //不巧的是，不像 first 和 last ，我们通过 下标的出的元素通常都不是optional的，
 //我们可以对他进行扩展。
 extension Array {
    subscript(safe idx:Int) ->Element?
    {
        return idx < endIndex ? self[idx] : nil
    }
 }
 // 现在就可以这么写了吧。
 array5[safe:5] ?? 0
 
 // coalescing 也是可以 chain的
 let coi : Int? = nil
 let coj : Int? = nil
 let cok : Int? = 42
 let coalescingChain = coi ?? coj ?? cok
 print("⚡️---------10")
 print(coalescingChain)
 let typeCoal = type(of: coalescingChain)
 print(typeCoal)
 print("⚡️---------11")
 // 比如要表达逻辑 
 if let n = coi ?? coj {
    // 存在一个不为 空
 }
 // < = >
 
 // 
 if (coi != nil || coj != nil){
    // 存在一个不为空
 }
 
 // 如果 吧 ？？ 当做 or 运算 ，那么 if let 可以当做是 and 的运算
 
 if let n = coi,let m = coj {}
 
 if coi != nil && coj != nil
 {
    
 }
 
 // 还需要注意的 运算的先后导致的差异。 (Doubt)
 // a ?? b ?? c   <------> (a ?? b) ?? c
 let string6: String?? = nil
 print((string6 ?? "innner") ?? "outer")
 let string7: String?? = .some(nil)
 print((string7 ?? "innner") ?? "outer")

 // optional 烧脑体操 https://www.google.com/#newwindow=1&q=optiional+%E7%83%A7%E8%84%91+%E4%BD%93%E6%93%8D
 
 // Optional Map 这个map 和之前数组的map 不同，这个map 只针对一个变量，变量有可能为nil ，有看能有值
 let characters: [Character] = ["a", "b","c"]
 String(characters[0])
  
 extension Optional {
    func singleMap<U>(transform:(Wrapped)->U) -> U? {
        if let value = self {
            return transform(value)
        }
        return nil
    }
 }
 
 let firstCahr = characters.first.singleMap{
    String($0)
 }  //error
 
 // 对于reduce 的init 是 数组的第一个元素的时候，有些称这种reduce 叫做， reduce1
 // 我们来定义这样的reduce
 extension Array {
    func myReduce( _ nextPartialResult: (Element, Element) -> Element) -> Element? {
        guard let fst = first else {
            return nil
        }
        return dropFirst().reduce(fst, nextPartialResult);
    }
 }
 
 [1, 2, 3, 4].myReduce(+)
 
 
 // Optional flatMap 
 // flatMap 就是用一个返回值是 colletion的函数的map over 给定的colletion
 // colletion.flat map ( funcMap($(0)) )   ----->   func funcMap(elment) -> colletionType
 // 但是呢 flat 的结果呢，不是一个嵌套的，比如 array of array ，就只是一个array
 // 同样的如果你map optional 的值。那么过这个函数返回的还是一个optional ，那么你就会得到一个嵌套的optional
 // 我们先整理一下上面两中事情的关联性：
 //    map（flatmap） 中 你传入的函数的返回类型，和 map （flatmap）的返回类型是一致的：array(optional)
 
 let stringNumbers1 = ["1","2","3","4"]
 let x = stringNumbers1.first.map{Int($0)}
 print(x) // Optional<Optional<Int>>
 // 这里的问题就是 map 返回的本来就是一个 Optional, 但是呢给$0 本来给你的就是一个optional ，
 // 所以这里的x 就是Int??
 
 // 可以这样写：
 if let a = stringNumbers1.first, let b = Int(a) {
    print(b) // 这里的返回结果就是  1 了，就是你想要的结果。
 }
 
 let urlString1 = "https://koenig-media.raywenderlich.com/uploads/2016/07/rage_patterns.png"
 let view3 = URL(string: urlString1)
    .flatMap{try? Data(contentsOf:$0)}
    .flatMap{UIImage(data: $0)}
    .map{UIImageView(image: $0)}
 
 if let view3 = view3 {
    PlaygroundPage.current.liveView = view3
 }
 
 // 总结：当输入参数是一个optional ，当处理函数的返回值也是一个optional 的时候，为了
 // 让最终的结果的类型不是嵌套的的optional 的时候，我们要用flatMap
 
 
 //: Filtering Out nil with flatMapv  
 /*
  如果你有 一个序列， 里面包含了 optional ，你其实不关心optional 为nil 的情况，
  你选择直接忽略这个序列。
  我们开始
  */
 
 let numbers10 = ["1", "2", "3", "test"]
 
 var sum = 0
 for case let i? in numbers10.map({
    Int($0)
    })
 {
    sum += i;
 }
 print(sum)
 
 let sumOfStringArray = numbers10.map{Int($0)}.reduce(0){
    $0 + ($1 ?? 0)
 }
 
 print(sumOfStringArray)
 
// (Doubt： 没有做完的联系)
 
 // 我们已将看了两种 flatenning 函数了，
 /*
  一个就是将一个一个序列编程一个数组
  一个就是将optional map 成为 optional ？？(Doubt)
  */
 // 如果我们将optional 看做一一个 没有值或者是只有一个值的 collection
 // 如果 这个colletion 是 array ，那么flatMap 就是我们的 flattenning 函数 (doubt: )
 
 func flatten<S : Sequence, T>(source: S) -> [T] where  S.Iterator.Element == T? {
    let filtered  = source.lazy.filter {
        $0 != nil
    }
    return filtered.map{$0!}
 }
 
 // 这里是用的一个函数，而不是直接多协议的扩展，
 /*
  这是因为，每一办法限制sequence 的扩展，只用在optional 的序列上 (Doubt:认识局限性)

  上面用到了lazy 是为了到最后操作的时候，才做这些事情。(Doubt：这个最后操作的时候指代的是什么呢？)
  这也是一种性能上的优化。
  
  */
 
 //: Equating Optional
 let regex = "^Hello$"
 if regex.characters.first == "^"
 {
    //
 }
 // 在这种情况下，是不会值 是否为 nil
 // 如果 string 是一个空的，那么第一个字符将不会是一个脱字符号。
 // 但是你想让block 里面的代码执行，你还想要简化和保护 first
 // 那么 :
 if !regex.isEmpty && regex.characters[regex.startIndex] == "^" {
    
 }

 // 上面这样的代码太恐怖了，
 // 我们可以用这样的逻辑
 
 func ==<T: Equatable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case (nil, nil):return true
    case let (x?, y?): return x == y
    case let (_?,nil), (nil, _?) : return false
    }
 }
 
 
//
 
 var dicWithNils : [String : Int?] = [
    "one" : 1,
    "two" : 2,
    "none": nil
 ]
 
 dicWithNils["two"] = nil // 这个key 都会没有的

 print(dicWithNils)
 dicWithNils["two"] = Optional(nil) // 这个key 还会保留，但是值为nil
 print(dicWithNils)
 dicWithNils["two"] = .some(nil)  // 同上
 print(dicWithNils)
 dicWithNils["three"]
 print(dicWithNils)
 

 
 //un finised
 
 
