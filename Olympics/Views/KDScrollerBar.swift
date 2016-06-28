//
//  KDScrollerBar.swift
//  Olympics
//
//  Created by Kaushal Deo on 6/10/16.
//  Copyright © 2016 Scorpion Inc. All rights reserved.
//

import UIKit

protocol KDScrollerBarDelegate : NSObjectProtocol {
    func scrollerBar(scrollerBar: KDScrollerBar, numberOfItemsInSection section: Int) -> Int
    
    func scrollerBar(scrollerBar: KDScrollerBar, titleForItemAtIndexPath indexPath: NSIndexPath) -> String?
    
    func scrollerBar(scrollerBar: KDScrollerBar, didSelectItemAtIndexPath indexPath: NSIndexPath)
    
    func scrollerBar(scrollerBar: KDScrollerBar, scrollToOffset point: CGPoint)
    
}

class KDScrollerBar: UIView {
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var delegate: KDScrollerBarDelegate? = nil
    
    
    func reloadData() {
         self.collectionView.layoutIfNeeded()
        self.collectionView.reloadData()
    }
    
    func scrollToItemAtIndexPath(indexPath: NSIndexPath, animated: Bool) {
        self.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: animated)
    }
    
    
    func scrollToOffset(offset: CGPoint,  animated: Bool) {
        self.collectionView.setContentOffset(offset, animated: animated)
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        let width = CGRectGetWidth(rect)/3
        let bezierPath = UIBezierPath(rect: CGRect(x: width, y: CGRectGetHeight(rect) - 5.0, width: width, height: 5.0))
        UIColor.redColor().setFill()
        bezierPath.fill()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.backgroundColor = UIColor.clearColor()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: CGRectGetWidth(self.bounds)/3, bottom: 0, right: CGRectGetWidth(self.bounds)/3)
            flowLayout.minimumLineSpacing = 0.0
            flowLayout.minimumInteritemSpacing = 0.0
            self.collectionView.setCollectionViewLayout(flowLayout, animated: true)
        }
        self.collectionView.layoutIfNeeded()
        self.collectionView.reloadData()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if let delegation = self.delegate {
            return delegation.scrollerBar(self, numberOfItemsInSection: 0)
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! KDScrollerBarItem
        
        let string = self.delegate?.scrollerBar(self, titleForItemAtIndexPath: indexPath)
        cell.textLabel.text = string
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: CGRectGetWidth(self.bounds)/3, height: CGRectGetHeight(collectionView.bounds))
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth = Double(scrollView.frame.size.width/3)
        
        let currentOffset = Double(scrollView.contentOffset.x)
        let targetOffset = Double(targetContentOffset.memory.x)
        var newTargetOffset : Double = 0
        
        if (targetOffset > currentOffset) {
            newTargetOffset = ceil(currentOffset / pageWidth) * pageWidth
        }
        else {
            newTargetOffset = floor(currentOffset / pageWidth) * pageWidth;
        }
        if (newTargetOffset < 0) {
            newTargetOffset = 0
        }
        
        targetContentOffset.memory.x = CGFloat(currentOffset)
        scrollView.setContentOffset(CGPoint(x:newTargetOffset, y:0), animated: true)
        let index = Int(newTargetOffset/pageWidth)
        self.delegate?.scrollerBar(self, didSelectItemAtIndexPath: NSIndexPath(forItem: index, inSection: 0))
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
   
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: true)
        self.delegate?.scrollerBar(self, didSelectItemAtIndexPath: indexPath)
    }
    
}

class KDScrollerBarItem : UICollectionViewCell {
    @IBOutlet weak var textLabel: UILabel!
    
}
