//
//  Record.swift
//  HydroPot
//
//  Created by Eric  Lisle on 2/1/21.
//

import Foundation

struct codeRecord: Codable {

    let dateRecorded: String
    let light: Int
    let moisture: Int
    let reservoir: Int
    let temperature: Int
    let watering: Int
    
    enum CodingKeys: String, CodingKey {
        case light, moisture, reservoir, temperature, dateRecorded, watering
    }
}

class Record: ObservableObject, Identifiable {
    @Published var dateRecorded: Date
    @Published var moisture: Int
    @Published var temperature: Int
    @Published var light: Int
    @Published var reservoir: Int
    @Published var watering: Int
    
    init(dateRecorded: Date, moisture: Int, temperature: Int, light: Int, reservoir: Int, watering: Int) {
        self.dateRecorded = dateRecorded
        self.moisture = moisture
        self.temperature = temperature
        self.light = light
        self.reservoir = reservoir
        self.watering = watering
    }
}

    
