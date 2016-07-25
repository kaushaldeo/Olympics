//
//  KDTabBarViewController.swift
//  Olympics
//
//  Created by Kaushal Deo on 7/17/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import UIKit

class KDTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        var index = 0
        
        let colors = [UIColor(red: 0, green: 160, blue: 25),UIColor(red: 0, green: 145, blue: 202),UIColor(red: 240, green: 91, blue: 34)]
        for color in colors {
            let layer = CALayer()
            layer.name = "\(100 + index)"
            index += 1
            
            layer.backgroundColor = color.CGColor
            
            self.tabBar.layer.insertSublayer(layer, atIndex: 0)
        }
        
        
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.whiteColor()], forState: .Normal)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let size = self.tabBar.bounds.size
        if let controllers = self.viewControllers as? [UINavigationController] {
            let count = CGFloat(controllers.count)
            if let layers = self.tabBar.layer.sublayers {
                for layer in layers {
                    if let text = layer.name {
                        let index : CGFloat = CGFloat(Int(text)! - 100)
                        layer.frame = CGRect(x: (size.width*index)/count, y: 0, width: size.width/count, height: size.height)
                    }
                }
            }
        }
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
