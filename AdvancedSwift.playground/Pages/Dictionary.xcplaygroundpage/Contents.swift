import Foundation
var str = "Hello, dictionary"

print(str)

enum Setting {
    case text(String)
    case int(Int)
    case bool(Bool)
}



let defaultSettings: [String:Setting] =
[
    "Airplane Mode": .bool(true),
             "Name": .text("My iPhone"),
]


//MARK: Mutation

// remove a elemetn use set nil or remove value for 

var localizedSettings = defaultSettings
localizedSettings["Name"]           = .text("Mein iPhone")
localizedSettings["Do Not Disturb"] = .bool(true)
let oldName = localizedSettings .updateValue(.text("Il mio iPhone"), forKey: "Name")
oldName
localizedSettings["Name"]
defaultSettings["Name"]

//MARK: Some Useful Dictionary Extensions


// 合并
// 如果我们想将用户设置的setting 和默认的setting 结合起来
// 用户必须 重写 default 的，但是默认设置中没有被用户设置的“key” 
// 不应该受到任何的影响。
// 本质上我们是要合并两个字典。含有相同key 的字典的合并，标准库里面没有提供这样的方法。


extension Dictionary {
    mutating func merge<S>(_ other: S)
        where S: Sequence, S.Iterator.Element == (key: Key, value: Value) {
            for (k, v) in other {
            self[k] = v }
    }
}

var dictionary1 = ["key1":"value1"];
var dictionary2 = ["key2":"value2"];
dictionary1 .merge(dictionary2)


var settings = defaultSettings
let overriddenSettings: [String:Setting] = ["Name": .text("Jane's iPhone")]
settings.merge(overriddenSettings)
settings


extension Dictionary {
    init<S: Sequence>(_ sequence: S)
        where S.Iterator.Element == (key: Key, value: Value) { self = [:]
            self.merge(sequence)
    }
}

let defaultAlarms = (1..<5).map {
    (key: "Alarm \($0)", value: false)
}
let alarmsDictionary = Dictionary(defaultAlarms)


extension Dictionary {
    func mapValues<NewValue>(transform: (Value) -> NewValue)
        -> [Key:NewValue] {
            return Dictionary<Key, NewValue>(map { (key, value) in
                return (key, transform(value)) })
    }
}

let settingsAsStrings = settings.mapValues {
    setting -> String in
    switch setting {
    case .text(let text): return text
    case .int(let number): return String(number)
    case .bool(let value): return String(value)
    }
}
settingsAsStrings // ["Name": "Jane\'s iPhone", "Airplane Mode": "true"]

// MARK: Hashable Requirement
// 字典的key 需要是可hash的，因为字典的key 是存在一个 key 的hash值数组里面。
// 标准库里几乎所有的对象都是 可hash 的，没有加 associate 对象的 enum 也是可哈希的
// 如果你想让自定义的对象作为字典的key ，那么这个key 是必须满足可以hash 的协议。
// 两个相等的对象有着相同的hash 值，反过来不成立。好的hash 函数要尽量减少冲突值
// 哈希值 扩展了euqal 。重写 == 函数 。
// 当你设置字典中每一个元素的hash 都相同的时候，字典的查找速度会下降到O(n)

// 好的hash 另外一个特点就是快。 字典key 的插入 ，删除和查找都要计算hash值。

struct Person {
    var name: String
    var zipCode: Int
    }
extension Person: Equatable {
    static func ==(lhs: Person, rhs: Person) -> Bool {
        return lhs.name == rhs.name
            && lhs.zipCode == rhs.zipCode
    } }
extension Person: Hashable { var hashValue: Int {
    return name.hashValue ^ zipCode.hashValue }
}

// 用异或运算成员的hash值 ，来做对象的hash 值1。

var person1 = Person(name: "tang", zipCode: 1)
var dict = [person1: "yuhua"]
//fatal error: attempt to evaluate editor placeholder:
let getPerson1 = dict[person1]


print("Done")


/*
 
 Finally, be extra careful when you use types that don’t have value semantics
 (e.g. mutable objects) as dictionary keys. If you mutate an object after using it as a dictionary key in a way that changes its hash value and/or equality, you’ll not be able to find it again in the dictionary. The dictionary now stores the object in the wrong slot, effectively corrupting its internal storage. This isn’t a problem with value types because the key in the dictionary doesn’t share your copy’s storage and therefore can’t be mutated from the outside.
 
 */



