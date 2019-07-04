//
//  MedalsViewController.swift
//  Olympics
//
//  Created by Kaushal Deo on 7/4/19.
//  Copyright © 2019 Scorpion Inc. All rights reserved.
//

import UIKit

class MedalsViewController: CollectionsViewController {
    
    var items = [Country]()
    
    func update() {
        NetworkManager.default.countries(router: .countries) { [weak self] items in
            guard let strongSelf = self else { return }
            strongSelf.items = items
            strongSelf.collectionView.reloadData()
        }
    }
    
    
    //MARK: - View life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.collectionView.backgroundColor = .background
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

extension MedalsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.items[indexPath.row]
        let cell = collectionView.dequeueReusable(cell: MedalViewCell.self, for: indexPath)
        cell.update(data: item)
        return cell
    }
}
