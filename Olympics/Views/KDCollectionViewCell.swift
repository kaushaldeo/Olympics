//
//  KDCollectionViewCell.swift
//  Olympics
//
//  Created by Kaushal Deo on 6/13/19.
//  Copyright © 2019 Scorpion Inc. All rights reserved.
//

import UIKit

typealias KDCollectionViewCellType = KDCollectionViewCell.Type

class KDCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var contentBackgroundView: UIView!
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutAttributes.size = self.contentBackgroundView.systemLayoutSizeFitting(layoutAttributes.size, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentBackgroundView.backgroundColor = .clear
    }
    
    
    func update(data: DataModel) {}
}


protocol DataModel {}


class ViewModel<Value:DataModel> {
    let type: KDCollectionViewCellType
    let value: Value
    init(type: KDCollectionViewCellType, value:Value)  {
        self.type = type
        self.value = value
    }
}


class CollectionsViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
}
