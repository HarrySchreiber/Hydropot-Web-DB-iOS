//
//  GraphBar.swift
//  HydroPot
//
//  Created by David Dray on 4/6/21.
//

import Foundation

struct GraphBar : Identifiable {
    var id = UUID()
    var xValue: String
    var displayValue: Int
    var barHeight: Double
    
    init(xValue: String, displayValue: Int, barHeight: Double) {
        self.xValue = xValue
        self.displayValue = displayValue
        self.barHeight = barHeight
    }
}

