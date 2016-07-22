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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        self.tableView.registerClass(UITableViewHeaderFooterView.classForCoder(), forHeaderFooterViewReuseIdentifier: "kHeaderView")
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 64.0
        
        self.title = self.event.discipline?.name
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:" ", style: .Plain, target: nil, action: nil)
        self.addBackButton()
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
        cell.countryLabel.text = unit.phase
        cell.nameLabel.text = unit.name
        cell.timeLabel.text = unit.day
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
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: true),NSSortDescriptor(key: "name", ascending: true)]
        //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        // fetchRequest.predicate = NSPredicate(format: "unit.event = %@", self.unit.event!)
        //fetchRequest.predicate = NSPredicate(format: "SUBQUERY(units, $unit, $unit.event = %@).@count != 0", self.event)
        if let country = Country.country(context) {
            fetchRequest.predicate = NSPredicate(format: "event = %@ AND SUBQUERY(competitors, $competitor, $competitor.team.country = %@ OR $competitor.athlete.country = %@).@count != 0", self.event,country,country)
        }
        //
        
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
    
    
    // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
    
    //    func controllerDidChangeContent(controller: NSFetchedResultsController) {
    //        // In the simplest, most efficient, case, reload the table view.
    //        self.tableView.reloadData()
    //    }
    //
    
}
