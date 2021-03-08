//
//  HydroPotApp.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.

import SwiftUI
<<<<<<< HEAD
import UIKit
import Combine
=======
import UserNotifications

<<<<<<< HEAD
>>>>>>> parent of 473cbe7... udpates on pinpoint
=======
>>>>>>> parent of 473cbe7... udpates on pinpoint

@main
struct HydroPotApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

<<<<<<< HEAD
class AppDelegate: UIResponder, ObservableObject, UIApplicationDelegate {

<<<<<<< HEAD
    static let shared = AppDelegate()
    private override init() { super.init() }

    @Published var deviceToken: String = ""
    @Published var pushNotification: String = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UIApplication.shared.registerForRemoteNotifications()

        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let newToken = tokenParts.joined()

        self.deviceToken = newToken
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Did Fail to Register for Notification")
        self.deviceToken = ""
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        do {
            let data = try JSONSerialization.data(withJSONObject: userInfo, options: .prettyPrinted)
            pushNotification = String(data: data, encoding: .utf8) ?? "Empty Data"
        } catch {
            print("Failed to parse notification with error: \(error.localizedDescription)")
        }

        completionHandler(.noData)
    }
=======
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
=======
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


>>>>>>> parent of 473cbe7... udpates on pinpoint
    }

    
<<<<<<< HEAD
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
    
   

>>>>>>> parent of 473cbe7... udpates on pinpoint
=======
   

>>>>>>> parent of 473cbe7... udpates on pinpoint
}

