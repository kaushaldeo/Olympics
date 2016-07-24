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
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    
    
    //     Only override drawRect: if you perform custom drawing.
    //     An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPoint(x: 16, y: CGRectGetHeight(rect)))
        bezierPath.addLineToPoint(CGPoint(x: CGRectGetWidth(rect), y: CGRectGetHeight(rect)))
        bezierPath.lineWidth = 0.25
        UIColor.sepratorColor().setStroke()
        bezierPath.strokeWithBlendMode(.Exclusion, alpha: 1.0)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
