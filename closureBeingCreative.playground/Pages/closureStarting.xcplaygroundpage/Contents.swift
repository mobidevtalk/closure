//: [Index](Index)

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
