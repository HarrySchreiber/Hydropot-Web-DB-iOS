//
//  Notification.swift
//  HydroPot
//
//  Created by Eric  Lisle on 2/1/21.
//

import Foundation

struct codeNotification: Codable {

    let type: String
    let timeStamp: String
    
    enum CodingKeys: String, CodingKey {
        case type, timeStamp
    }
}
class Notification: ObservableObject, Identifiable {
    @Published var type: String
    @Published var timeStamp: String
    
    init(type: String, timeStamp: String) {
        self.type = type
        self.timeStamp = timeStamp
    }
}

    
