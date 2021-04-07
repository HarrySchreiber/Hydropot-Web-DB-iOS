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
    @Published var isLightLowGood: Bool //color for low
    @Published var isLightHighGood: Bool //color for high
    @Published var isMoistLowGood: Bool //color for low
    @Published var isMoistHighGood: Bool //color for high
    @Published var isTempLowGood: Bool //color for low
    @Published var isTempHighGood: Bool //color for high


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
        self.idealTemperatureHigh = idealTemperatureHigh
        self.idealMoistureHigh = idealMoistureHigh
        self.idealLightLevelHigh = idealLightLevelHigh
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
        isLightLowGood = true
        isLightHighGood = true
        isMoistLowGood = true
        isMoistHighGood = true
        isTempLowGood = true
        isTempHighGood = true
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
        self.idealTemperatureHigh = String(idealTemperatureHigh)
        self.idealMoistureHigh = String(idealMoistureHigh)
        self.idealLightLevelHigh = String(idealLightLevelHigh)
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
            
            //if temp high is not fine
            if (idealTemperatureHigh.isEmpty || !isInt(num: idealTemperatureHigh) || Int(idealTemperatureHigh) ?? 0 < Int(idealTemperatureLow) ?? 0 ) {
                //temp high is no good
                isTempHighGood = false
            }
            else {
                //temp high is v good
                isTempHighGood = true
            }
            //if temp low is not fine
            if (idealTemperatureLow.isEmpty || !isInt(num: idealTemperatureLow) || Int(idealTemperatureHigh) ?? 0 < Int(idealTemperatureLow) ?? 0 ){
                //temp high is no good
                isTempLowGood = false
            }
            else {
                //temp low is v good
                isTempLowGood = true
            }
        }
        else {
            //set temp true
            isTempLowGood = true
            isTempHighGood = true
            isTempGood = true
        }
        //check moisture bounds
        if (idealMoistureHigh.isEmpty || idealMoistureLow.isEmpty || !isInt(num: idealMoistureHigh) || !isInt(num: idealMoistureLow) || Int(idealMoistureHigh) ?? 0 < Int(idealMoistureLow) ?? 0 ||
            Int(idealMoistureHigh) ?? 0 > 100 || Int(idealMoistureHigh) ?? 0 < 0 || Int(idealMoistureLow) ?? 0 > 100 || Int(idealMoistureLow) ?? 0 < 0) {
            //set moist false
            isMoistGood = false
            
            //if moisture high is false
            if (idealMoistureHigh.isEmpty || !isInt(num: idealMoistureHigh) || Int(idealMoistureHigh) ?? 0 < Int(idealMoistureLow) ?? 0 || Int(idealMoistureHigh) ?? 0 > 100 || Int(idealMoistureHigh) ?? 0 < 0){
                //moisture high is no good
                isMoistHighGood = false
            }
            else {
                //moist high is v good
                isMoistHighGood = true
            }
            
            //if moisture low is false
            if (idealMoistureLow.isEmpty || !isInt(num: idealMoistureLow) || Int(idealMoistureLow) ?? 0 > 100 || Int(idealMoistureLow) ?? 0 < 0){
                //moisture low is no good
                isMoistLowGood = false
            }
            else {
                //moisture high is v good
                isMoistLowGood = true
            }
        }
        else {
            //set moist true
            isMoistLowGood = true
            isMoistHighGood = true
            isMoistGood = true
        }
        //check light level bounds
        if (idealLightLevelHigh.isEmpty || idealLightLevelLow.isEmpty ||
            !isInt(num: idealLightLevelHigh) || !isInt(num: idealLightLevelLow) ||
            Int(idealLightLevelHigh) ?? 0 < Int(idealLightLevelLow) ?? 0){
            //set light false
            isLightGood = false
            
            //if light high is false
            if (idealLightLevelHigh.isEmpty || !isInt(num: idealLightLevelHigh) ||  Int(idealLightLevelHigh) ?? 0 < Int(idealLightLevelLow) ?? 0) {
                //light high good v bad
                isLightHighGood = false
            }
            else {
                //light high is v good
                isLightHighGood = true
            }
            
            //if light low is false
            if (idealLightLevelLow.isEmpty || !isInt(num: idealLightLevelLow) || Int(idealLightLevelHigh) ?? 0 < Int(idealLightLevelLow) ?? 0) {
                //light low good is v bad
                isLightLowGood = false
            }
            else {
                //light low good is v good
                isLightHighGood = true
            }
        }
        else {
            //set light true
            isLightLowGood = true
            isLightHighGood = true
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
