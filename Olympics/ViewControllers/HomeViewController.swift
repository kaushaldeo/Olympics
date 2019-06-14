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
    
    var items = [ViewModel<SportModel>]()
    
    // MARK: - Private Methods
    func update() {
        NetworkManager.default.sports(router: .sports) { [weak self] items in
            guard let strongSelf = self else { return }
            print(items)
            strongSelf.items = items.reduce([], { (array, sport) -> [ViewModel<SportModel>] in
                if sport.sports.count == 0 {
                    return array + [ViewModel<SportModel>(type: DayScheduleViewCell.self, value: SportModel(sport: sport))]
                }
                return array + [ViewModel<SportModel>(type: DayScheduleViewCell.self, value: SportModel(sport: sport))] + sport.sports.map({ SportModel(sport: $0)}).map({ ViewModel<SportModel>(type: DisciplineViewCell.self, value: $0) })
            })
            
            strongSelf.collectionView.reloadData()
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
        let item = self.items[indexPath.row]
        let cell = collectionView.dequeueReusable(cell: item.type, for: indexPath)
        cell.update(data: item.value)
        return cell
    }
}
