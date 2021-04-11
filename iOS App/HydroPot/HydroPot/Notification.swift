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
    let read: Bool //if the notification has been read
    let timeStamp: String //when notification occured
    
    //required for codable
    enum CodingKeys: String, CodingKey {
        case type, read, timeStamp
    }
}

/*
    class to hold notification objects
 */
class Notification: ObservableObject, Identifiable {
    @Published var type: String //type of notification
    @Published var read: Bool // if the noti has been read
    @Published var timeStamp: Date //when notification occured
    
    /// constructor for notifications
    ///
    /// - Parameters:
    ///     - type: What type of notification is it
    ///     - read: If the notification has been read
    ///     - timeStamp: When the notification occured
    init(type: String, read: Bool, timeStamp: Date) {
        self.type = type
        self.read = read
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
