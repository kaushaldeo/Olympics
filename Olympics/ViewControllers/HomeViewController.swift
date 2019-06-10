//
//  HomeViewController.swift
//  Olympics
//
//  Created by Kaushal Deo on 6/8/19.
//  Copyright © 2019 Scorpion Inc. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var items = [Region]()
    // MARK: - Private Methods
    func update(data: [Country]) {
        var results = [String:[Country]]()
        for item in data {
            let key = item.region.lowercased()
            var items = results[key] ?? []
            items.append(item)
            results[key] = items
        }
        var regions = [Region]()
        for (key, items) in results {
            regions.append(Region(name: key.capitalized, items: items))
        }
        self.items = regions.sorted(by: { $0.name < $1.name })
        self.collectionView.reloadData()
        
    }
    func update() {
        NetworkManager.default.get(router: .countries) { [weak self] items in
            self?.update(data: items)
        }
    }
    
    //MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.collectionView.makeDynamicCell()
        self.update()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusable(cell: DayScheduleViewCell.self, for: indexPath)
        let item = self.items[indexPath.row]
        cell.nameLabel.text = item.name
        cell.items = item.items
        return cell
    }
}
