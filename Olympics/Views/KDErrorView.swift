//
//  KDErrorView.swift
//  Olympics
//
//  Created by Kaushal Deo on 7/23/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import UIKit

class KDErrorView: UIView {
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
    private lazy var imageView : UIImageView = {
        var imageView = UIImageView(image: UIImage(named: "logo")?.imageWithRenderingMode(.AlwaysTemplate))
        imageView.tintColor = UIColor.lightGrayColor()
        return imageView
    }()
    
    private lazy var textLabel : UILabel = {
        var textLabel = UILabel(frame: CGRectZero)
        textLabel.font = UIFont.systemFontOfSize(15.0)
        textLabel.textColor = UIColor.lightGrayColor()
        textLabel.numberOfLines = 0
        return textLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.imageView)
        self.addSubview(self.textLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let frame = self.bounds
        
        var size = self.imageView.bounds.size
        self.imageView.frame = CGRect(x: CGRectGetMidX(frame) - size.width/2, y: CGRectGetMidY(frame) - size.height, width: size.width, height: size.height)
        
        size = CGSizeZero
        if let text = self.textLabel.text {
            size = text.size(self.textLabel.font, width: CGRectGetWidth(frame) - 32.0)
            
        }
        self.textLabel.frame = CGRect(x: CGRectGetMidX(frame) - size.width/2, y: CGRectGetMaxY(self.imageView.frame) + 10.0, width: size.width, height: size.height)
    }
    
    
    class func view(message: String) -> KDErrorView {
        let view = KDErrorView(frame: CGRectZero)
        //TODO: Set the message to the label
        view.backgroundColor = UIColor.clearColor()
        view.textLabel.text = message
        return view
    }
}
