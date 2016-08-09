//
//  KDCountriesViewController.swift
//  Olympics
//
//  Created by Kaushal Deo on 6/10/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import UIKit
import CoreData
import Firebase


class KDCountriesViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    lazy var searchController: UISearchController = {
        var searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.tintColor = UIColor.whiteColor()
        searchController.searchBar.delegate = self    // so we can monitor text changes + others
        
        /*
         Search is now just presenting a view controller. As such, normal view controller
         presentation semantics apply. Namely that presentation will walk up the view controller
         hierarchy until it finds the root view controller or one that defines a presentation context.
         */
        return searchController
    }()
    
    var leftBarItem : UIBarButtonItem? = nil
    var rigthBarItem : UIBarButtonItem? = nil
    
    //MARK: - Private Methods
    
    func cancelTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("replace", sender: nil)
    }
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 103, blue: 173)
        self.searchController.searchBar.barTintColor = UIColor(red: 0, green: 103, blue: 173)
        
        let setting = NSUserDefaults.standardUserDefaults()
        if let _ = setting.valueForKey("kCountry") {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(KDCountriesViewController.cancelTapped(_:)))
        }
        
        self.tableView.reloadSections(NSIndexSet(indexesInRange: NSMakeRange(0, self.tableView.numberOfSections)), withRowAnimation: .None)
        
        self.navigationItem.titleView = self.searchController.searchBar
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style: .Plain, target: nil, action: nil)
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
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! KDCountryViewCell
        
        // Configure the cell...
        let country = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Country
        cell.nameLabel.text = country.name
        cell.aliasLabel.text = country.alias
        if let text = country.alias?.lowercaseString {
            cell.iconView.image = UIImage(named: "Images/\(text).png")
        }
        
        return cell
    }
    
    
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return self.fetchedResultsController.sectionIndexTitles
    }
    
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return self.fetchedResultsController.sectionForSectionIndexTitle(title, atIndex: index)
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let country = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Country
        let setting = NSUserDefaults.standardUserDefaults()
        let url = country.objectID.URIRepresentation().absoluteString
        setting.setValue(url, forKey: "kCountry");
        if let string = country.alias {
            FIRMessaging.messaging().subscribeToTopic(string)
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
    
    // MARK: - Fetched results controller
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let context = NSManagedObjectContext.mainContext()
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("Country", inManagedObjectContext: context)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true), NSSortDescriptor(key: "alias", ascending: true)]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        var fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext:context, sectionNameKeyPath: "name", cacheName: nil)
        fetchedResultsController.delegate = self
        
        fetchedResultsController.update()
        
        return fetchedResultsController
    }()
    
    /*
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
     */
    
    
    // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        // In the simplest, most efficient, case, reload the table view.
        self.tableView.reloadData()
    }
    
    
    
    
    // MARK: UISearchBarDelegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: UISearchResultsUpdating
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        // Strip out all the leading and trailing spaces.
        let whitespaceCharacterSet = NSCharacterSet.whitespaceCharacterSet()
        let strippedString = searchController.searchBar.text!.stringByTrimmingCharactersInSet(whitespaceCharacterSet)
        
        if strippedString.characters.count > 0 {
            let predicate = NSPredicate(format: "name contains[cd] %@ OR alias contains[cd] %@", strippedString,strippedString)
            self.fetchedResultsController.fetchRequest.predicate = predicate
        }
        else {
            self.fetchedResultsController.fetchRequest.predicate = nil
        }
        self.fetchedResultsController.update()
        self.tableView.reloadData()

    }

    func willPresentSearchController(searchController: UISearchController) {
        self.leftBarItem = self.navigationItem.leftBarButtonItem
        self.rigthBarItem = self.navigationItem.rightBarButtonItem
        self.navigationItem.setLeftBarButtonItem(nil, animated: true)
        self.navigationItem.setRightBarButtonItem(nil, animated: true)
    }
    
//    @available(iOS 8.0, *)
//    optional public func didPresentSearchController(searchController: UISearchController)
//    @available(iOS 8.0, *)
    func willDismissSearchController(searchController: UISearchController) {
        self.navigationItem.setLeftBarButtonItem(self.leftBarItem, animated: true)
        self.navigationItem.setRightBarButtonItem(self.rigthBarItem, animated: true)
        
    }
    
    
}
