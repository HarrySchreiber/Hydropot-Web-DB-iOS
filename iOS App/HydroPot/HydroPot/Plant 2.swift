//
//  Plant.swift
//  HydroPot
//
//  Created by Eric  Lisle on 3/10/21.
//

import Foundation

/*
    class for handling individual plants that make up the plants list
 */
class Plant: ObservableObject, Identifiable {
    @Published var plantType: String //type of the plant
    @Published var idealTempLow: Int //ideal low temp of the plant
    @Published var idealTempHigh: Int //ideal high temp of the plant
    @Published var idealMoistureLow: Int //ideal moisture low of the plant
    @Published var idealMoistureHigh: Int //ideal moisture high of the plant
    @Published var idealLightLow: Int //ideal light low of the plant
    @Published var idealLightHigh: Int //ideal light high of the plant
    @Published var description: String //description of the plant type
    @Published var imageURL: String //image string (s3) of the plant type
    
    /// constructor for plant
    ///
    /// - Parameters:
    ///     - plantType: Type of the plant
    ///     - idealTempLow: Ideal low temp of the plant
    ///     - idealTempHigh: Ideal high temp of the plant
    ///     - idealMoistureLow: Ideal moisture low of the plant
    ///     - idealMoistureHigh: Ideal moisture high of the plant
    ///     - idealLightLow: Ideal light low of the plant
    ///     - idealLightHigh: Ideal light high of the plant
    ///     - description: Description of the plant type
    ///     - imageURL: Image string (s3) of the plant type
    init(plantType: String, idealTempLow: Int, idealTempHigh: Int, idealMoistureLow: Int, idealMoistureHigh: Int,
         idealLightLow: Int, idealLightHigh: Int, description: String, imageURL: String) {
        self.plantType = plantType
        self.idealTempLow = idealTempLow
        self.idealTempHigh = idealTempHigh
        self.idealMoistureLow = idealMoistureLow
        self.idealMoistureHigh = idealMoistureHigh
        self.idealLightLow = idealLightLow
        self.idealLightHigh = idealLightHigh
        self.description = description
        self.imageURL = imageURL
    }
    
}

/*
    codable struct for plant used to recieve json data
 */
struct codePlant: Codable, Identifiable {
    let id: String //id to conform to identifiable
    let plantType: String //type of the plant
    let idealTempLow: Int //ideal low temp of the plant
    let idealTempHigh: Int //ideal high temp of the plant
    let idealMoistureLow: Int //ideal moisture low of the plant
    let idealMoistureHigh: Int //ideal moisture high of the plant
    let idealLightLow: Int //ideal light low of the plant
    let idealLightHigh: Int //ideal light high of the plant
    let description: String //description of the plant type
    let imageURL: String //image string (s3) of the plant type
    
    //to conform to codable
    enum CodingKeys: String, CodingKey {
        case id, description, idealLightHigh, idealLightLow, idealMoistureHigh, idealMoistureLow,
             idealTempHigh, idealTempLow, plantType, imageURL
    }
}

