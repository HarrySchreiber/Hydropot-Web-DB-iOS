//
//  Plants.swift
//  HydroPot
//
//  Created by David Dray on 1/30/21.
//

import Foundation

class Plant: ObservableObject, Identifiable {
    // initialize an empty array of monsters to be filled
    @Published var plantType: String
    @Published var idealTempLow: Int
    @Published var idealTempHigh: Int
    @Published var idealMoistureLow: Int
    @Published var idealMoistureHigh: Int
    @Published var idealLightLow: Int
    @Published var idealLightHigh: Int
    @Published var Description: String

    init() {
        self.plantType = "Tulip"
        self.idealTempLow = 60
        self.idealTempHigh = 70
        self.idealMoistureLow = 30
        self.idealMoistureHigh = 60
        self.idealLightLow = 1000
        self.idealLightHigh = 4000
        self.Description = "This plant is a good plant! This plant is so good it will make you happy to be a plant owner. Even if you hate your life this plant will make you no longer hate your life"
    }

}
