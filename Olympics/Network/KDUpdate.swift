//
//  KDUpdate.swift
//  Olympics
//
//  Created by Kaushal Deo on 7/24/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import UIKit

class KDUpdate: NSObject {
    
    static let sharedInstance: KDUpdate = {
        return KDUpdate()
    }()
    
    func configuration(info:[String:String]) {
        self.applicationStoreVersion = info["iOS"]
        if let text = info["message"] {
            self.message = text
        }
        if let text = info["cacheCountryChecksum"] {
            self.shouldSave = self.cacheCountryChecksum.compare(text, options: .NumericSearch) != .OrderedSame
            if self.shouldSave {
                KDAPIManager.sharedInstance.updateDatabase()
                self.updateUI()
            }
            self.cacheCountryChecksum = text
            NSUserDefaults.checkSum(text)
        }
    }
    
    func update() {
        if let latestVersion = self.applicationStoreVersion {
            //Update available
            if latestVersion.compare(self.applicationVersion, options: .NumericSearch) == .OrderedDescending {
                if self.noThanksEnabled() {
                    //Check for remind me
                    if self.remindMeLaterEnabled() {
                        //Check for number of launch
                        if self.numberOfTimesLaunched() {
                            self.showMessage()
                        }
                    }
                }
            }
        }
    }
    
    func updateUI() {
        dispatch_async(dispatch_get_main_queue()) {
            if let appDelegate  = UIApplication.sharedApplication().delegate as? AppDelegate {
                guard let window = appDelegate.window else {
                    return
                }
                if let _ = window.rootViewController as? KDSplashViewController {
                    return
                }
                else {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = storyboard.instantiateInitialViewController()
                    window.rootViewController = viewController
                }
                
            }
        }
    }
    func showMessage() {
        dispatch_async(dispatch_get_main_queue()) {
            
            if let appDelegate  = UIApplication.sharedApplication().delegate as? AppDelegate {
                guard let window = appDelegate.window else {
                    return
                }
                guard let viewController = window.rootViewController else {
                    return
                }
                
                let title = "Update \(self.applicationName)"
                
                let alertController = UIAlertController(title: title, message: self.displayMessage(), preferredStyle: .Alert)
                
                alertController.addAction(UIAlertAction(title: "No, Thanks", style: .Cancel, handler: { [weak self](action) in
                    if let strongSelf = self {
                        strongSelf.noThanksPressed()
                    }
                    }))
                alertController.addAction(UIAlertAction(title: "Remind Me Later", style: .Default, handler: { [weak self] (action) in
                    if let strongSelf = self {
                        strongSelf.remindMeLater()
                    }
                    }))
                
                alertController.addAction(UIAlertAction(title: "Update Now", style: .Default, handler: { [weak self] (action) in
                    if let strongSelf = self {
                        strongSelf.processApp()
                    }
                    }))
                
                viewController.presentViewController(alertController, animated: true, completion: nil)
                
            }
        }
    }
    
    //MARK: - Private Methods
    private var numberOfLaunch = 3
    private var remindDaysGap : NSTimeInterval = 24*60*60
    private var applicationVersion : String
    private var applicationName : String
    private var applicationBundleID : String?
    private var applicationStoreVersion: String?
    private var message : String
    
    var cacheCountryChecksum : String
    
    var shouldSave = false
    
    override init() {
        let bundle = NSBundle.mainBundle()
        applicationVersion = "1.0.1"
        if let text = bundle.objectForInfoDictionaryKey("CFBundleShortVersionString") as? String {
            applicationVersion = text
        }
        applicationName = "Olympics"
        
        if let text = bundle.objectForInfoDictionaryKey("CFBundleDisplayName") as? String {
            applicationName = text
        }
        
        applicationBundleID = bundle.bundleIdentifier
        
        message = "Would you like to update it now?"
        
        cacheCountryChecksum = NSUserDefaults.checkSum()
        
        if NSUserDefaults.isUpdate(applicationVersion) {
            cacheCountryChecksum = "1000"
        }
        
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KDUpdate.update), name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private func numberOfTimesLaunched() -> Bool {
        let setting = NSUserDefaults.standardUserDefaults()
        var launch = setting.integerForKey("kNumberOfLaunch")
        launch += 1
        setting.setInteger(launch == 3 ? 0 : launch, forKey: "kNumberOfLaunch")
        return launch == self.numberOfLaunch
    }
    
    private func remindMeLater()  {
        let setting = NSUserDefaults.standardUserDefaults()
        setting.setObject(NSDate(), forKey: "kRemindMe")
    }
    
    private func noThanksPressed()  {
        let setting = NSUserDefaults.standardUserDefaults()
        if let text = self.applicationStoreVersion {
            setting.setObject(text, forKey: "kNoThanks")
        }
    }
    
    private func noThanksEnabled() -> Bool {
        let setting = NSUserDefaults.standardUserDefaults()
        if let version = setting.valueForKey("kNoThanks") as? String {
            if let latestVersion = self.applicationStoreVersion {
                return latestVersion.compare(version, options: .NumericSearch) == .OrderedDescending
            }
        }
        return true
    }
    
    
    private func remindMeLaterEnabled() -> Bool {
        let setting = NSUserDefaults.standardUserDefaults()
        if let date = setting.valueForKey("kRemindMe") as? NSDate {
            let today = NSDate()
            return date.dateByAddingTimeInterval(self.remindDaysGap).compare(today) == .OrderedAscending
        }
        return true
    }
    
    private func displayMessage() -> String {
        var string = "An update for \(self.applicationName) is available.\n\n"
        string += self.message
        return string
    }
    
    private func processApp() {
        let url = NSURL(string:"itms-apps://itunes.apple.com/app/id1135313762")!
        if UIApplication.sharedApplication().canOpenURL(url) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
}
