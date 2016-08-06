//
//  KDManagedObjectContext.swift
//  Olympics
//
//  Created by Kaushal Deo on 6/15/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import Foundation
import CoreData

class KDManagedObjectContext {
    
}

extension NSManagedObjectContext {
    
    class func mainContext() -> NSManagedObjectContext {
        return KDAPIManager.sharedInstance.managedObjectContext
    }
    
    // MARK: - Core Data Saving support
    func saveContext () {
        if self.hasChanges {
            self.performBlockAndWait({ 
                do {
                    try self.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            })
        }
    }
    
    
    func entityDescription(entity: AnyClass) -> NSEntityDescription? {
        if let entityDescription = NSEntityDescription.entityForName(entity.className, inManagedObjectContext: self) {
            return entityDescription
        }
        return nil
    }
    
    
    
    func create(entityDescription: NSEntityDescription) -> AnyObject? {
        if let entityName = entityDescription.name {
            return NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: self)
        }
        
        return nil
    }
    
    func createFetchRequest(entity: AnyClass, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, limit: Int? = nil, offset: Int? = nil) -> NSFetchRequest {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = self.entityDescription(entity)!
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.fetchLimit = limit ?? 0
        fetchRequest.fetchOffset = offset ?? 0
        
        return fetchRequest
    }
    
    func find(entity: AnyClass, predicate:NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, limit: Int? = nil, offset: Int? = nil) -> [AnyObject]? {
        let fetchRequest = createFetchRequest(entity, predicate: predicate, sortDescriptors: sortDescriptors, limit: limit, offset: offset)
        
        do {
            let objects = try self.executeFetchRequest(fetchRequest)
            return objects
        }
        catch {
            return nil
        }
    }
    
    func findFirst(entity: AnyClass, predicate:NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, offset: Int? = nil) -> AnyObject? {
        let objects = find(entity, predicate: predicate, sortDescriptors: sortDescriptors, limit: 1, offset: offset)
        return objects?.first
    }
    
    func findOrCreate(entity: AnyClass, predicate:NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, offset: Int? = nil) -> AnyObject? {
        if  let object = findFirst(entity, predicate: predicate, sortDescriptors: sortDescriptors, offset: offset) {
            return object
        }
        return self.create(self.entityDescription(entity)!)
    }
    
    func createObject(entity: AnyClass) -> AnyObject? {
        return self.create(self.entityDescription(entity)!)
    }
}


extension NSFetchedResultsController {
    
    func update() {
        
        if let cache = self.cacheName {
            NSFetchedResultsController .deleteCacheWithName(cache)
        }
        
        do {
            try self.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            debugPrint("Unresolved error \(nserror), \(nserror.userInfo)")
            //abort()
        }
    }
    
    var count : Int {
        if let objects = self.fetchedObjects {
            return objects.count
        }
        return 0
    }
    
}


extension NSPersistentStoreCoordinator {
    func addStore() {
        let url = KDAPIManager.applicationDocumentsDirectory().URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        do {
            let option = [NSMigratePersistentStoresAutomaticallyOption:true,
                          NSInferMappingModelAutomaticallyOption:true]
            
            try self.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: option)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = "There was an error creating or loading the application's saved data."
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            //abort()
        }

    }
}

extension NSManagedObject {
    var nameOfClass : String {
        return NSStringFromClass(self.dynamicType)
    }
    
    static var className : String {
        return String(self)
    }
}


extension NSUserDefaults {
    class func loadCountry() -> Bool {
        let setting = NSUserDefaults.standardUserDefaults()
        return setting.boolForKey("kLoadCountry")
    }
    
    class func country(loaded:Bool) {
        let setting = NSUserDefaults.standardUserDefaults()
        setting.setBool(loaded, forKey: "kLoadCountry")
    }
    
    class func loadSchedule() -> Bool {
        let setting = NSUserDefaults.standardUserDefaults()
        return setting.boolForKey("kLoadSchedule")
    }
    
    class func schedule(loaded:Bool) {
        let setting = NSUserDefaults.standardUserDefaults()
        setting.setBool(loaded, forKey: "kLoadSchedule")
    }
    
    class func checkSum() -> String {
        let setting = NSUserDefaults.standardUserDefaults()
        if let text = setting.valueForKey("kChecksum") as? String {
            return text
        }
        return "0"
    }
    
    class func checkSum(sum:String) {
        let setting = NSUserDefaults.standardUserDefaults()
        setting.setObject(sum, forKey: "kChecksum")
    }
    
    class func isUpdate(version: String) -> Bool {
        let setting = NSUserDefaults.standardUserDefaults()
        if let text = setting.valueForKey("kUpdateVersion") as? String {
            return text != version
        }
        setting.setObject(version, forKey: "kUpdateVersion")
        return true
    }
    
}