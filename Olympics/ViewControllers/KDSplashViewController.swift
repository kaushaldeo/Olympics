//
//  KDSplashViewController.swift
//  Olympics
//
//  Created by Kaushal Deo on 7/5/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class KDSplashViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if NSUserDefaults.loadSchedule() == false {
            KDAPIManager.sharedInstance.updateSchedule()
        }
        print(kFIREventSelectContent);
        
        FIRAnalytics.logEventWithName(kFIREventSelectContent, parameters: [
            kFIRParameterContentType:"cont",
            kFIRParameterItemID:"1"
            ])
        
        self.imageView.image = UIImage(named: "logo")
        let image = UIImage(named: "splash")
        self.backgroundView.image = image?.resizableImageWithCapInsets(UIEdgeInsets(top: 148.0, left: 148.0, bottom: 148.0, right: 148.0))
        
        
        self.imageView.transform = CGAffineTransformMakeScale(0.0, 0.0)
        UIView.animateWithDuration(3.0, delay: 0.0, options: [.CurveLinear], animations: { () -> Void in
            self.imageView.transform = CGAffineTransformIdentity
        }) { (animationCompleted: Bool) -> Void in
        }
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = M_PI*2.0*0.3
        
        rotationAnimation.duration = 0.3
        
        rotationAnimation.cumulative = true
        rotationAnimation.repeatCount = Float.infinity
        
        self.imageView.layer.addAnimation(rotationAnimation, forKey: "rotationAnimation")
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if let _ = Country.country(NSManagedObjectContext.mainContext()) {
            self.performSegueWithIdentifier("showEvent", sender: nil)
        }
        else {
            self.performSegueWithIdentifier("showCountry", sender: nil)
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
