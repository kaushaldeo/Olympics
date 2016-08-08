//
//  KDRevealViewController.swift
//  Olympics
//
//  Created by Kaushal Deo on 8/6/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import UIKit
import MMDrawerController

class KDRevealViewController: MMDrawerController {
    
    lazy var centerNavigationController : UINavigationController = {
        let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("kNavigationController") as! UINavigationController
        return viewController
    }()
    
    lazy var leftViewController : KDMenuViewController = {
        let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("kMenuViewController") as! KDMenuViewController
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.centerViewController = self.centerNavigationController
        self.leftDrawerViewController = self.leftViewController
        self.showsShadow = true
        self.maximumLeftDrawerWidth = 260.0
        
        self.setDrawerVisualStateBlock { (controller, side, width) in
           // [MMDrawerVisualState slideAndScaleVisualStateBlock];
            if let block =  MMDrawerVisualState.slideAndScaleVisualStateBlock() {
                block(controller, side, width)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
