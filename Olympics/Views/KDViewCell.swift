//
//  KDViewCell.swift
//  Olympics
//
//  Created by Kaushal Deo on 6/8/19.
//  Copyright © 2019 Scorpion Inc. All rights reserved.
//

import Foundation
import UIKit

protocol KDViewCell {}

// MARK: - UITableView View Cell
extension UITableViewCell: KDViewCell {}

extension KDViewCell where Self: UITableViewCell {
    static var cellIdentifier: String {
        return String(describing: self)
    }
}

// MARK: - UITable View Extension
extension UITableView {
    func dequeueReusable<T: UITableViewCell>(cell: T.Type, for indexPath: IndexPath) -> T {
        guard let viewCell = self.dequeueReusableCell(withIdentifier: cell.cellIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(cell.cellIdentifier)")
        }
        return viewCell
    }
    
    func updateFooter(background color: UIColor? = nil) {
        let view = UIView(frame: .zero)
        view.backgroundColor = color ?? self.backgroundColor
        self.tableFooterView = view
    }
}

// MARK: - UICollection View Cell
extension KDCollectionViewCell: KDViewCell {}

extension KDViewCell where Self: KDCollectionViewCell {
    static var cellIdentifier: String {
        return String(describing: self)
    }
}


// MARK: - UICollection View Extension
extension UICollectionView {
    func dequeueReusable<T: KDCollectionViewCell>(cell: T.Type, for indexPath: IndexPath) -> T {
        guard let viewCell = self.dequeueReusableCell(withReuseIdentifier: cell.cellIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(cell.cellIdentifier)")
        }
        return viewCell
    }
    
    func makeDynamicCell() {
        guard let layout = self.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        let width = UIScreen.main.bounds.width - (0.5 + layout.sectionInset.left + layout.sectionInset.right + self.contentInset.left + self.contentInset.right)
        layout.estimatedItemSize = CGSize(width: width, height: 10.0)
    }
}


