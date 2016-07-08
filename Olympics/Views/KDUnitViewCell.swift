//
//  KDUnitViewCell.swift
//  Olympics
//
//  Created by Kaushal Deo on 7/7/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import UIKit

class KDUnitViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
