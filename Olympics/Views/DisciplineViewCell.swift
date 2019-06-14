//
//  DisciplineViewCell.swift
//  Olympics
//
//  Created by Kaushal Deo on 6/14/19.
//  Copyright © 2019 Scorpion Inc. All rights reserved.
//

import UIKit

class DisciplineViewCell: KDCollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = nil
    }
    
    override func update(data: DataModel) {
        guard let item = data as? SportModel else {
            return
        }
        self.nameLabel.text = item.sport.name
    }
}
