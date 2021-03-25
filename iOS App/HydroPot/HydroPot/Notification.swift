//
//  Notification.swift
//  HydroPot
//
//  Created by Eric  Lisle on 2/1/21.
//

import Foundation

/*
    codable struct for notifications used to recieve json data
 */
struct CodeNotifications: Codable {

    let type: String //type of notification
    let timeStamp: String //when notification occured
    
    //required for codable
    enum CodingKeys: String, CodingKey {
        case type, timeStamp
    }
}

/*
    class to hold notification objects
 */
class Notification: ObservableObject, Identifiable {
    @Published var type: String //type of notification
    @Published var timeStamp: Date //when notification occured
    
    /// constructor for notifications
    ///
    /// - Parameters:
    ///     - type: What type of notification is it
    ///     - timeStamp: When the notification occured
    init(type: String, timeStamp: Date) {
        self.type = type
        self.timeStamp = timeStamp
    }
}

/*
    struct for notis and pot
 */
struct NotificationPots: Identifiable {
    var id: Int //id to conform to identifiable
    var notiesTuple : (pot: Pot, notification: Notification) //tuple for data
}
