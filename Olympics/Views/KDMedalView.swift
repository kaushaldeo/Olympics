//
//  KDMedalView.swift
//  Olympics
//
//  Created by Kaushal Deo on 8/6/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import UIKit

class KDMedalView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var brozeLabel: UILabel!
    @IBOutlet weak var silverLabel: UILabel!
    @IBOutlet weak var goldLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    
    
    var tapHandler : ((KDMedalView)->Void)? = nil
    
    //     Only override drawRect: if you perform custom drawing.
    //     An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        var bezierPath = UIBezierPath(rect: rect)
        UIColor.cellBackgroundColor().setFill()
        bezierPath.fill()
        
        bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPoint(x: 0, y: CGRectGetHeight(rect)))
        bezierPath.addLineToPoint(CGPoint(x: CGRectGetWidth(rect), y: CGRectGetHeight(rect)))
        bezierPath.lineWidth = 0.25
        UIColor.sepratorColor().setStroke()
        bezierPath.strokeWithBlendMode(.Exclusion, alpha: 1.0)
        
    }
    
    
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
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("tapped:")))
    }
    
    func tapped(gesture: UITapGestureRecognizer) {
        debugPrint(gesture.state.rawValue)
        if let block = self.tapHandler {
            block(self)
        }
    }
    
    
}
