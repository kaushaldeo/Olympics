//
//  Color.swift
//  Olympics
//
//  Created by Kaushal Deo on 7/4/19.
//  Copyright © 2019 Scorpion Inc. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha: Float = 1.0) {
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: CGFloat(alpha))
    }
    
    
    static let background = UIColor(red: 68, green: 0, blue: 120)
    static let gold = UIColor(red: 233, green: 211, blue: 111)
    static let silver = UIColor(red: 206, green: 204, blue: 215)
    static let bronze = UIColor(red: 150, green: 100, blue: 90)
    
}

extension UIView {
    func make(border color: UIColor, width: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    func make(circle radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
