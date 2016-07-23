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
    
    @IBOutlet weak var genderView: UIImageView!
    @IBOutlet weak var medalView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = UIColor.whiteColor()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
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
    
}
