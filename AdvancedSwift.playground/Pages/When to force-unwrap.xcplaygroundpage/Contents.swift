//: [Previous](@previous)

import Foundation

var str = "Hello, When to force unwrap"

//: [Next](@next)

// ! 的作用就是，你知道这个optional 的值不是为空的，如果用的时候 真的是空了就 crash它

let ages = [
"Tim": 53,
"Anela": 54,
"Craig" : 44,
"Jony" : 47,
"Chris" : 37,
"Michael" : 34,
]

let agesBiggerThan50 = ages.keys.filter{
    name in ages[name]! < 50
}
print(agesBiggerThan50)

//Doubt : unfinished

