import Foundation

struct myPoint{
    var x: Int
    var y: Int
}

let origin = myPoint(x: 0, y: 0)

//origin.x = 10  及时x 是可变的 ，但是origin 是定义为let 的， 也不能 改动
var othermyPoint = myPoint(x: 0, y: 0)
othermyPoint.x += 10


var thirdmyPoint = origin
thirdmyPoint.x += 10
print(thirdmyPoint)
print(origin)
// copy 的不是 reference的，这个开销可能会很大，但是编译器做了很多工作，copy on write

extension myPoint{
    static let origin = myPoint(x: 0, y: 0)
    // 结构体 中 可以 扩展 添加一些 比较常用和特殊的值。
    
}
print(myPoint.origin)

// 结构体还可以嵌套，
struct mySize {
    var width : Int
    var height: Int
}

struct myRectangle {
    var origin: myPoint
    var size: mySize
}

myRectangle(origin: myPoint.origin, size: mySize(width: 320, height: 480))

// 如果我们想定义自定义的初始化函数，可以直接在结构体内部实现， 但是如果结构体内部包含有了
// 自定义的初始化函数，那么 结构体不再生成 memberwise 初始化函数。
// 但是如果我们在extension 里面添加 自定义的初始化函数，那么 memeberwise 的初始化方法还是会保留的

extension myRectangle
{
    init(x: Int = 0, y: Int = 0, width: Int, height: Int) {
        origin = myPoint(x: x, y: y)
        size  = mySize(width: width, height: height)
    }
}

myRectangle(x: 10, y: 10, width: 320, height: 480)

let thirdInit = myRectangle(width:320, height: 10)
print(thirdInit)

print("--------------")

var screen = myRectangle(width: 20, height: 30){
    didSet{
        print("screen changed: \(screen)")
    }
}
print("no print")
screen.size = mySize(width: 20, height: 40)
print("out put change")

screen.origin.x = 4
// 即使是改变最里面的数值而是会触发变动

// 虽然从语义上来讲，当我们改动 struct的成员的时候，意味着这是一个新的结构了。编译器还是会还是会改动一些值。
// 既然struct 现在还没有被任何对象持有，那么我们就没有必要立马就copy 。和 copy on write struct 还是有差别的(Doubt:)

// array 也是一个结构，这个机制也是一样的。如果我们数组中包好有值 类型，然后我们修改这个值类型的属性。 didset 也是会被触发的
print("---------------------")
var screens = [myRectangle(width:320,height:420)] {
    didSet{
        print("Array changed")
    }
}
screens[0].origin.x + 100 // Doubt : array change not trigged

func +(lhs:myPoint, rhs:myPoint) -> myPoint
{
    return myPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}
print(screen)
let newScreen = screen.origin + myPoint(x: 10, y: 10)
print(screen)
print(newScreen)

//在很多情况下，同一个方法提供可变和不可变的版本是有道理的
// 比如，数组的sort 方法，是将数组重新排序，sorted 则是返回一个排序好了的数组。
// 我们也可以添加一个不可变版本的 translate(by:_) 的方式。
// 不改变self ，我们只是copy 了一份。返回一个新的translate

extension myRectangle
{
    
    mutating func translate(by offset: myPoint) -> myRectangle {
        self.origin = offset;
        return self
    }
    
    func translated(by offset: myPoint) -> myRectangle {
        var copy = self;
        copy.translate(by: offset)
        return copy
    }
}

print("------translate---------")
print(screen)
print(screen.translated(by: myPoint(x: 20, y: 20)))
print(screen)
print(screen.translate(by: myPoint(x:100, y: 100)))
print(screen)


print("----------inout----------")
func translateByTenTen(rectangle: myRectangle) -> myRectangle {
    return rectangle.translated(by: myPoint(x:10,y:10))
}
screen = translateByTenTen(rectangle: screen) // 这种写法很啰嗦，改成inout 吧
print(screen)

func translateByTwentyTwenty(rectangle: inout myRectangle){
    rectangle.translate(by: myPoint(x:20,y:20)) // 这个效果就和mutable 函数的效果是一样的了。
    // 其实mutalbe 方法和 结构体里面的常规的方法都是一样的了，只是它隐式的将self 的参数改成了inout
}
translateByTwentyTwenty(rectangle: &screen)
print(screen)

func +=(lhs:inout myPoint, rhs: myPoint) // right without inoutn
{
    lhs = lhs + rhs
}

var testPoint = myPoint.origin
testPoint += myPoint(x:10,y:10)
print(testPoint)

var array = [myPoint(x:0,y:0), myPoint(x:10,y:10)]
array[0] += myPoint(x: 100, y: 100)
print(array) // array[0] 是可以作为 inout的呀






