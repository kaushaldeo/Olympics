//
//  KDAPIManager.swift
//  Olympics
//
//  Created by Kaushal Deo on 6/15/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import Foundation
import CoreData
import AFNetworking

private let url = "https://api.sportradar.us/oly-testing2"
private let key = "5hkjft4mvnbzc26875u6c2zv"

class KDAPIManager : NSObject {
    
    static let sharedInstance: KDAPIManager = {
        return KDAPIManager()
    }()
    
    private lazy var operationQueue: NSOperationQueue = {
        var operationQueue = NSOperationQueue()
        return operationQueue
    }()
    
    private lazy var sessionManager: AFHTTPSessionManager = {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        var sessionManager = AFHTTPSessionManager(baseURL: NSURL(string:url), sessionConfiguration: configuration)
        sessionManager.responseSerializer = AFXMLParserResponseSerializer()
        return sessionManager
    }()
    
    
    // MARK: - Core Data stack
    private lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.kaushal.Olympics" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Olympics", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KDAPIManager.mergeChanges(_:)), name: NSManagedObjectContextDidSaveNotification, object: nil)
        
        return managedObjectContext
    }()
    
    //MARK: - Notification
    // merge changes to main context,fetchedRequestController will automatically monitor the changes and update tableview.
    func updateMainContext(notification: NSNotification) {
        self.managedObjectContext.mergeChangesFromContextDidSaveNotification(notification)
    }
    
    // this is called via observing "NSManagedObjectContextDidSaveNotification" from our APLEarthQuakeSource
    func mergeChanges(notification: NSNotification) {
        if let context = notification.object as? NSManagedObjectContext where context != self.managedObjectContext {
            self.performSelectorOnMainThread(#selector(KDAPIManager.updateMainContext(_:)), withObject: notification, waitUntilDone: false)
        }
    }
    
    
    
    //MARK: - Web-Service Methods
    
    func updateCountry() {
        self.sessionManager.GET("organization/list.xml", parameters: ["api_key":key], progress: { (progress) in
            print(progress)
            }, success: { (task, response) in
                if let parser = response as? NSXMLParser {
                    let operation = KDCountryParser(parser: parser)
                    self.operationQueue.addOperation(operation)
                }
            }, failure: { (task, error) in
                print(error)
                
        })
    }
    
    func updateSchedule() {
        self.sessionManager.GET("2016/schedule.xml", parameters: ["api_key":key], progress: { (progress) in
            print(progress)
            }, success: { (task, response) in
                if let parser = response as? NSXMLParser {
                    let operation = KDScheduleParser(parser: parser)
                    self.operationQueue.addOperation(operation)
                }
            }, failure: { (task, error) in
                print(error)
                
        })
        
    }
    
    
    func updateProfile(country:Country) {
        guard let identifier = country.identifier else {
            return
        }
        self.sessionManager.GET("organization/2016/\(identifier)/profile.xml", parameters: ["api_key":key], progress: { (progress) in
            print(progress)
            }, success: { (task, response) in
                if let parser = response as? NSXMLParser {
                    let operation = KDProfileParser(parser: parser)
                    self.operationQueue.addOperation(operation)
                }
            }, failure: { (task, error) in
                print(error)
                
        })
        
    }
}