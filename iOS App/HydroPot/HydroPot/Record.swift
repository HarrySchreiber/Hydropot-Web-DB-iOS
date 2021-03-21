//
//  Record.swift
//  HydroPot
//
//  Created by Eric  Lisle on 2/1/21.
//

import Foundation

/*
    codable to store JSON records from the db
 */
struct codeRecord: Codable {
    let dateRecorded: String //date the record was recorded
    let light: Int //light value of record
    let moisture: Int //moisture value of record
    let temperature: Int //temperature value of record
    let watering: Int //watering value of record
    
    //required for conforming to codable
    enum CodingKeys: String, CodingKey {
        case light, moisture, temperature, dateRecorded, watering
    }
}

/*
    class to store record objects
 */
class Record: ObservableObject, Identifiable {
    @Published var dateRecorded: Date //date the record was recorded
    @Published var  light: Int //light value of record
    @Published var  moisture: Int //moisture value of record
    @Published var  temperature: Int //temperature value of record
    @Published var  watering: Int //watering value of record
    
    /// constructor for records
    ///
    /// - Parameters:
    ///     - dateRecorded: Date the record was recorded
    ///     - light: Light value of record
    ///     - moisture: Moisture value of record
    ///     - temperature: Temperature value of record
    ///     - watering: Watering value of record
    init(dateRecorded: Date, moisture: Int, temperature: Int, light: Int, watering: Int) {
        self.dateRecorded = dateRecorded
        self.moisture = moisture
        self.temperature = temperature
        self.light = light
        self.watering = watering
    }
}

    
