//
//  User.swift
//  HydroPot
//
//  Created by Eric  Lisle on 1/27/21.
//

import Foundation


class GetUser: ObservableObject {
    // initialize an empty array of monsters to be filled
    @Published var userId: String
    @Published var loggedIn: Bool
    @Published var name: String
    @Published var email: String
    @Published var password: String
    @Published var pots: [Pot]


    init() {
        self.userId = ""
        self.loggedIn = false
        self.name = ""
        self.email = ""
        self.password = ""
        self.pots = [Pot(), Pot(), Pot(), Pot()]
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
    
}
