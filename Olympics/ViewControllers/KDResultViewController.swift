//
//  KDResultViewController.swift
//  Olympics
//
//  Created by Kaushal Deo on 7/24/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import UIKit
import CoreData

class KDResultViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    var event : Event!
    
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var refreshControl : UIRefreshControl = {
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(KDResultViewController.refreshData), forControlEvents: .ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        return refreshControl
    }()
    
    lazy var country : Country = {
        var country = Country.country(NSManagedObjectContext.mainContext())!
        return country
    }()
    
    
    //MARK: - Private Data
    func process(error:NSError) {
        var message = "We had a problem retrieving information.  Do you want to try again?";
        if (error.code == NSURLErrorNotConnectedToInternet) {
            message = "No Network Connection. Please try again.";
        }
        
        let alertController = UIAlertController(title: "Oops!!", message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Retry", style: .Destructive, handler: { [weak self] (action) in
            if let strongSelf = self {
                strongSelf.refreshData()
            }
            }))
        self.navigationController?.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func refreshData() {
        KDAPIManager.sharedInstance.update(self.event, { [weak self] (error) in
            if let strongSelf = self {
                
                var message = "No Competitor for selected event."
                if let nserror = error {
                    strongSelf.process(nserror)
                    message = ""
                }
                else {
                    //TODO: Stamp the time on refresh control
                }
                if let progressView = strongSelf.tableView.backgroundView as? KDErrorView {
                    progressView.stopAnimation()
                    progressView.update(message)
                }
                strongSelf.fetchedResultsController.update()
                strongSelf.tableView.reloadData()
                strongSelf.refreshControl.endRefreshing()
                
            }
            })
        
        if let progressView = self.tableView.backgroundView as? KDErrorView {
            progressView.startAnimation()
        }
    }
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.registerNib(UINib(nibName: "KDPhaseView", bundle: nil), forHeaderFooterViewReuseIdentifier: "kHeaderView")
        self.tableView.registerNib(UINib(nibName: "KDFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "kFooterView")
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        self.title = self.event.discipline?.name
        self.eventLabel.text = self.event.name
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:" ", style: .Plain, target: nil, action: nil)
        self.addBackButton()
        
        self.view.backgroundColor = UIColor.backgroundColor()
        self.tableView.backgroundView = nil
        self.tableView.backgroundColor = UIColor.backgroundColor()
        
        self.tableView.addSubview(self.refreshControl)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.reloadData()
        if self.fetchedResultsController.count == 0 {
            self.tableView.backgroundView = KDErrorView.view("Loading...")
        }
        self.refreshData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        if sectionInfo.numberOfObjects > 0 {
            self.tableView.backgroundView = nil
        }
        return sectionInfo.numberOfObjects
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Configure the cell...
        let competitor = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Competitor
        if let unit = competitor.unit, let text = unit.type where text.lowercaseString.rangeOfString("head") != nil {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! KDHeadsViewCell
            cell.set(unit, country: self.country)
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("Rank", forIndexPath: indexPath) as! KDResultViewCell
        cell.nameLabel.text = competitor.name()
        if let text = competitor.iconName() {
            cell.iconView.image = UIImage(named: "Images/\(text).png")
        }
        cell.rankLabel.text = competitor.rank ?? "-"
        cell.resultLabel.text = competitor.resultValue
        return cell
    }
    
    
    //MARK: Table View Delegate Method
    
    func  tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("kHeaderView") as! KDPhaseView
        let sectionInfo = self.fetchedResultsController.sections![section]
        headerView.titleLabel.text = sectionInfo.name
        
        return headerView
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("kFooterView") as! KDFooterView
        return headerView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //let event = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Unit
        //print(event.competitors)
        
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
        let entity = NSEntityDescription.entityForName("Competitor", inManagedObjectContext: context)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "unit.phase", ascending: true), NSSortDescriptor(key: "unit.name", ascending: true),NSSortDescriptor(key: "unit.startDate", ascending: false),NSSortDescriptor(key: "rank", ascending: true)]
        
        fetchRequest.predicate = NSPredicate(format: "unit.event = %@ AND (team.country = %@ OR athlete.country = %@)", self.event,self.country,self.country)
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        var fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext:context, sectionNameKeyPath:"unit.phase", cacheName: nil)
        fetchedResultsController.delegate = self
        
        fetchedResultsController.update()
        
        return fetchedResultsController
    }()
    
    
    // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        // In the simplest, most efficient, case, reload the table view.
        self.tableView.reloadData()
    }
    
}
