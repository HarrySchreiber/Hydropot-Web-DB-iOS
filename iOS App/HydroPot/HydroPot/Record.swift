//
//  Record.swift
//  HydroPot
//
//  Created by Eric  Lisle on 2/1/21.
//

import Foundation


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

    
