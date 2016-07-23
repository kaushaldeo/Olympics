//
//  KDCompetitorsViewController.swift
//  Olympics
//
//  Created by Kaushal Deo on 7/15/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import UIKit
import CoreData

class KDCompetitorsViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var event : Event!
    
    lazy var dateFormatter : NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM 'at' hh:mm a"
        return dateFormatter
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        self.tableView.registerNib(UINib(nibName: "KDPhaseView", bundle: nil), forHeaderFooterViewReuseIdentifier: "kHeaderView")
        self.tableView.registerNib(UINib(nibName: "KDFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "kFooterView")
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200
        
        self.title = self.event.discipline?.name
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:" ", style: .Plain, target: nil, action: nil)
        self.addBackButton()
        
        self.tableView.backgroundColor = UIColor.backgroundColor()
        self.tableView.backgroundView = nil
        
        
        KDAPIManager.sharedInstance.update(event, { [weak self] (error) in
            if let strongSelf = self {
                strongSelf.fetchedResultsController.update()
                strongSelf.tableView.reloadData()
            }
            })
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! KDCompetitorViewCell
        
        // Configure the cell...
        let unit = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Unit
        if let date = unit.startDate {
            cell.nameLabel.text = self.dateFormatter.stringFromDate(date)
        }
        else {
            cell.nameLabel.text = nil
        }
        cell.reloadBlock = {[weak self] (reloadCell) in
            if let strongSelf = self {
                if let indexPath = strongSelf.tableView.indexPathForCell(reloadCell) {
                    strongSelf.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                }
            }
        }
        cell.setUnit(unit)
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
    
    //    override func  tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("kHeaderView")
    //        let sectionInfo = self.fetchedResultsController.sections![section]
    //        headerView?.textLabel?.text = sectionInfo.name
    //        return headerView
    //    }
    
    
    //MARK: Table View Delegate Method
    
    override func  tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("kHeaderView") as! KDPhaseView
        let sectionInfo = self.fetchedResultsController.sections![section]
        headerView.titleLabel.text = sectionInfo.name
        
        return headerView
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("kFooterView") as! KDFooterView
        return headerView
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let event = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Unit
        print(event.competitors)
        
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
        let entity = NSEntityDescription.entityForName("Unit", inManagedObjectContext: context)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "phase", ascending: true), NSSortDescriptor(key: "startDate", ascending: true),NSSortDescriptor(key: "name", ascending: true)]
        //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        //fetchRequest.predicate = NSPredicate(format: "event = %@",self.event)
        //fetchRequest.predicate = NSPredicate(format: "SUBQUERY(units, $unit, $unit.event = %@).@count != 0", self.event)
        if let country = Country.country(context) {
            fetchRequest.predicate = NSPredicate(format: "event = %@ AND SUBQUERY(competitors, $competitor, $competitor.team.country = %@ OR $competitor.athlete.country = %@).@count != 0", self.event,country,country)
        }
        //
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        var fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext:context, sectionNameKeyPath:"phase", cacheName: nil)
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
        
        print(self.fetchedResultsController.fetchedObjects?.count)
    }
    
    
    // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
    
    //    func controllerDidChangeContent(controller: NSFetchedResultsController) {
    //        // In the simplest, most efficient, case, reload the table view.
    //        self.tableView.reloadData()
    //    }
    //
    
}
