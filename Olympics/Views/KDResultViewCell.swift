//
//  KDResultViewCell.swift
//  Olympics
//
//  Created by Kaushal Deo on 7/22/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import UIKit

class KDResultViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
