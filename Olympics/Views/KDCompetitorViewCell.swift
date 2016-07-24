//
//  KDCompetitorViewCell.swift
//  Olympics
//
//  Created by Kaushal Deo on 7/20/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import UIKit
import CoreData

class KDCompetitorViewCell: UITableViewCell, NSFetchedResultsControllerDelegate {
    
    
    @IBOutlet weak var heightLayout: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPoint(x: 16, y: CGRectGetMinY(self.tableView.frame)))
        bezierPath.addLineToPoint(CGPoint(x: CGRectGetWidth(rect), y: CGRectGetMinY(self.tableView.frame)))
        bezierPath.lineWidth = 0.25
        UIColor.sepratorColor().setStroke()
        bezierPath.strokeWithBlendMode(.Exclusion, alpha: 1.0)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //        self.tableView.rowHeight = UITableViewAutomaticDimension
        //        self.tableView.estimatedRowHeight = 41
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.heightLayout.constant = CGFloat(self.fetchedResultsController.count*44)
    }
    
    //MARK: - Table View Delegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! KDResultViewCell
        
        // Configure the cell...
        let competitor = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Competitor
        print("name of com: \(competitor.name())")
        cell.nameLabel.text = competitor.name()
        if let text = competitor.iconName() {
            cell.iconView.image = UIImage(named: "Images/\(text).png")
        }
        cell.rankLabel.text = competitor.resultValue
        return cell
    }
    
    
    
    //MARK: - Fetched Results Controller Delegate
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let context = NSManagedObjectContext.mainContext()
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("Competitor", inManagedObjectContext: context)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sort", ascending: true)]
        
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        var fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext:context, sectionNameKeyPath:nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
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
     //self.heightLayout.constant = CGFloat(Int(self.tableView.contentSize.height))
     }
     */
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.reloadData()
    }
    
    func setUnit(unit:Unit) {
        let country = Country.country(NSManagedObjectContext.mainContext())!
        print("\(unit.type) with phase:\(unit.phase)")
        if let text = unit.type where text.lowercaseString.rangeOfString("head") != nil {
            self.fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "unit = %@", unit)
        }
        else {
            self.fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "(team.country = %@ OR athlete.country = %@) AND unit = %@",country, country, unit)
        }
        self.fetchedResultsController.update()
        self.tableView.reloadData()
    }
}
