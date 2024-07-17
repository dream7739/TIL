
import Foundation

/* ARC: 힙 영역과 관련 */
// 스택: 구조체, 열거형 등 (값타입), 힙: 클래스, 클로저 등(참조 타입)
// delegate, closure 등에서 순환참조가 발생할 수 있고, 이를 방지하기 위해 ARC를 사용
// ARC(컴파일시점에 확정) <-> MRC(ex: GC(java) 런타임 시점에 확정)

class Owner {
    let name: String
    
    init(name: String) {
        print("Owner Init")
        self.name = name
    }
    
    deinit {
        print("Owner Deinit")
    }
}

class CreditCard {
    let name: String
    
    init(name: String) {
        print("CreditCard Init")
        self.name = name
    }
    
    deinit {
        print("CreditCard Deinit")
    }
}

// 옵셔널 ? 
//annot assign to value: 'ruppy' is a 'let' constant
//let -> 변할 수 없음 -> var로 바꾸면 될까
//error: 'nil' cannot be assigned to type 'Owner'
//nil이 들어올수있다는 것을 명시하면 오류가 나지 않음

let a: Int? = nil
//a = nil //불가능, let은 불변값임

var b: Int? = 2
//b = nil //불가능, 타입 명시 필요

// 정상적인 deinit
//왜? 인스턴스 생성으로 Onwer(instance) RC 1, CreditCard(instance) RC 1
var ruppy: Owner? = Owner(name: "ruppy")
var ruppyCard: CreditCard? = CreditCard(name: "ruppyCard")
ruppy = nil
ruppyCard = nil


class DogOwner {
    let name: String
    var dog: Dog?
    
    init(name: String) {
        print("DogOwner Init")
        self.name = name
    }
    
    deinit {
        print("DogOwner Deinit")
    }
}

class Dog {
    let name: String
    weak var owner: DogOwner?
    
    init(name: String) {
        print("Dog Init")
        self.name = name
    }
    
    deinit {
        print("Dog Deinit")
    }
}

var dogOwner: DogOwner? = DogOwner(name: "ruppy") //DogOwner RC 1
var dog: Dog? = Dog(name: "rupDog") //Dog RC 1

dog?.owner = dogOwner //DogOwner RC 1
dogOwner?.dog = dog //Dog RC 2

dog = nil //RC 2 > RC 1 > owner가 해제되면서 RC 0
dogOwner = nil //RC1 > RC 0 으로 해제

dog?.owner
dogOwner?.dog

//weak: 수명이 더 짧은. 더 빨리 해제되는 인스턴스를 가리키는 프로퍼티한테 weak를 선언을 함 > 하지만 다 붙이는게 통상적으로 편함
//unowned: 수명이 다른 인스턴스와 동일하거나 더 긴 경우에 unonwed를 붙임 > 메모리가 해제되어도 주소값 남아있어서 접근하면 문제
//weak와 unonwned: 둘 다 RC를 올리지 않음

func test1(){
    var number = 10
    
    //캡처리스트: 복사 형태로 값을 가져옴. 외부와 독립적 값 사용
    let closure = { [number] in
        print("\(number * 2)")
    }
    
    closure() //20
    number = 100
    closure() //20
}

test1()


func test2(){
    var number = 10
    
    let closure = {
        print("\(number * 2)")
    }
    
    closure() //20
    number = 100
    closure() //200
}

test2()

// cannot use instance member 'name' within property initializer
// property initializers run before 'self' is available => lazy로 시점을 늦춰야 name을 쓸수있음
// 클로저 안에서 사용할때는 self를 붙이라고 함
// capture 'self' explicitly to enable implicit 'self' in this closure
//deinit안됨 > 왜?? self를 클로저가 잡고 있어서 RC+1
//[weak self]를 통해 deinit 시켜줄 수 있음
class BBORORO {
    let name: String
    
    lazy var introduce = { [weak self] in
        print("안녕 난 \(self?.name ?? "루피")야")
    }
    
    init(name: String) {
        print("BBORORO init")
        self.name = name
    }
    
    deinit {
        print("BBORORO Deinit")
    }
}

var bbororo: BBORORO? = BBORORO(name: "뽀로로")
bbororo?.introduce //함수 그자체
bbororo?.introduce() //함수의 실행
bbororo = nil


//'weak' must not be applied to non-class-bound 'any RuppyProtocol'; consider adding a protocol conformance that has a class bound
//protocol에 클래스 제약 걸라는 말
protocol RuppyProtocol: AnyObject {
    func sendData()
}

class Main: RuppyProtocol {
    
    lazy var detail = {
        let detail = Detail()
        detail.delegate = self
        return detail
    }()
    
    init() {
        print("Main Init")
    }
    
    func sendData(){
        print("나 데이터야 돌아왔어")
    }
    
    deinit {
        print("Main Deinit")
    }
}

class Detail {
    weak var delegate: RuppyProtocol?
    
    func dismiss(){
        delegate?.sendData()
    }
    
    init(){
        print("Detail Init")
    }
    
    
    deinit {
        print("Detail Deinit")
    }
}

var main: Main? = Main()
main?.detail.dismiss()
main = nil
