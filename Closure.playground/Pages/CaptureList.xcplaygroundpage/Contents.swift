//: [Index](Index)

import Foundation

/*:
 Nested Function
 */
var lifeCounter = 1{
    didSet{
        lifeCounter > 0 ? "Still alive" : "Game over"
    }
}

func adjustLifeCount(damaged: Bool){
    func increase(){
        lifeCounter += 1
    }
    
    func decrease(){
        lifeCounter -= 1
    }
    
    damaged ? decrease() : increase()
}


adjustLifeCount(damaged: false)

adjustLifeCount(damaged: true)
adjustLifeCount(damaged: true)

/*:
 How closure capture variables?
 */

enum LightsaberAction: String{
    case poke
    case slash
    case block
}

class LightsaberMove{
    let actions: [LightsaberAction]
    lazy var perform: () -> String = {
        self.actions.reduce(into: "Action sequence:", { (sequence, action) in
            sequence += " " + action.rawValue
        })
    }
    
    init(actions: [LightsaberAction]) {
        self.actions = actions
    }
    
    deinit {
        "All lightsaber moves been complete"
    }
}

var botMove:LightsaberMove? = LightsaberMove(actions: [.slash, .poke, .poke, .block, .slash])
botMove?.perform()

botMove = nil

/*:
 Ins and outs of Capture list.
 */
class Jedi{
    let name: String
    let actions: [LightsaberAction]
    let move = LightsaberMove(actions: [.slash, .poke, .poke, .block, .slash])
    
    lazy var perform: ()->String = {
        [weak self] in
        
        return self?.actions.reduce(into: "Action sequence:", { (sequence, action) in
            sequence += " " + action.rawValue
        }) ?? ""
    }
    
    init(name: String, actions:[LightsaberAction]) {
        self.name = name
        self.actions = actions
    }
    
    deinit {
        "The Jedi: \(name) is no more..."
    }
}

var yoda: Jedi? = Jedi(name: "Yoda", actions: [.slash, .slash, .block, .poke])
yoda?.perform()
yoda = nil
