//
//  KDEventsViewController.swift
//  Olympics
//
//  Created by Kaushal Deo on 6/10/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"

class KDEventsViewController: UIViewController {
    
    var days = [NSDate]()
    
    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: - Private functions
    func calulateDate() {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: NSDate())
        components.day = 2
        components.month = 8
        for _ in 0...18  {
            components.day = components.day + 1
            if let date = calendar.dateFromComponents(components) {
                self.days.append(date)
            }
        }
    }
    
    func startAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = M_PI*2.0*0.3
        
        rotationAnimation.duration = 0.3
        
        rotationAnimation.cumulative = true
        rotationAnimation.repeatCount = Float.infinity
        
        self.imageView.layer.addAnimation(rotationAnimation, forKey: "rotationAnimation")
    }
    
    lazy var dateFormatter : NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter
    }()
    
    lazy var pagerController : ViewPagerController = {
        
        var pagerController = ViewPagerController()
        
        pagerController.setParentController(self, parentView: self.overlay)
        
        var appearance = ViewPagerControllerAppearance()
        
        appearance.tabMenuHeight = 44.0
        appearance.scrollViewMinPositionY = 20.0
        appearance.scrollViewObservingType = .NavigationBar(targetNavigationBar: self.navigationController!.navigationBar)
        
        appearance.tabMenuAppearance.backgroundColor = UIColor(red: 0, green: 160, blue: 25)
        appearance.tabMenuAppearance.selectedViewBackgroundColor = UIColor.whiteColor()
        appearance.tabMenuAppearance.defaultTitleColor = UIColor.lightTextColor()
        appearance.tabMenuAppearance.selectedViewInsets = UIEdgeInsets(top: 39, left: 0, bottom: 0, right: 0)
        
        pagerController.updateAppearance(appearance)
        
        pagerController.willBeginTabMenuUserScrollingHandler = { selectedView in
            selectedView.alpha = 0.0
        }
        
        pagerController.didEndTabMenuUserScrollingHandler = { selectedView in
            selectedView.alpha = 1.0
        }
        
        return pagerController
    }()
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 160, blue: 25)
        
        // Do any additional setup after loading the view.
        //self.headerView.backgroundColor = self.navigationController?.navigationBar.barTintColor
        
        self.calulateDate()
        self.showCountry()
        
        self.view.backgroundColor = UIColor.backgroundColor()
        self.imageView.image = UIImage(named: "logo")?.imageWithRenderingMode(.AlwaysTemplate)
        self.imageView.tintColor = UIColor.lightGrayColor()
        
        self.loadData()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:" ", style: .Plain, target: nil, action: nil)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    //MARK: - Database Methods
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
            }
            }))
        self.navigationController?.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showToday() {
        var index = 0
        if let date = NSDate().today() {
            if let indexOfDay = self.days.indexOf(date) {
                index = indexOfDay
            }
        }
        self.pagerController.reloadData(index)
    }
    
    func populateDate(country: Country) {
        self.imageView.layer.removeAllAnimations()
        let context = NSManagedObjectContext.mainContext()
        let sets = NSMutableSet()
        if let units = context.find(Unit.classForCoder(), predicate: NSPredicate(format:"SUBQUERY(event.countries, $country, $country = %@).@count != 0",country), sortDescriptors: [NSSortDescriptor(key: "startDate", ascending: true)]) as? [Unit] {
            for unit in units {
                if let date = unit.startDate?.today() {
                    sets.addObject(date)
                }
            }
        }
        
        //self.days = (sets.allObjects as! [NSDate]).sort({$0.compare($1) == NSComparisonResult.OrderedAscending})
        for date in self.days {
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("kUnitsViewController") as! KDUnitsViewController
            controller.view.clipsToBounds = true
            let title = self.dateFormatter.stringFromDate(date)
            controller.title = title
            controller.date = date
            controller.parentController = self
            self.pagerController.addContent(title, viewController: controller)
        }
        
    }
    
    func loadData() {
        
        let context = NSManagedObjectContext.mainContext()
        if let country = Country.country(context) {
            if KDUpdate.sharedInstance.shouldSave == false {
                if let events = country.events where events.count > 0 {
                    self.populateDate(country)
                    self.performSelector(#selector(KDEventsViewController.showToday), withObject: nil, afterDelay: 0.3)
                    return
                }
            }
            KDAPIManager.sharedInstance.updateProfile(country, { [weak self] (error) in
                if let strongSelf = self {
                    if let nserror = error {
                        strongSelf.process(nserror)
                        return
                    }
                    strongSelf.populateDate(country)
                    strongSelf.showToday()
                }
                })
            self.startAnimation()
        }
    }
}
