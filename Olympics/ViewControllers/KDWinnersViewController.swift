//
//  KDWinnersViewController.swift
//  Olympics
//
//  Created by Kaushal Deo on 8/6/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import UIKit
import CoreData

class KDWinnersViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var country : Country!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:" ", style: .Plain, target: nil, action: nil)
        self.addBackButton()
        
        self.tableView.backgroundView = nil
        self.tableView.backgroundColor = UIColor.backgroundColor()
        
        self.tableView.registerNib(UINib(nibName: "KDWinnerHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "kHeaderView")
        
        self.navigationItem.title = "Breakdown"
        
        
        KDAPIManager.sharedInstance.medal(self.country) { [weak self] (error) in
            if let strongSelf = self {
                
                var message = "ResultError".localized("")
                if let nserror = error {
                    //strongSelf.process(nserror)
                    message = ""
                }
                else {
                    //TODO: Stamp the time on refresh control
                }
                
                strongSelf.fetchedResultsController.update()
                strongSelf.tableView.reloadData()
            }
        }
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! KDWinnerViewCell
        
        // Configure the cell...
        cell.setWinner(self.fetchedResultsController.objectAtIndexPath(indexPath) as! Winner)
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
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("kHeaderView") as! KDWinnerHeaderView
        headerView.nameLabel.text = self.country.name
        headerView.goldLabel.text = "\(self.country.gold)"
        headerView.silverLabel.text = "\(self.country.silver)"
        headerView.brozeLabel.text = "\(self.country.bronze)"
        if let text = self.country.alias?.lowercaseString {
            headerView.iconView.image = UIImage(named: "Images/\(text).png")
        }
        return headerView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let text = self.country.name {
            return max(50, text.size(UIFont.systemFontOfSize(15), width:CGRectGetWidth(tableView.frame) - 221.0).height + 30)
        }
        return 50.0
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    // MARK: - Fetched results controller
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let context = NSManagedObjectContext.mainContext()
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("Winner", inManagedObjectContext: context)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "medal", ascending: true)]
        
        fetchRequest.predicate = NSPredicate(format: "team.country = %@ OR athlete.country = %@",self.country,self.country)
        

        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        var fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext:context, sectionNameKeyPath: nil, cacheName: nil)
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
