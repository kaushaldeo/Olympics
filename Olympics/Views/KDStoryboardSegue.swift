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
           window.rootViewController = self.destinationViewController
        }
    }

}
