//
//  Pot.swift
//  HydroPot
//
//  Created by Eric  Lisle on 1/28/21.
//

import Foundation

class Pot: ObservableObject, Identifiable {
    @Published var plantName: String
    @Published var plantType: String
    @Published var idealTempLow: Int
    @Published var curTemp: Int
    @Published var idealTempHigh: Int
    @Published var idealMoistureLow: Int
    @Published var curMoisture: Int
    @Published var idealMoistureHigh: Int
    @Published var idealLightLow: Int
    @Published var curLight: Int
    @Published var idealLightHigh: Int
    @Published var lastWatered: Date
    @Published var automaticWatering: Bool
    @Published var records: [Record]
    @Published var notifications: [Notification]
    @Published var id: UUID
    

    init(plantName: String, plantType: String, idealTempHigh: Int, idealTempLow: Int, idealMoistureHigh: Int, idealMoistureLow: Int, idealLightHigh: Int, idealLightLow: Int) {
        self.plantName = plantName
        self.plantType = plantType
        self.curTemp = 65
        self.idealTempLow = idealTempLow
        self.idealTempHigh = idealTempHigh
        self.idealMoistureLow = idealMoistureLow
        self.curMoisture = 60
        self.idealMoistureHigh = idealMoistureHigh
        self.idealLightLow = idealLightLow
        self.curLight = 3000
        self.idealLightHigh = idealLightHigh
        self.lastWatered = Date()
        self.automaticWatering = true
        self.records = [Record(), Record()]
        self.notifications = [Notification(), Notification()]
        self.id = UUID()
    }
    
    func editPlant(plantName: String, plantType: String, idealTempHigh: Int, idealTempLow: Int, idealMoistureHigh: Int, idealMoistureLow: Int, idealLightHigh: Int, idealLightLow: Int) {
        self.plantName = plantName
        self.plantType = plantType
        self.curTemp = 65
        self.idealTempLow = idealTempLow
        self.idealTempHigh = idealTempHigh
        self.idealMoistureLow = idealMoistureLow
        self.curMoisture = 60
        self.idealMoistureHigh = idealMoistureHigh
        self.idealLightLow = idealLightLow
        self.curLight = 3000
        self.idealLightHigh = idealLightHigh
        self.lastWatered = Date()
        self.automaticWatering = true
        self.records = [Record(), Record()]
        self.notifications = [Notification(), Notification()]
    }
    
}

