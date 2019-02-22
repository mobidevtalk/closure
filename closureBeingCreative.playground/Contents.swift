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


