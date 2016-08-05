//
//  AppDelegate.swift
//  Olympics
//
//  Created by Kaushal Deo on 6/10/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import UIKit
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    override class func initialize() {
        super.initialize()
        
        UINavigationBar.appearance().translucent = false;
        UINavigationBar.appearance().barTintColor = UIColor(red: 57, green: 150, blue: 27)
        let image = UIImage()
        UINavigationBar.appearance().shadowImage = image
        UINavigationBar.appearance().setBackgroundImage(image, forBarMetrics:.Default)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        //UITabBar.appearance().barTintColor = UIColor(red: 14, green: 101, blue: 171)
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        
        UIBarButtonItem.appearance().setBackButtonBackgroundImage(UIImage(named: "backButton")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal, barMetrics: .Default)
        
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        // application.registerUserNotificationSettings(<#T##notificationSettings: UIUserNotificationSettings##UIUserNotificationSettings#>)
        let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        FIRApp.configure()
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        NSManagedObjectContext.mainContext().saveContext()
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
    
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        debugPrint(deviceToken)
        if let country = Country.country(NSManagedObjectContext.mainContext()) {
            if let string = country.alias {
                FIRMessaging.messaging().subscribeToTopic(string)
            }
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        debugPrint(error)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("Kaushal %@", userInfo)
    }
    
    
    // [START receive_message]
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                     fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        
        // Print message ID.
        print("Message ID: \(userInfo["gcm.message_id"]!)")
        
        // TODO: Handle data of notification
        if let identifier = userInfo["competitor_id"] as? String {
            //TODO: Process the identifier for team page
            print(identifier)
            
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            completionHandler(.NewData)
            application.applicationIconBadgeNumber = 0
        }
    }
    // [END receive_message]
    
    
    
}

