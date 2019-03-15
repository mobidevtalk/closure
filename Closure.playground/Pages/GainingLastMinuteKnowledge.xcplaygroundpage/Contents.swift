//: [Index](Index)

import Foundation

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
}

// MARK: - no @escaping
extension Sequence where Iterator.Element == Coordinator {
    func immediateSort(completion: ([Coordinator])-> Void){
        completion(self.sorted(by: { $0.x > $1.x }))
    }
}

coordinators.immediateSort { sorted in
    sorted.forEach({ print($0.x) })
}

// MARK: - with @escaping
extension Sequence where Iterator.Element == Coordinator{
    func threadSort(completion: @escaping ([Coordinator])-> Void){
        DispatchQueue.global().async {
            let mutableEntry = self.sorted(by: { $0.x > $1.x })
            
            DispatchQueue.main.async {
                completion(mutableEntry)
            }
        }
    }
}

coordinators.removeAll()
for _ in 1...1000{
    coordinators.append(Coordinator(x: Int.random(in: 100...999), y: Int.random(in: 100...999)))
}

coordinators.threadSort { sorted in
    sorted.forEach({ print($0.x) })
}

// MARK: - Using @escaping when the closure is stored on a stored property.
var completion: (([Coordinator])->Void)?

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

/*:
 autoclosure
 */

let success = {"Success"}
let fail = {"Error occurred"}

func evaluate(_ status: Bool){
    status ? success() : fail()
}

evaluate(true)
evaluate(false)

// MARK: - Function without @autoclosure
let status = true

func print(_ result: ()-> String){
    "Summary: \(result())"
}

print { () -> String in
    "Based on our status, having a \(status) value, our final result is \(status ? success() : fail())"
}

// MARK: - Funcion with @autoclosure
func prettyPrint(_ result: @autoclosure ()->String){
    "Summary: \(result())"
}

prettyPrint("Based on our status, having a \(status) value, our final result is \(status ? success() : fail())")
