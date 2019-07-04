//
//  MedalViewCell.swift
//  Olympics
//
//  Created by Kaushal Deo on 7/4/19.
//  Copyright © 2019 Scorpion Inc. All rights reserved.
//

import UIKit
import Kingfisher

class MedalViewCell: KDCollectionViewCell {
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var flagView: UIImageView!
    @IBOutlet weak var goldLabel: UILabel!
    @IBOutlet weak var silverLabel: UILabel!
    @IBOutlet weak var bronzeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.make(circle: 5.0)
        self.flagView.make(circle: 2.0)
        if let backgroundView = self.goldLabel.superview {
            backgroundView.backgroundColor = .gold
        }
        if let backgroundView = self.silverLabel.superview {
            backgroundView.backgroundColor = .silver
        }
        if let backgroundView = self.bronzeLabel.superview {
            backgroundView.backgroundColor = .bronze
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.countryLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let backgroundView = self.goldLabel.superview {
            backgroundView.make(circle: backgroundView.bounds.width/2)
        }
        if let backgroundView = self.silverLabel.superview {
            backgroundView.make(circle: backgroundView.bounds.width/2)
        }
        if let backgroundView = self.bronzeLabel.superview {
            backgroundView.make(circle: backgroundView.bounds.width/2)
        }
    }
    
    override func update(data: DataModel) {
        guard let item = data as? Country else {
            return
        }
        self.countryLabel.text = item.name
        self.goldLabel.text = "32"
        self.silverLabel.text = "6"
        self.bronzeLabel.text = "88"
        self.flagView.kf.setImage(with: URL(string: item.imageURL))
        
    }
}
