//
//  DayScheduleViewCell.swift
//  Olympics
//
//  Created by Kaushal Deo on 6/8/19.
//  Copyright © 2019 Scorpion Inc. All rights reserved.
//

import UIKit

class DayScheduleViewCell: KDCollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = nil
    }
    
    override func update(data: DataModel) {
        guard let item = data as? SportModel else {
            return
        }
        //self.color = item.sport.sports.count == 0 ? .white : .groupTableViewBackground
        //self.selectedColor = item.sport.sports.count == 0 ? UIColor.lightGray.withAlphaComponent(0.3) : .groupTableViewBackground
        self.nameLabel.text = item.sport.name
    }
    
}


class SportModel: DataModel {
    let isOpen: Bool
    let sport: Sport
    
    init(sport: Sport) {
        self.sport = sport
        self.isOpen = false
    }
    
    var isAllowed: Bool {
        return self.sport.sports.count > 0
    }
}
