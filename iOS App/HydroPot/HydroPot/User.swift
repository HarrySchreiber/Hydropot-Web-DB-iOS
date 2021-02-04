//
//  User.swift
//  HydroPot
//
//  Created by Eric  Lisle on 1/27/21.
//

import Foundation


class GetUser: ObservableObject {
    @Published var userId: String
    @Published var loggedIn: Bool
    @Published var name: String
    @Published var email: String
    @Published var password: String
    @Published var pots: [Pot]


    init() {
        self.userId = "Spencer The Cool"
        self.loggedIn = false
        self.name = ""
        self.email = ""
        self.password = ""
        let specialPot = Pot(plantName: "Bob", plantType: "Rose", idealTempHigh: "70", idealTempLow: "80", idealMoistureHigh: "50", idealMoistureLow: "70", idealLightHigh: "40", idealLightLow: "40")
        specialPot.plantName = "Jeff"
        self.pots = [Pot(plantName: "Jill", plantType: "Rose", idealTempHigh: "70", idealTempLow: "80", idealMoistureHigh: "50", idealMoistureLow: "70", idealLightHigh: "40", idealLightLow: "40"), specialPot]
    }
    
    func login (email: String, password: String) {
        self.userId = ""
        self.loggedIn = true
        self.name = ""
        self.email = email
        self.password = password
    }
    
    func changePass(newPass: String) {
        self.password = newPass
    }
    
    func logout() {
        self.userId = ""
        self.loggedIn = false
        self.name = ""
        self.email = ""
        self.password = ""
    }
    
    func signup(userId: String, name: String, email: String, password: String) {
        self.userId = userId
        self.loggedIn = true
        self.name = name
        self.email = email
        self.password = password
    }
    
    func addPlant(pot: Pot) {
        pots.append(pot)
    }
    
    func replacePot(pot: Pot){
        for (index, _) in pots.enumerated() {
            if (self.pots[index].id == pot.id){
                self.pots[index] = pot
            }
        }
    }
    
}
