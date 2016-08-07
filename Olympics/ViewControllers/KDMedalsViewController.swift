//
//  KDMedalsViewController.swift
//  Olympics
//
//  Created by Kaushal Deo on 6/27/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import UIKit
import CoreData

class KDMedalsViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    
    lazy var country : Country = {
        var country = Country.country(NSManagedObjectContext.mainContext())!
        return country
    }()
    
    //MARK: - Private Data
    func process(error:NSError) {
        var message = "ConnectionError".localized("")
        if (error.code == NSURLErrorNotConnectedToInternet) {
            message = "InternetError".localized("")
        }
        
        let alertController = UIAlertController(title: "ErrorTitle".localized(""), message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Retry", style: .Destructive, handler: { [weak self] (action) in
            if let strongSelf = self {
                strongSelf.refreshData()
            }
            }))
        self.navigationController?.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func updateRank() {
        let serialQueue = dispatch_queue_create("com.kaushal.rank", DISPATCH_QUEUE_SERIAL)
        dispatch_sync(serialQueue) { () -> Void in
            var gold : NSNumber = 0
            var bronze : NSNumber = 0
            var silver : NSNumber = 0
            var rank = 0
            let context = NSManagedObjectContext.context()
            let sortings = [NSSortDescriptor(key: "gold", ascending: false),NSSortDescriptor(key: "silver", ascending: false),NSSortDescriptor(key: "bronze", ascending: false),NSSortDescriptor(key: "alias", ascending: true)]
            if let items = context.find(Country.classForCoder(), sortDescriptors: sortings) as? [Country] {
                var index = 1
                for item in items {
                    if (gold == item.gold && bronze == item.bronze && item.silver == silver) == false {
                        rank = index
                        gold = item.gold
                        bronze = item.bronze
                        silver = item.silver
                    }
                    index += 1
                    if item.total() > 0 {
                        item.rank = "\(rank)"
                    }
                    else {
                        item.rank = "-"
                    }
                }
            }
            context.saveContext()
            
        }
        
    }
    
    func refreshData() {
        
        KDAPIManager.sharedInstance.updateMedals({ [weak self] (error) in
            if let strongSelf = self {
                if let nserror = error {
                    strongSelf.process(nserror)
                }
                else {
                    //TODO: Stamp the time on refresh control
                }
                strongSelf.refreshControl?.endRefreshing()
                strongSelf.fetchedResultsController.update()
                strongSelf.tableView.reloadData()
                strongSelf.updateRank()
            }
            })
        
    }
    
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.registerNib(UINib(nibName: "KDMedalView", bundle: nil), forHeaderFooterViewReuseIdentifier: "kHeaderView")
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 64.0
        
        self.tableView.backgroundColor = UIColor.backgroundColor()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 145, blue: 202)
        
        self.showCountry()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        self.refreshControl?.addTarget(self, action: #selector(KDMedalsViewController.refreshData), forControlEvents: .ValueChanged)
        self.refreshData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.fetchedResultsController.update()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! KDMedalViewCell
        
        // Configure the cell...
        let country = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Country
        cell.aliasLabel.text = country.name
        cell.goldLabel.text = "\(country.gold)"
        cell.silverLabel.text = "\(country.silver)"
        cell.brozeLabel.text = "\(country.bronze)"
        cell.rankLabel.text = country.rank
        if let text = country.alias?.lowercaseString {
            cell.iconView.image = UIImage(named: "Images/\(text).png")
        }
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    //MARK: Table View Delegate Method
    
    override func  tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("kHeaderView") as! KDMedalView
        headerView.nameLabel.text = self.country.name
        headerView.goldLabel.text = "\(self.country.gold)"
        headerView.silverLabel.text = "\(self.country.silver)"
        headerView.brozeLabel.text = "\(self.country.bronze)"
        headerView.rankLabel.text = self.country.rank
        if let text = self.country.alias?.lowercaseString {
            headerView.iconView.image = UIImage(named: "Images/\(text).png")
        }
        headerView.tapHandler = { [weak self] (view) in
            if let strongSelf = self {
                if strongSelf.country.total() > 0 {
                    strongSelf.performSegueWithIdentifier("medal", sender: strongSelf.country)
                }
            }
        }
        return headerView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let text = self.country.name {
            return max(50, text.size(UIFont.systemFontOfSize(15), width:CGRectGetWidth(tableView.frame) - 221.0).height + 30)
        }
        return 50.0
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let country = sender as? Country {
            if let viewController = segue.destinationViewController as? KDWinnersViewController {
                viewController.country = country
            }
        }
    }
    
    
    // MARK: - Fetched results controller
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let context = NSManagedObjectContext.mainContext()
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("Country", inManagedObjectContext: context)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "gold", ascending: false),NSSortDescriptor(key: "silver", ascending: false),NSSortDescriptor(key: "bronze", ascending: false),NSSortDescriptor(key: "alias", ascending: true)]
        
        if let country = Country.country(context) {
            fetchRequest.predicate = NSPredicate(format: "identifier != %@",country.identifier!)
        }
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        var fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext:context, sectionNameKeyPath: nil, cacheName: "Modals")
        fetchedResultsController.delegate = self
        
        fetchedResultsController.update()
        
        return fetchedResultsController
    }()
    
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Move:
            tableView.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
    
    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
     // In the simplest, most efficient, case, reload the table view.
     self.tableView.reloadData()
     }
     */
}
