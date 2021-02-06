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
    
    enum CodingKeys: String, CodingKey {
        case light, moisture, reservoir, temperature, dateRecorded
    }
}

class Record: ObservableObject, Identifiable {
    @Published var dateRecorded: Date
    @Published var moisture: Int
    @Published var temperature: Int
    @Published var light: Int
    @Published var reservoir: Int
    
    init() {
        self.dateRecorded = Date()
        self.moisture = 70
        self.temperature = 60
        self.light = 1500
        self.reservoir = 20
    }
}

    
