//
//  KDInfoViewController.swift
//  Olympics
//
//  Created by Kaushal Deo on 7/24/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import UIKit
import MessageUI

class KDInfoViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    lazy var items : [[String:String]] = {
        var items = [[String:String]]()
        items.append(["name":"Contact us", "image":"contactus"])
        items.append(["name":"Rate Summer Games 2016", "image":"rateus"])
        items.append(["name":"Share Summer Games 2016", "image":"share"])
        return items
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationItem.title = "Info"
        
        self.tableView.backgroundColor = UIColor.backgroundColor()
        self.tableView.backgroundView = KDInfoView(frame: CGRectZero)
        
        self.tableView.registerNib(UINib(nibName: "KDFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "kHeaderView")
        self.tableView.registerNib(UINib(nibName: "KDFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "kFooterView")
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.items.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! KDInfoViewCell
        
        // Configure the cell...
        let item = self.items[indexPath.row]
        cell.nameLabel.text = item["name"]
        cell.iconView.image = UIImage(named: item["image"]!)?.imageWithRenderingMode(.AlwaysTemplate)
        return cell
    }
    
    
    
    //MARK: Table View Delegate Method
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGRectGetHeight(tableView.frame) - 192.0
    }
   
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 70.0
    }
    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("kHeaderView") as! KDFooterView
        return headerView
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("kFooterView") as! KDFooterView
        return headerView
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = self.items[indexPath.row]
        switch item["image"]!.lowercaseString {
        case "rateus":
            let url = NSURL(string: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1135313762")!
            if UIApplication.sharedApplication().canOpenURL(url) {
                UIApplication.sharedApplication().openURL(url)
            }
            
            case "contactus":
            let controller = MFMailComposeViewController()
            controller.setToRecipients(["jksolympics@gmail.com"])
            controller.setSubject("Feedback from Summer Games")
            controller.mailComposeDelegate = self
            self.navigationController?.presentViewController(controller, animated: true, completion: nil)
        default:
            let textToShare = "Summer Games is around a corner! Check out this App for live updates!"
            if let url = NSURL(string:"https://itunes.apple.com/us/app/my-olympics-rio-2016/id1135313762?ls=1&mt=8") {
                let objectsToShare = [textToShare, url]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                
                //New Excluded Activities Code
                activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
                //
                
                self.navigationController?.presentViewController(activityVC, animated: true, completion: nil)
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
