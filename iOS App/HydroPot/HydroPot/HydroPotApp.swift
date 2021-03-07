//
//  HydroPotApp.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI
import UserNotifications


@main
struct HydroPotApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func registerForRemoteNotification() {
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()

            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }

        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }

    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(token)
        
        UserDefaults.standard.set(token, forKey: "deviceToken")
        UserDefaults.standard.synchronize()

        print(deviceToken.description)
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            print(uuid)
        }
        UserDefaults.standard.setValue(token, forKey: "ApplicationIdentifier")
        UserDefaults.standard.synchronize()


    }
    
   

}

