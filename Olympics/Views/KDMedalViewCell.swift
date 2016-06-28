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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
