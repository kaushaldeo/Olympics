//
//  DayScheduleViewCell.swift
//  Olympics
//
//  Created by Kaushal Deo on 6/8/19.
//  Copyright © 2019 Scorpion Inc. All rights reserved.
//

import UIKit

class DayScheduleViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentLayer: UIView!
    
    var items = [Country]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var height: CGFloat = 70.0
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let path = keyPath, path == "contentSize" else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        let size: CGSize = change?[.newKey] as? CGSize ?? .zero
        self.height = size.height
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.lightGray
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.updateFooter()
        
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = nil
        self.items = []
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        var size = layoutAttributes.size
        size.height = CGFloat.greatestFiniteMagnitude
        self.contentLayer.layoutIfNeeded()
        self.tableView.layoutIfNeeded()
        size = self.contentLayer.systemLayoutSizeFitting(layoutAttributes.size, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        layoutAttributes.size = size
        return layoutAttributes
    }
    
}

extension DayScheduleViewCell: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(self.items.count, 3)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(cell: CountryViewCell.self, for: indexPath)
        
        // Configure the cell...
        let item = self.items[indexPath.row]
        cell.nameLabel.text = item.name
        cell.aliasLabel.text = item.code
        let text = item.code.lowercased()
        cell.iconView.image = UIImage(named: "Images/\(text).png")
        
        return cell
    }
}
