//: [Index](Index)

import Foundation

/*:
 Forming Strong Reference Cycles
 */

// MARK: - Forming Strong Reference Cycles with two class
class Jedi{
    let name: String
    var weapon: Lightsaber?
    
    init(name: String) {
        self.name = name
        "\(name) is a Jedi now"
    }
    
    deinit {
        "\(name) became one with the Force"
    }
}

class Lightsaber{
    var owner: Jedi?
    let type: String
    let model: String
    
    init(type: String, model: String) {
        self.type = type
        self.model = model
        "The \(type) \(model) lightsaber is formed"
    }
    
    deinit {
        "\(owner?.name ?? "") \(type) \(model) lightsaber is destroyed"
    }
}

var lightsaber: Lightsaber?
var yoda: Jedi?

lightsaber = Lightsaber(type: "single blade", model: "Shoto")
yoda = Jedi(name: "Yoda")

yoda?.weapon = lightsaber
lightsaber?.owner = yoda

yoda?.weapon = nil
//lightsaber?.owner = nil

yoda = nil
lightsaber = nil


/*:
 Dissection of unowned and weak﻿
 */

// MARK: - Breaking Strong Reference cycle
class JediMaster{
    let name: String
    weak var weapon: PlasmaLightsaber?
    
    init(name: String) {
        self.name = name
        "\(name) is a Jedi Master now"
    }
    
    deinit {
        "\(name) became one with the Force"
    }
}

class PlasmaLightsaber{
    let type: String
    var owner: JediMaster?
    
    init(type: String) {
        self.type = type
        "The \(type) lightsaber is formed"
    }
    
    deinit {
        "\(owner?.name ?? "") \(type) lightsaber is destroyed"
    }
}

var obwan: JediMaster? = JediMaster(name: "Obi-Wan Kenobi")
var obwanLightsaber: PlasmaLightsaber? = PlasmaLightsaber(type: "single blade")

obwan?.weapon = obwanLightsaber
obwanLightsaber?.owner = obwan

obwan = nil
obwanLightsaber = nil



