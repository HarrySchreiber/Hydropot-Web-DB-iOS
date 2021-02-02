//
//  Notification.swift
//  HydroPot
//
//  Created by Eric  Lisle on 2/1/21.
//

import Foundation


class Notification: ObservableObject, Identifiable {
    @Published var text: String
    @Published var timeStamp: Date
    
    init() {
        self.text = "Hey Spencer! Your plant, Billy, was just watered by your Hydro Pot!"
        self.timeStamp = Date()
    }
}

    
