//
//  KDWinnerViewCell.swift
//  Olympics
//
//  Created by Kaushal Deo on 8/6/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import UIKit

class KDWinnerViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var medalLabel: UILabel!
    @IBOutlet weak var sportsLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.medalLabel.layer.borderWidth = 1.0
        self.medalLabel.textAlignment = .Center
        self.medalLabel.layer.masksToBounds = true
        self.medalLabel.layer.cornerRadius = 15.0
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    //     Only override drawRect: if you perform custom drawing.
    //     An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        var bezierPath = UIBezierPath(rect: rect)
        UIColor.cellBackgroundColor().setFill()
        bezierPath.fill()
        
        bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPoint(x: 16, y: CGRectGetHeight(rect)))
        bezierPath.addLineToPoint(CGPoint(x: CGRectGetWidth(rect), y: CGRectGetHeight(rect)))
        bezierPath.lineWidth = 0.25
        UIColor.sepratorColor().setStroke()
        bezierPath.strokeWithBlendMode(.Exclusion, alpha: 1.0)
        
    }
    
    
    func setWinner(winner: Winner) {
        self.nameLabel.text = winner.name()
        self.sportsLabel.text = winner.sports()
        var color = UIColor.clearColor()
        var string = ""
        if let medal = winner.medal {
            switch medal.lowercaseString {
            case "1":
                color = UIColor(red: 218, green: 181, blue: 10)
                string = "G"
            case "2":
                color = UIColor.silverColor()
                string = "S"
            default:
                color = UIColor(red: 232, green: 147, blue: 114)
                string = "B"
                
            }
        }
        
        self.medalLabel.layer.borderColor = color.CGColor
        self.medalLabel.text = string
        self.medalLabel.textColor = color
        
        
        
    }
}
