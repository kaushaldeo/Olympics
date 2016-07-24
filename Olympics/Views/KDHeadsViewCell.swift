//
//  KDHeadsViewCell.swift
//  Olympics
//
//  Created by Kaushal Deo on 7/24/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import UIKit

class KDHeadsViewCell: UITableViewCell {
    
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var homeView: UIImageView!
    @IBOutlet weak var awayLabel: UILabel!
    @IBOutlet weak var awayView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    
    
    
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
    
    
    func setUnit(unit:Unit) {
        if let text = unit.type where text.lowercaseString.rangeOfString("head") != nil {
            if let competitors = unit.competitors?.allObjects as? [Competitor] {
                let home = competitors.first
                let away = competitors.last
                
                self.homeLabel.text = home?.name()
                if let text = home?.iconName() {
                    self.homeView.image = UIImage(named: "Images/\(text).png")
                }
                
                self.awayLabel.text = away?.name()
                if let text = away?.iconName() {
                    self.awayView.image = UIImage(named: "Images/\(text).png")
                }
                
                if let date = unit.startDate {
                    self.resultLabel.text = date.time()
                }
                if let status = unit.status?.lowercaseString {
                    if status == "closed" || status == "inprogress" {
                        var string = ""
                        if let text = home?.resultValue {
                            string += text
                        }
                        else {
                            string += " "
                        }
                        string += "-"
                        if let text = away?.resultValue {
                            string += text
                        }
                        else {
                            string += " "
                        }
                        self.resultLabel.text = string
                    }
                }
                
            }
        }
    }
}
