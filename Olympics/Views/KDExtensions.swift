//
//  KDExtensions.swift
//  Olympics
//
//  Created by Kaushal Deo on 7/5/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension UIViewController {
    
    func showCountry() {
        if let country = Country.country(NSManagedObjectContext.mainContext()) {
            var image = UIImage(named: "country.png")
            if let text = country.alias?.lowercaseString {
                if let countryImage = UIImage(named: "Images/\(text).png") {
                    image = countryImage
                }
            }
            
            let button = UIButton(type: .Custom)
            button.setImage(image, forState: .Normal)
            button.addTarget(self, action: #selector(UIViewController.showCountryTapped(_:)), forControlEvents: .TouchUpInside)
            button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            // UIBarButtonItem(image: image, style: .Plain, target: self, action: #selector(UIViewController.showCountryTapped(_:)))
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        }
    }
    
    func addBackButton() {
        if self.navigationController?.viewControllers.count > 1 {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backButton")?.imageWithRenderingMode(.AlwaysTemplate), style: .Plain, target: self, action: #selector(UIViewController.backButtonTapped(_:)))
        }
    }
    
    func showCountryTapped(sender: AnyObject) {
        if let window = self.view.window {
            if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("kCountriesNavigationController") {
                window.rootViewController = viewController
            }
        }
    }
    
    func backButtonTapped(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}

extension UIImage{
    
    func roundedImage()-> UIImage {
        let imageSize = self.size
        UIGraphicsBeginImageContextWithOptions(imageSize,false,UIScreen.mainScreen().scale)
        let bounds=CGRect(origin: CGPointZero, size: imageSize)
        UIBezierPath(roundedRect: bounds, cornerRadius: imageSize.width/2.0).addClip()
        self.drawInRect(bounds)
        let finalImage=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return finalImage
    }
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
    
    
    class func backgroundColor() -> UIColor {
        return UIColor(red: 241, green: 241, blue: 241)
    }
    
    class func sepratorColor() -> UIColor {
        return UIColor(red: 200, green: 199, blue: 204)
    }
    
    class func cellBackgroundColor() -> UIColor {
        return UIColor(red: 254, green: 254, blue: 254)
    }
    
}



extension NSDate {
    func nextDate() -> NSDate? {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: self)
        components.day = components.day + 1
        return calendar.dateFromComponents(components)
    }
    
    func today() -> NSDate? {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: self)
        return calendar.dateFromComponents(components)
    }
}