//
//  KDRankingCell.swift
//  Olympics
//
//  Created by Kaushal Deo on 7/25/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import UIKit

class KDRankingCell: UITableViewCell {
    
    @IBOutlet weak var tableView: UITableView!

    var competitors = [Competitor]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.competitors.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Configure the cell...
        let cell = tableView.dequeueReusableCellWithIdentifier("Rank", forIndexPath: indexPath) as! KDResultViewCell
        let competitor = self.competitors[indexPath.row]
        cell.nameLabel.text = competitor.name()
        if let text = competitor.iconName() {
            cell.iconView.image = UIImage(named: "Images/\(text).png")
        }
        cell.rankLabel.text = competitor.rank ?? "-"
        cell.resultLabel.text = competitor.resultValue
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let competitor = self.competitors[indexPath.row]
        var height = CGFloat(0)
            let string = competitor.resultValue ?? ""
            let width = string.size(UIFont.systemFontOfSize(14), width: (CGRectGetWidth(tableView.frame) - 80)).width + 80.0
            if let text = competitor.name() {
                height += text.size(UIFont.systemFontOfSize(14), width:CGRectGetWidth(tableView.frame) - width).height + 20
            }
        return height
    }
    

}
