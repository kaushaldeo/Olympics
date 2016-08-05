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




class KDAPIManager : NSObject {
    
    private var url = "https://api.sportradar.us/oly-p2"
    
    private var key = "fkapg97hrh2qtx7hb2uvwpka"
    
    
    
   override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KDAPIManager.updateBackground(_:)), name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    static let sharedInstance: KDAPIManager = {
        return KDAPIManager()
    }()
    
    private lazy var operationQueue: NSOperationQueue = {
        var operationQueue = NSOperationQueue()
        return operationQueue
    }()
    
    private lazy var sessionManager: AFHTTPSessionManager = {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        var sessionManager = AFHTTPSessionManager(baseURL: NSURL(string:self.url), sessionConfiguration: configuration)
        sessionManager.responseSerializer = AFXMLParserResponseSerializer()
        sessionManager.completionQueue = dispatch_queue_create("com.kaushal.process", DISPATCH_QUEUE_CONCURRENT)
        return sessionManager
    }()
    
    func newSession() -> AFHTTPSessionManager {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let sessionManager = AFHTTPSessionManager(baseURL: NSURL(string:self.url), sessionConfiguration: configuration)
        sessionManager.responseSerializer = AFXMLParserResponseSerializer()
        sessionManager.completionQueue = dispatch_queue_create("com.kaushal.process", DISPATCH_QUEUE_CONCURRENT)
        return sessionManager
    }
    
    
    // MARK: - Core Data stack
    static func applicationDocumentsDirectory() -> NSURL {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.kaushal.Olympics" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Olympics", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = KDAPIManager.applicationDocumentsDirectory().URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            let option = [NSMigratePersistentStoresAutomaticallyOption:true,
                          NSInferMappingModelAutomaticallyOption:true]
            
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: option)
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
            //abort()
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
  
    func updateBackground(notification: NSNotification) {
        self.loadConfiguration(nil)
    }
    
    func loadConfiguration(block:((NSError?) -> Void)?) {
        let manager = AFHTTPSessionManager()
        manager.GET("http://olympics.mybluemix.net/config/getAppVersion", parameters: nil, progress:nil, success: { (task, response) in
                if let responseObject = response as? [String:String] {
                    self.url = responseObject["baseURL"]!
                    self.key = responseObject["apiKey"]!
                    self.sessionManager = self.newSession()
                    KDUpdate.sharedInstance.configuration(responseObject)
                    self.loadData(block)
                    
                }
            }, failure: { (task, error) in
                //Load the data regardless of error while getting config data
                self.loadData(block)
        })
        KDAPIManager.sharedInstance.managedObjectContext.saveContext()
    }
    
    
    func loadData(block:((NSError?) -> Void)?) {
        let serviceGroup = dispatch_group_create()
        
        var nserror : NSError? = nil
        if NSUserDefaults.loadSchedule() == false || KDUpdate.sharedInstance.shouldSave {
            dispatch_group_enter(serviceGroup)
            self.updateSchedule({[weak self] in
                if let strongSelf = self {
                    if NSUserDefaults.loadCountry() == false || KDUpdate.sharedInstance.shouldSave {
                        dispatch_group_enter(serviceGroup)
                        strongSelf.updateCountry({ (error) in
                            if let err = error {
                                nserror = err
                            }
                            else {
                                NSUserDefaults.country(true)
                            }
                            dispatch_group_leave(serviceGroup)
                        })
                        dispatch_group_leave(serviceGroup)
                    }
                }
                }, block: { (error) in
                    if let err = error {
                        nserror = err
                    }
                    else {
                        NSUserDefaults.schedule(true)
                    }
            })
        }
        else if NSUserDefaults.loadCountry() == false {
            dispatch_group_enter(serviceGroup);
            self.updateCountry({ (error) in
                if let err = error {
                    nserror = err
                }
                else {
                    NSUserDefaults.country(true)
                }
                dispatch_group_leave(serviceGroup)
            })
        }
        else {
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                if let completionBlock = block {
                    completionBlock(nserror)
                }
            }
            return
        }
        
        dispatch_group_notify(serviceGroup,dispatch_get_main_queue(),{
            if let completionBlock = block {
                completionBlock(nserror)
            }
        })
    }
    
    func updateCountry(block:((NSError?) -> Void)?) {
        self.sessionManager.GET("organization/list.xml", parameters: ["api_key":key], progress:nil, success: { (task, response) in
                if let parser = response as? NSXMLParser {
                    let operation = KDCountryParser(parser: parser)
                    operation.completionBlock = {
                        self.dispatchOnMain(block, nil)
                    }
                    self.operationQueue.addOperation(operation)
                }
            }, failure: { (task, error) in
                self.dispatchOnMain(block, error)
                
        })
    }
    
    func updateSchedule(process:(() -> Void)?, block:((NSError?) -> Void)?) {
        self.sessionManager.GET("2016/schedule.xml", parameters: ["api_key":key], progress:nil, success: { (task, response) in
                if let block = process {
                    block()
                }
                if let parser = response as? NSXMLParser {
                    let operation = KDScheduleParser(parser: parser)
                    operation.completionBlock = {
                        self.dispatchOnMain(block, nil)
                    }
                    self.operationQueue.addOperation(operation)
                }
            }, failure: { (task, error) in
                self.dispatchOnMain(block, error)
                
        })
    }
    
    func dispatchOnMain(block:((NSError?) -> Void)?, _ error: NSError?) {
        dispatch_async(dispatch_get_main_queue()) {
            if let completionBlock = block {
                completionBlock(error)
            }
        }
    }
    
    func updateProfile(country:Country, _ block:((NSError?) -> Void)?) {
        guard let identifier = country.identifier else {
            return
        }
        self.sessionManager.GET("organization/2016/\(identifier)/profile.xml", parameters: ["api_key":key], progress:nil, success: { (task, response) in
                if let parser = response as? NSXMLParser {
                    let operation = KDProfileParser(parser: parser)
                    operation.completionBlock = {
                        self.dispatchOnMain(block, nil)
                    }
                    self.operationQueue.addOperation(operation)
                }
            }, failure: { (task, error) in
                self.dispatchOnMain(block, error)
        })
        
    }
    
    func updateMedals(block:((NSError?) -> Void)?) {
        self.sessionManager.GET("2016/medals.xml", parameters: ["api_key":key], progress:nil, success: { (task, response) in
                if let parser = response as? NSXMLParser {
                    let operation = KDMedalParser(parser: parser)
                    operation.completionBlock = {
                        self.dispatchOnMain(block, nil)
                    }
                    self.operationQueue.addOperation(operation)
                }
            }, failure: { (task, error) in
                self.dispatchOnMain(block, error)
                
        })
    }
    
    func update(event:Event, _ block:((NSError?) -> Void)?) {
        guard let identifier = event.identifier else {
            return
        }
        self.sessionManager.GET("event/\(identifier)/results.xml", parameters: ["api_key":key], progress: nil, success: { (task, response) in
                if let parser = response as? NSXMLParser {
                    let operation = KDEventParser(parser: parser)
                    operation.completionBlock = {
                        self.dispatchOnMain(block, nil)
                    }
                    self.operationQueue.addOperation(operation)
                }
            }, failure: { (task, error) in
                self.dispatchOnMain(block, error)
        })
    }
}