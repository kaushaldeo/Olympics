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
    @IBOutlet weak var progressLabel: UILabel!
    
    
    //MARK: - Private Methods
    func loadData() {
        KDAPIManager.sharedInstance.loadConfiguration({ [weak self] (error) in
            if let strongSelf = self {
                if let nserror = error {
                    strongSelf.process(nserror)
                    return
                }
                strongSelf.showView()
            }
            })
        
    }
    
    func startAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = M_PI*2.0*0.3
        
        rotationAnimation.duration = 0.3
        
        rotationAnimation.cumulative = true
        rotationAnimation.repeatCount = Float.infinity
        
        self.imageView.layer.addAnimation(rotationAnimation, forKey: "rotationAnimation")
        
        self.progressLabel.text = "InitialLoading".localized("Show the message while loading..")
    }
    
    
    func showView() {
        if let country = Country.country(NSManagedObjectContext.mainContext()) {
            if let string = country.alias {
                FIRMessaging.messaging().subscribeToTopic(string)
            }
            self.performSegueWithIdentifier("showHome", sender: nil)
        }
        else {
            self.performSegueWithIdentifier("showCountry", sender: nil)
        }
        
         KDUpdate.sharedInstance.update()
        
    }
    
    func process(error:NSError) {
        
        self.imageView.layer.removeAllAnimations()
        var message = "ConnectionError".localized("")
        if (error.code == NSURLErrorNotConnectedToInternet) {
            message = "InternetError".localized("")
        }
        
        let alertController = UIAlertController(title: "ErrorTitle".localized(""), message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Retry", style: .Destructive, handler: { [weak self] (action) in
            if let strongSelf = self {
                strongSelf.loadData()
                strongSelf.startAnimation()
            }
            }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        FIRAnalytics.logEventWithName(kFIREventSelectContent, parameters: [
            kFIRParameterContentType:"cont",
            kFIRParameterItemID:"1"
            ])
        
        self.imageView.image = UIImage(named: "logo")
        let image = UIImage(named: "splash")
        self.backgroundView.image = image?.resizableImageWithCapInsets(UIEdgeInsets(top: 148.0, left: 148.0, bottom: 148.0, right: 148.0))
        self.progressLabel.hidden = true
        self.startAnimation()
        self.imageView.transform = CGAffineTransformMakeScale(0.0, 0.0)
        UIView.animateWithDuration(3.0, delay: 0.0, options: [.CurveLinear], animations: { () -> Void in
            self.imageView.transform = CGAffineTransformIdentity
        }) { (animationCompleted: Bool) -> Void in
            self.progressLabel.hidden = false
            self.loadData()
            self.showView()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
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
