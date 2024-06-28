import UIKit

/*
 First Class Object
 변수/상수나 데이터 구조 안에 함수 저장 가능
 함수의 결과값이 아닌, 함수 자체의 대입
 1. 변수/상수에 저장 가능 2. 매개변수 or 반환값에 전달 가능
 */

func checkPocketmon(name: String) -> Bool {
    let poketmonArry = ["꼬부기", "피카추", "파이리", "이상해씨"]
    return poketmonArry.contains(name) ? true : false
}

//함수 반환값의 저장
let jm = checkPocketmon(name: "jm")

//함수의 대입
let jmIsPoketMon = checkPocketmon

//함수 호출 시 함수 실행
jmIsPoketMon("jm")

//오버로딩으로 인한 함수 구분
//1. 타입 어노테이션으로 구분 (Int, String) -> Int, String -> String
//2. 타입 어노테이션으로도 구분이 어려우면 식별자 사용
//식별자가 다른 경우 타입 어노테이션을 사용하지 않아도 됨
func hello(nickname: String) -> String {
    return "I am \(nickname)!"
}

func hello(userName: String) -> String {
    return "I am \(userName)!"
}

func hello(nickname: String, age: Int) -> String {
    return "I am \(nickname), age is \(age)!"
}

func hello() -> String {
    return "Just hello!"
}

//함수 식별자로 구분
let jmHello = hello(nickname:age:)
jmHello("jm", 18)

//타입어노테이션으로 구분
let ruppyHello: (String, Int) -> String = hello
ruppyHello("ruppy", 7)


/* 함수의 반환값으로 사용*/
func checkPocketmon2(name: String) -> () -> String {
    let poketmonArry = ["꼬부기", "피카추", "파이리", "이상해씨"]
    return poketmonArry.contains(name) ? isPoketmon : isNotPoketmon
}

func isPoketmon() -> String {
    return "I am Poketmon"
}

func isNotPoketmon() -> String {
    return "I am not Poketmon"
}

let et = checkPocketmon2(name: "et")
et()

enum Operand {
    case plus
    case minus
}

func plus(a: Int, b: Int) -> Int {
    return a + b
}

func minus(a: Int, b: Int) -> Int {
    return a - b
}

func calculate(operand: Operand) -> (Int, Int) -> Int {
    switch operand {
    case .plus:
        return plus
    case .minus:
        return minus
    }
}

let result = calculate(operand: .minus)
result(5, 3)


/* 함수의 인자값으로 사용 
 콜백함수 : 특정 구문의 실행이 끝나면 시스템이 호출하도록 처리가 된 함수
 어떤 함수던 상관없이 "타입"만 맞으면 되는 중개 역할 함수 => 브로커 함수
 항상 함수를 만들어서 인자에 넣기 힘들기 때문에 "익명"함수로 사용을 하기도 함
 */

func oddNumber(){
    print("홀수입니다.")
}

func evenNumber(){
    print("짝수입니다.")
}

func resultNumber(base: Int, odd: () -> (), even: () -> ()){
    return base.isMultiple(of: 2) ? even() : odd()
}

resultNumber(base: 4, odd: oddNumber, even: evenNumber)

func incr(param: Int) -> Int {
    return param + 1
}

func brocker(base: Int, func fn: (Int) -> Int) -> Int{
    return fn(base)
}

let a = brocker(base: 3, func: incr)

/* 외부함수 내부함수
 외부함수 내의 내부 함수 => 생명주기에 영향
 내부함수의 생명주기는 외부로부터 차단 => 은닉성
 */

func drawingGame(item: Int) -> String {
    func luckyNumber(number: Int) -> String {
        return "\(number * Int.random(in: 1...5))"
    }
    
    let result = luckyNumber(number: item * 2)
    return result
}

drawingGame(item: 10)
//luckyNumber(number: 20) 접근 불가

func drawingGame2(item: Int) -> (Int) -> String {
    func luckyNumber(number: Int) -> String {
        return "\(item * number * Int.random(in: 1...5))"
    }
    
    return luckyNumber
}

//외부함수의 생명주기가 끝나더라도 내부함수의 사용이 가능
let luckyNumber = drawingGame2(item: 10)
luckyNumber(2)

/* Closure Capture 
 클로저: 내부함수이면서, 내부함수가 만들어진 Context 두가지를 포함해 말함
 내부함수와 외부함수에 영향을 미친 주변환경을 모두 포함한 객체
 */

func basic(param: Int) -> (Int) -> Int {
    let value = param + 20
    func append(add: Int) -> Int {
        return value + add
    }
    return append
}

// 내부함수가 존재 => 클로저가 아님
// 직접 호출이 될때 클로저가 생성. 아래 20, 40을 넣어주고 있는데
// 두 함수는 value가 30, 60인 환경을 저장 => 서로 다른 환경 저장
// 값이 캡처되었다라고 함 => 주변환경에 포함된 변수나 상수의 타입이 기본 or 구조체 자료형일때 발생
let basicResult = basic(param: 10)
basicResult(20)
basicResult(40)


/* Closure Expression */
func getStudyWithMe(study: () -> ()){
    study()
}

//인라인 클로저
getStudyWithMe { () -> () in
    print("열공중")
}

//트레일링 클로저
getStudyWithMe {
    print("열공중")
}

func todayNumber(result: (Int) -> String ){
    result(Int.random(in: 1...100))
}

todayNumber { (number) in
    return "행운의 숫자 \(number)"
}

todayNumber {
    return "행운의 숫자 \($0)"
}

todayNumber{ "행운의 숫자 \($0)"}
