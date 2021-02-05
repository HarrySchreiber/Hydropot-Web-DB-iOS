//
//  Plants.swift
//  HydroPot
//
//  Created by David Dray on 1/30/21.
//

import Foundation



class Plant: ObservableObject, Identifiable {
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

class Plants: ObservableObject, Identifiable {
    @Published var plantList: [Plant]

    init() {
        let specialPlant = Plant()
        specialPlant.plantType = "Special Plant"
        specialPlant.idealLightHigh = 100000
        specialPlant.idealLightLow = 0
        specialPlant.idealTempLow = 0
        specialPlant.idealTempHigh = 100
        specialPlant.idealMoistureLow = 0
        specialPlant.idealMoistureHigh = 100
        self.plantList = [Plant(), Plant(), Plant(), specialPlant, Plant(), Plant()]
    }
    
    func contains(plantName: String) -> Bool {
        for (index, _) in plantList.enumerated() {
            if (self.plantList[index].plantType == plantName){
                return true
            }
        }
        return false
    }
    
    /* DO NOT USE UNLESS YOU HAVE CALLED CONTAINS FIRST*/
    func getPlant(plantName: String) -> Plant {
        for (index, _) in plantList.enumerated() {
            if (self.plantList[index].plantType == plantName){
                return plantList[index]
            }
        }
        return Plant()
    }
    
}
