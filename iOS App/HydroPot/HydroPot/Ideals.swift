//
//  Ideals.swift
//  HydroPot
//
//  Created by Eric  Lisle on 3/22/21.
//

import Foundation
import SwiftUI


class Ideals: ObservableObject {
    //ideal temperature high for the pot
    @Published var idealTemperatureHigh: String {
        didSet {
            updateColors()
        }
    }
    //ideal moisture high for the pot
    @Published var idealMoistureHigh: String {
        didSet {
            updateColors()
        }
    }
    //ideal light level high for the pot
    @Published var idealLightLevelHigh: String {
        didSet {
            updateColors()
        }
    }
    //ideal temperature low for the pot
    @Published var idealTemperatureLow: String {
        didSet {
            updateColors()
        }
    }
    //ideal moisture low for the pot
    @Published var idealMoistureLow: String {
        didSet {
            updateColors()
        }
    }
    //ideal light low for the pot
    @Published var idealLightLevelLow: String {
        didSet {
            updateColors()
        }
    }
    @Published var plantSelected: String //plant selected by the user
    @Published var potID: String //id for the pot
    @Published var plantName: String //name of the plant
    @Published var notificationFrequency: Int
    @Published var isTempGood: Bool //color for temp
    @Published var isMoistGood: Bool //color for moist
    @Published var isLightGood: Bool //color for light


    /// Constructor for ideals
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
    init(idealTemperatureHigh: String, idealTemperatureLow: String, idealMoistureHigh: String, idealMoistureLow: String, idealLightLevelLow: String, idealLightLevelHigh: String, plantName: String, plantSelected: String, notificationFrequency: Int) {
        self.idealTemperatureHigh = idealMoistureHigh
        self.idealMoistureHigh = idealMoistureHigh
        self.idealLightLevelHigh = idealTemperatureLow
        self.idealTemperatureLow = idealTemperatureLow
        self.idealMoistureLow = idealMoistureLow
        self.idealLightLevelLow = idealLightLevelLow
        self.plantSelected = plantSelected
        self.plantName = plantName
        self.potID = ""
        self.notificationFrequency = notificationFrequency
        self.isTempGood = true
        self.isMoistGood = true
        self.isLightGood = true
        updateColors()
        
    }
    
    
    /// editing ideals
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
    func editIdeals(idealTemperatureHigh: Int, idealTemperatureLow: Int, idealMoistureHigh: Int, idealMoistureLow: Int, idealLightLevelHigh: Int, idealLightLevelLow: Int, plantName: String, plantSelected: String, notificationFrequency: Int) {
        self.idealTemperatureHigh = String(idealMoistureHigh)
        self.idealMoistureHigh = String(idealMoistureHigh)
        self.idealLightLevelHigh = String(idealTemperatureLow)
        self.idealTemperatureLow = String(idealTemperatureLow)
        self.idealMoistureLow = String(idealMoistureLow)
        self.idealLightLevelLow = String(idealLightLevelLow)
        self.plantSelected = plantSelected
        self.plantName = plantName
        self.notificationFrequency = notificationFrequency
        updateColors()
    }
    
    ///function to update coloring on fields
    func updateColors() {
        //check for temp bounds
        if (idealTemperatureHigh.isEmpty || idealTemperatureLow.isEmpty || !isInt(num: idealTemperatureHigh) || !isInt(num: idealTemperatureLow) || Int(idealTemperatureHigh) ?? 0 < Int(idealTemperatureLow) ?? 0 ) {
            //set temp false
            isTempGood = false
        }
        else {
            //set temp true
            isTempGood = true
        }
        //check moisture bounds
        if (idealMoistureHigh.isEmpty || idealMoistureLow.isEmpty || !isInt(num: idealMoistureHigh) || !isInt(num: idealMoistureLow) || Int(idealMoistureHigh) ?? 0 < Int(idealMoistureLow) ?? 0 ||
            Int(idealMoistureHigh) ?? 0 > 100 || Int(idealMoistureHigh) ?? 0 < 0 || Int(idealMoistureLow) ?? 0 > 100 || Int(idealMoistureLow) ?? 0 < 0) {
            //set moist false
            isMoistGood = false
        }
        else {
            //set moist true
            isMoistGood = true
        }
        //check light level bounds
        if (idealLightLevelHigh.isEmpty || idealLightLevelLow.isEmpty ||
            !isInt(num: idealLightLevelHigh) || !isInt(num: idealLightLevelLow) ||
            Int(idealLightLevelHigh) ?? 0 < Int(idealLightLevelLow) ?? 0){
            //set light false
            isLightGood = false
        }
        else {
            //set light true
            isLightGood = true
        }
    }
    
    ///Evalueates if a string is an integer
    ///
    /// - Parameters:
    ///     - num: String of the number to be evaluated
    func isInt(num: String) -> Bool{
        return Int(num) != nil
    }
}
