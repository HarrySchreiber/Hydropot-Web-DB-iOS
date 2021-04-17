import SwiftUI
import UserNotifications
import AWSPinpoint

@main
struct HydroPotApp: App {
    //allows for app delegate use
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    /// initializaes the upon content view
    init() {
        //removes padding from pickers
         UITableView.appearance().tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Double.leastNonzeroMagnitude))
         UITableView.appearance().tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Double.leastNonzeroMagnitude))
    }
    
    var body: some Scene {
        WindowGroup {
            //login page
            Login()
        }
    }
}

/*
    app delegate class for dealing with notis
 */
class AppDelegate: UIResponder, ObservableObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var pinpoint: AWSPinpoint? //allows contact through Pinpoint

    //starting up Pinpoint on open
    internal func application( _: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Instantiate Pinpoint
        let pinpointConfiguration = AWSPinpointConfiguration
            .defaultPinpointConfiguration(launchOptions: launchOptions)
        // Set debug mode to use APNS sandbox, make sure to toggle for your production app
        pinpointConfiguration.debug = true
        pinpoint = AWSPinpoint(configuration: pinpointConfiguration)

        // Present the user with a request to authorize push notifications
        registerForPushNotifications()

        return true
    }

    /*
        registering for notifications
     */
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
                guard granted else { return }

                // Only get the notification settings if user has granted permissions
                self?.getNotificationSettings()
            }
    }

    /*
        getting settings for notifications if not already registered
     */
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }

            DispatchQueue.main.async {
                // Register with Apple Push Notification service
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    
    /*
        getting device token if registered for notifications
     */
    func application(_: UIApplication,
                    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        
        UserDefaults.standard.set(token, forKey: "deviceToken")
        
        // Register the device token with Pinpoint as the endpoint for this user
        pinpoint?.notificationManager
            .interceptDidRegisterForRemoteNotifications(withDeviceToken: deviceToken)
    }
    
    /*
        recieving remote notifications from pinpoint
     */
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        // Pass this remote notification event to pinpoint SDK to keep track of notifications produced by AWS Pinpoint campaigns.
        pinpoint?.notificationManager.interceptDidReceiveRemoteNotification(
            userInfo)

        completionHandler(.newData)
    }
    
    /*
        recieving notifications from poinpoint foreground
     */
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {
         // Handle foreground push notifications
         pinpoint?.notificationManager.interceptDidReceiveRemoteNotification(notification.request.content.userInfo)
        
         let userInfo = notification.request.content.userInfo
        
         // the payload that is attached to the push notification
         // you can customize the notification presentation options. Below code will show notification banner as well as play a sound. If you want to add a badge too, add .badge in the array.
         completionHandler([.alert,.sound])

        
      }

     /*
        recieving notifications from pinpoint background
     */
     func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void)  {
         // Handle background and closed push notifications
         pinpoint?.notificationManager.interceptDidReceiveRemoteNotification(response.notification.request.content.userInfo)
        
         completionHandler()
     }


}



