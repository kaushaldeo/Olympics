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
        textLabel.textAlignment = .Center
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
    
    func startAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = M_PI*2.0*0.3
        
        rotationAnimation.duration = 0.3
        
        rotationAnimation.cumulative = true
        rotationAnimation.repeatCount = Float.infinity
        
        self.imageView.layer.addAnimation(rotationAnimation, forKey: "rotationAnimation")
    }
    
    
    func stopAnimation() {
        self.imageView.layer.removeAllAnimations()
    }
    
    func update(message: String) {
        self.textLabel.text = message
        self.setNeedsLayout()
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


class KDInfoView : UIView {
    
    class func appVersion() -> String {
        var string = "v"
        if let dictionary = NSBundle.mainBundle().infoDictionary  {
            if let version = dictionary["CFBundleShortVersionString"] as? String {
                string += version
            }
            else {
                string += "1.0"
            }
            if let version = dictionary["CFBundleVersion"] as? String {
                string += "(\(version))"
            }
            else {
                string += "(10)"
            }
        }
        else {
            string += "1.0(10)"
        }
        return string
    }
    
    private lazy var imageView : UIImageView = {
        var imageView = UIImageView(image: UIImage(named: "infoLogo"))
        imageView.tintColor = UIColor.lightGrayColor()
        return imageView
    }()

    private lazy var textLabel : UILabel = {
        var textLabel = UILabel(frame: CGRectZero)
        textLabel.font = UIFont.systemFontOfSize(15.0)
        textLabel.textColor = UIColor.grayColor()
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .Center
        textLabel.text = "Data by Sportradar US"
        return textLabel
    }()
    
    private lazy var versionLabel : UILabel = {
        var versionLabel = UILabel(frame: CGRectZero)
        versionLabel.font = UIFont.systemFontOfSize(14.0)
        versionLabel.textColor = UIColor.grayColor()
        versionLabel.numberOfLines = 1
        versionLabel.textAlignment = .Center
        versionLabel.text = KDInfoView.appVersion()
        return versionLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.imageView)
        self.addSubview(self.textLabel)
        self.addSubview(self.versionLabel)
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
        if let text = self.versionLabel.text {
            size = text.size(self.versionLabel.font, width: CGRectGetWidth(frame) - 32.0)
            
        }
        self.versionLabel.frame = CGRect(x: CGRectGetMidX(frame) - size.width/2, y: CGRectGetMaxY(frame) - size.height, width: size.width, height: size.height)
        
        size = CGSizeZero
        if let text = self.textLabel.text {
            size = text.size(self.textLabel.font, width: CGRectGetWidth(frame) - 32.0)
            
        }
        self.textLabel.frame = CGRect(x: CGRectGetMidX(frame) - size.width/2, y: CGRectGetMinY(self.versionLabel.frame) - size.height - 10.0, width: size.width, height: size.height)
        
    }
}
