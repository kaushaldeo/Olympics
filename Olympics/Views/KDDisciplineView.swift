//
//  KDDisciplineView.swift
//  Olympics
//
//  Created by Kaushal Deo on 7/22/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import UIKit

class KDDisciplineView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
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
    
}


class KDFooterView : UITableViewHeaderFooterView {
    
    
}
