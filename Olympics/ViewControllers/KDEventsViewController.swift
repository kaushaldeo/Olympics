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

class KDEventsViewController: UIViewController, KDScrollerBarDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollerBar: KDScrollerBar!
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Do any additional setup after loading the view.
        
        self.scrollerBar.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //print("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionInset = UIEdgeInsetsZero
            flowLayout.minimumLineSpacing = 10.0
            flowLayout.minimumInteritemSpacing = 0.0
            self.collectionView.setCollectionViewLayout(flowLayout, animated: true)
        }
        self.collectionView.layoutIfNeeded()
        self.collectionView.reloadData()
        
        self.scrollerBar.reloadData()
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
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
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
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        var pageWidth = Double(scrollView.frame.size.width) + 10.0
        
        if let layout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            pageWidth = Double(scrollView.frame.size.width + layout.minimumLineSpacing)
        }
        
        let currentOffset = Double(scrollView.contentOffset.x)
        let targetOffset = Double(targetContentOffset.memory.x)
        var newTargetOffset : Double = 0
        
        if (targetOffset > currentOffset) {
            newTargetOffset = ceil(currentOffset / pageWidth) * pageWidth
        }
        else {
            newTargetOffset = floor(currentOffset / pageWidth) * pageWidth;
        }
        if (newTargetOffset < 0) {
            newTargetOffset = 0
        }
        
        targetContentOffset.memory.x = CGFloat(currentOffset)
        scrollView.setContentOffset(CGPoint(x:newTargetOffset, y:0), animated: true)
        
        let index = Int(newTargetOffset/pageWidth)
        self.scrollerBar.scrollToItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0), animated: true)
    }
    
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
    
    //MARK: - ScrollerBar delegate Methods
    func scrollerBar(scrollerBar: KDScrollerBar, numberOfItemsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func scrollerBar(scrollerBar: KDScrollerBar, titleForItemAtIndexPath indexPath: NSIndexPath) -> String? {
        let unit = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Discipline
        return unit.name
    }
    
    func scrollerBar(scrollerBar: KDScrollerBar, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let unit = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Discipline
            print(unit.name)
        
        self.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: true)
    }
    
    func scrollerBar(scrollerBar: KDScrollerBar, scrollToOffset point: CGPoint) {
        self.collectionView.setContentOffset(point, animated: true)
    }
    
    
    // MARK: - Fetched results controller
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let context = NSManagedObjectContext.mainContext()
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("Discipline", inManagedObjectContext: context)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        var fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext:context, sectionNameKeyPath:nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //print("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
        
        return fetchedResultsController
    }()
    
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        // In the simplest, most efficient, case, reload the table view.
        self.scrollerBar.reloadData()
    }
    
}
