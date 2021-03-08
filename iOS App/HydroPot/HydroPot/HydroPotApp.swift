//
//  HydroPotApp.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI
import UIKit
import Combine

@main
struct HydroPotApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: UIResponder, ObservableObject, UIApplicationDelegate {

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
}

