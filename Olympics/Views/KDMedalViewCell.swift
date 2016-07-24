//
//  KDMedalViewCell.swift
//  Olympics
//
//  Created by Kaushal Deo on 6/27/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import UIKit

class KDMedalViewCell: UITableViewCell {
    
    @IBOutlet weak var brozeLabel: UILabel!
    @IBOutlet weak var silverLabel: UILabel!
    @IBOutlet weak var goldLabel: UILabel!
    @IBOutlet weak var aliasLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        var color = UIColor(red: 218, green: 181, blue: 10)
        self.goldLabel.layer.borderColor = color.CGColor
        self.goldLabel.layer.borderWidth = 1.0
        self.goldLabel.textAlignment = .Center
        self.goldLabel.layer.masksToBounds = true
        self.goldLabel.layer.cornerRadius = 15.0
        self.goldLabel.textColor = color
        
        color = UIColor.silverColor()
        self.silverLabel.layer.borderColor = color.CGColor
        self.silverLabel.layer.borderWidth = 1.0
        self.silverLabel.textAlignment = .Center
        self.silverLabel.layer.masksToBounds = true
        self.silverLabel.layer.cornerRadius = 15.0
        self.silverLabel.textColor = color
        
        color = UIColor(red: 232, green: 147, blue: 114)
        self.brozeLabel.layer.borderColor = color.CGColor
        self.brozeLabel.layer.borderWidth = 1.0
        self.brozeLabel.textAlignment = .Center
        self.brozeLabel.layer.masksToBounds = true
        self.brozeLabel.layer.cornerRadius = 15.0
        self.brozeLabel.textColor = color
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
