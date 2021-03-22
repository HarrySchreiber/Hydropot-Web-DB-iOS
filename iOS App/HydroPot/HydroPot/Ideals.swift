//
//  Ideals.swift
//  HydroPot
//
//  Created by Eric  Lisle on 3/22/21.
//

import Foundation

class Ideals: ObservableObject {
    @Published var idealTemperatureHigh: String //ideal temperature high for the pot
    @Published var idealMoistureHigh: String //ideal moisture high for the pot
    @Published var idealLightLevelHigh: String //ideal light level high for the pot
    @Published var idealTemperatureLow: String //ideal temperature low for the pot
    @Published var idealMoistureLow: String //ideal moisture low for the pot
    @Published var idealLightLevelLow: String //ideal light low for the pot
    @Published var plantSelected: String //plant selected by the user
    @Published var potID: String //id for the pot
    @Published var plantName: String //name of the plant


    /// Constructor for user
    ///
    /// - Parameters:
    ///     - idealTemperatureHigh: ideal temperature high for the pot
    ///     - idealMoistureHigh: Is the user logged in
    ///     - idealLightLevelHigh: ideal light level high for the pot
    ///     - idealTemperatureLow: ideal temperature low for the pot
    ///     - idealMoistureLow: ideal moisture low for the pot
    ///     - idealLightLevelLow: ideal light low for the pot
    ///     - plantName name of the plant
    ///     - plantType type of the plant
    ///     - potID: id for the pot
    init() {
        self.idealTemperatureHigh = ""
        self.idealMoistureHigh = ""
        self.idealLightLevelHigh = ""
        self.idealTemperatureLow = ""
        self.idealMoistureLow = ""
        self.idealLightLevelLow = ""
        self.plantSelected = ""
        self.potID = ""
        self.plantName = ""
    }
    
}
