//
//  KDEventsViewController.swift
//  Olympics
//
//  Created by Kaushal Deo on 6/10/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import UIKit
import CoreData
import ViewPagerController

private let reuseIdentifier = "Cell"

class KDEventsViewController: UIViewController {
    
    var days = [NSDate]()
    
    @IBOutlet weak var overlay: UIView!
    
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
        
        pagerController.didChangeHeaderViewHeightHandler = { height in
            print("call didShowViewControllerHandler : \(height)")
        }
        
        for date in self.days {
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("kUnitsViewController") as! KDUnitsViewController
            controller.view.clipsToBounds = true
            let title = self.dateFormatter.stringFromDate(date)
            controller.title = title
            controller.date = date
            controller.parentController = self
            pagerController.addContent(title, viewController: controller)
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
        self.pagerController.currentContent()
        let context = NSManagedObjectContext.mainContext()
        self.showCountry()
        
        if let country = Country.country(context) {
            if let sets = country.events where sets.count > 0 {
                return
            }
            KDAPIManager.sharedInstance.updateProfile(country, { [weak self] (error) in
                if let _ = self {
                    
                }
                })
        }
        
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
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.days.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        // Configure the cell
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: CGRectGetWidth(collectionView.bounds), height: CGRectGetHeight(collectionView.bounds))
    }
    
    //    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    //        var pageWidth = Double(scrollView.frame.size.width) + 10.0
    //
    //        if let layout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
    //            pageWidth = Double(scrollView.frame.size.width + layout.minimumLineSpacing)
    //        }
    //
    //        let currentOffset = Double(scrollView.contentOffset.x)
    //        let targetOffset = Double(targetContentOffset.memory.x)
    //        var newTargetOffset : Double = 0
    //
    //        if (targetOffset > currentOffset) {
    //            newTargetOffset = ceil(currentOffset / pageWidth) * pageWidth
    //        }
    //        else {
    //            newTargetOffset = floor(currentOffset / pageWidth) * pageWidth;
    //        }
    //        if (newTargetOffset < 0) {
    //            newTargetOffset = 0
    //        }
    //
    //        targetContentOffset.memory.x = CGFloat(currentOffset)
    //        scrollView.setContentOffset(CGPoint(x:newTargetOffset, y:0), animated: true)
    //
    //        let index = Int(newTargetOffset/pageWidth)
    //        self.scrollerBar.scrollToItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0), animated: true)
    //    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
    }
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return false
     }
     
     func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
     return false
     }
     
     func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
     
     }
     */
    
    
}
