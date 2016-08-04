//
//  KDAthleteViewCell.swift
//  Olympics
//
//  Created by Kaushal Deo on 8/4/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import UIKit

class KDAthleteViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var sportsLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.iconView.tintColor = UIColor.blackColor()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
