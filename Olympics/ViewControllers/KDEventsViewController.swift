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
    
    @IBOutlet weak var headerView: UIView!
    
    //MARK: - Private functions
    func calulateDate() {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: NSDate())
        for index in 0...7  {
            components.day = components.day + index
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
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Do any additional setup after loading the view.
        self.headerView.backgroundColor = self.navigationController?.navigationBar.barTintColor
        
        let context = NSManagedObjectContext.mainContext()
        self.calulateDate()
        self.showCountry()
        
        if let country = Country.country(context) {
            if let sets = country.events where sets.count > 0 {
                return
            }
            KDAPIManager.sharedInstance.updateProfile(country)
        }
        
        
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
