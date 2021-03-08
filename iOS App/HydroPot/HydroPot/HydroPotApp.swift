//
//  HydroPotApp.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI
import UserNotifications
import AWSPinpoint

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

    var pinpoint: AWSPinpoint?
    
    func application( _: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
             // Instantiate Pinpoint
             let pinpointConfiguration = AWSPinpointConfiguration
                 .defaultPinpointConfiguration(launchOptions: launchOptions)
             // Set debug mode to use APNS sandbox, make sure to toggle for your production app
             pinpointConfiguration.debug = true
             pinpoint = AWSPinpoint(configuration: pinpointConfiguration)

             // Present the user with a request to authorize push notifications
             registerForPushNotifications()
        
            AWSDDLog.sharedInstance.logLevel = .verbose
            AWSDDLog.add(AWSDDTTYLogger.sharedInstance)

             return true
         }

     // MARK: Push Notification methods

     func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            print("Permission granted: \(granted)")
            guard granted else { return }

            // Only get the notification settings if user has granted permissions
            self?.getNotificationSettings()
        }
     }

     func getNotificationSettings() {
         UNUserNotificationCenter.current().getNotificationSettings { settings in
             print("Notification settings: \(settings)")
             guard settings.authorizationStatus == .authorized else { return }

             DispatchQueue.main.async {
                 // Register with Apple Push Notification service
                 UIApplication.shared.registerForRemoteNotifications()
             }
         }
    }
    
    // MARK: Remote Notifications Lifecycle
    func application(_: UIApplication,
                    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")

        // Register the device token with Pinpoint as the endpoint for this user
        pinpoint?.notificationManager
            .interceptDidRegisterForRemoteNotifications(withDeviceToken: deviceToken)
    }

    func application(_: UIApplication,
                    didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {
         // Handle foreground push notifications
         pinpoint?.notificationManager.interceptDidReceiveRemoteNotification(notification.request.content.userInfo)

         completionHandler(.badge)
      }

     func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void)  {
         // Handle background and closed push notifications
         pinpoint?.notificationManager.interceptDidReceiveRemoteNotification(response.notification.request.content.userInfo)

         completionHandler()
     }
}
