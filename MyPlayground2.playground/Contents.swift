import UIKit

let defaults = UserDefaults.standard

class Car {
    
    var color = "Red"
    
    static let singletonCar = Car()
    
}

//let myCar = Car()
//myCar.color = "Red"
//
//let yourCar = Car()
//print(yourCar.color)

//let myCar = Car.singletonCar
//myCar.color = "Blue"
//
//let yourCar = Car.singletonCar
//print(yourCar.color)
//
//class A {
//    init() {
//        Car.singletonCar.color = "Brown"
//    }
//}
//
//class B {
//    init() {
//        print(Car.singletonCar.color)
//
//    }
//}
//
//let a = A()
//let b = B()


