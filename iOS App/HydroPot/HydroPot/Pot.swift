//
//  Pot.swift
//  HydroPot
//
//  Created by Eric  Lisle on 1/28/21.
//

import Foundation

class Pot: ObservableObject, Identifiable {
    // initialize an empty array of monsters to be filled
    @Published var plantName: String
    @Published var plantType: String
    @Published var idealTempLow: Int
    @Published var curTemp: Int
    @Published var idealTempHigh: Int
    @Published var idealMoistureLow: Int
    @Published var idealMoistureHigh: Int
    @Published var idealLightLow: Int
    @Published var idealLightHigh: Int
    @Published var lastWatered: Date
    @Published var automaticWatering: Bool
    @Published var records: [Record]
    @Published var notifications: [Notification]
    

    init() {
        self.plantName = "billy"
        self.plantType = "tulip"
        self.idealTempLow = 60
        self.curTemp = 65
        self.idealTempHigh = 70
        self.idealMoistureLow = 30
        self.idealMoistureHigh = 60
        self.idealLightLow = 1000
        self.idealLightHigh = 4000
        self.lastWatered = Date()
        self.automaticWatering = true
        self.records = [Record(), Record()]
        self.notifications = [Notification(), Notification()]
    }
}
