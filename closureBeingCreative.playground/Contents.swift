import Foundation

/*:
 Introduction of closure
 */
let sum = {
    (first: Int, second: Int) -> Int in
    return first + second
}

sum(10, 20)

/*:
 Different variants of closure expression
 */

let prime = [ 2, 3, 5, 7, 11, 13, 17, 19]
var total = 0

prime.forEach { (element: Int) in
    total += element
}

total

prime.filter { (element) -> Bool in
    return element > 7
}

prime.filter { (element) -> Bool in
    element > 7
}

prime.forEach( { total += $0 } )

prime.filter( { $0 > 7 } )

/*:
 Trailing closure
 */

func operationPrinter(firstOperand: Int, secondOperand: Int, operation: (Int, Int)-> Int){
    "The operation of \(firstOperand) and \(secondOperand) is \(operation(firstOperand, secondOperand))"
}

operationPrinter(firstOperand: 10, secondOperand: 20) { $0 + $1 }

operationPrinter(firstOperand: 10, secondOperand: 20) { $0 * $1 }

/*:
 Escaping closure
 */
struct Coordinator{
    let x: Int
    let y: Int
}

var coordinators = [Coordinator]()
for _ in 1...100{
    coordinators.append(Coordinator(x: Int.random(in: 100...999), y: Int.random(in: 100...999)))
//    coordinators[i] =
}

var completion: (([Coordinator])->Void)?

func immediateSort(completionHandler: ([Coordinator])-> Void, entry: [Coordinator]){
    var mutableEntry = entry
    mutableEntry.sort(by: { $0.x > $1.x })
    completionHandler(mutableEntry)
}

immediateSort(completionHandler: { sorted in
    sorted.forEach {
        $0.x
        $0.y
    }
}, entry: coordinators)


completion = nil

func sort(_ completionHandler: @escaping ([Coordinator])-> Void, entry: [Coordinator]){
    completion = completionHandler
    DispatchQueue.global().async {
        var mutableEntry = entry
        mutableEntry.sort(by: { $0.x > $1.x })
        
        DispatchQueue.main.async {
            if let handler = completion{
                handler(mutableEntry)
            }
        }
    }
}
sort({ sorted in
    sorted.forEach {
        $0.x
        $0.y
    }
}, entry: coordinators)


