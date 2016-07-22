//
//  KDStoryboardSegue.swift
//  Olympics
//
//  Created by Kaushal Deo on 6/27/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import UIKit

class KDStoryboardSegue: UIStoryboardSegue {
    
    override func perform() {
        if let window = self.sourceViewController.view.window {
            
            
            let snapShot = window.snapshotViewAfterScreenUpdates(true)
            self.destinationViewController.view.addSubview(snapShot)
            window.rootViewController = self.destinationViewController
            
            UIView.animateWithDuration(0.5, animations: { 
                snapShot.layer.opacity = 0
                snapShot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
                }, completion: { (finished) in
                    snapShot.removeFromSuperview()
            })
            
            
           
        }
    }

}
