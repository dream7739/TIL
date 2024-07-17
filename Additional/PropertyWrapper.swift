//: [Previous](@previous)

import Foundation

@propertyWrapper
struct SmallNumber {
    private var maximum: Int
    private var number: Int
    private(set) var projectedValue: Bool

    var wrappedValue: Int {
        get { return number }
        set {
            if newValue > 12 {
                number = 12
                projectedValue = true
            }else{
                number = newValue
                projectedValue = false
            }
        }
    }


    //아무것도 지정하지 않았을 때 기본값
    init() {
        maximum = 12
        number = 0
        projectedValue = false
    }
    
    //wrappedValue(number)만 지정
    init(wrappedValue: Int) {
        maximum = 12
        number = min(wrappedValue, maximum)
        projectedValue = false

    }
    
    //wrappedValue(number, maximum) 지정
    init(wrappedValue: Int, maximum: Int) {
        self.maximum = maximum
        number = min(wrappedValue, maximum)
        projectedValue = false
    }
}

struct Rectangle {
    @SmallNumber(wrappedValue: 16, maximum: 14)
    var width: Int
    
    @SmallNumber(wrappedValue: 4)
    var height: Int
}

var rectangle = Rectangle()
rectangle.width
rectangle.height


//기본생성자 사용
struct ZeroRectangle {
    @SmallNumber var height: Int
    @SmallNumber var width: Int
}


var zeroRectangle = ZeroRectangle()
print(zeroRectangle.height, zeroRectangle.width)

//값을 프로퍼티에 쓰면 init(wrappedValue:) 로 초기화
//SmallNumber(wrappedValue: 1)
struct UnitRectangle {
    @SmallNumber var height: Int = 1
    @SmallNumber var width: Int = 1
}


var unitRectangle = UnitRectangle()
print(unitRectangle.height, unitRectangle.width)


struct NarrowRectangle {
    @SmallNumber(wrappedValue: 2, maximum: 5) var height: Int
    @SmallNumber(wrappedValue: 3, maximum: 4) var width: Int
}
var narrowRectangle = NarrowRectangle()
print(narrowRectangle.height, narrowRectangle.width)

narrowRectangle.height = 100
narrowRectangle.width = 100
print(narrowRectangle.height, narrowRectangle.width)

struct MixedRectangle {
    @SmallNumber var height: Int = 1
    //SmallNumber(wrappedValue: 2, maximum: 9)
    @SmallNumber(maximum: 9) var width: Int = 2
}


var mixedRectangle = MixedRectangle()
print(mixedRectangle.height)
mixedRectangle.height = 20
print(mixedRectangle.height)


//Projecting a Value From a Property Wrapper
enum Size {
    case small, large
}

struct SizedRectangle {
    @SmallNumber var height: Int
    @SmallNumber var width: Int


    mutating func resize(to size: Size) -> Bool {
        switch size {
        case .small:
            height = 10
            width = 20
        case .large:
            height = 100
            width = 100
        }
        print($height)
        print($width)
        return $height || $width
    }
}

var sizeRectangle = SizedRectangle()
sizeRectangle.height = 20
sizeRectangle.width = 20
sizeRectangle.resize(to: .large)
