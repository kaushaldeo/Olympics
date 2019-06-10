//
//  CountriesViewController.swift
//  Olympics
//
//  Created by Kaushal Deo on 6/8/19.
//  Copyright © 2019 Scorpion Inc. All rights reserved.
//

import UIKit

class CountriesViewController: UITableViewController {
    
    lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.dimsBackgroundDuringPresentation = false
        controller.searchResultsUpdater = self
        controller.delegate = self
        return controller
    }()
    
    var items = [Country]()
    var filteredItem = [Country]()
    
    // MARK: - Private Methods
    
    func update() {
        NetworkManager.default.get(router: .countries) { [weak self] items in
            self?.items = items
            self?.filteredItem = items
            self?.tableView.reloadData()
        }
    }
    
    
    
    // MARK: - View life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.searchController = self.searchController
        self.tableView.updateFooter()
        self.update()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredItem.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(cell: CountryViewCell.self, for: indexPath)
        
        // Configure the cell...
        let item = self.filteredItem[indexPath.row]
        cell.nameLabel.text = item.name
        cell.aliasLabel.text = item.code
        let text = item.code.lowercased()
        cell.iconView.image = UIImage(named: "Images/\(text).png")
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension CountriesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        defer {
            self.tableView.reloadData()
        }
        guard let text = searchController.searchBar.text else {
            self.filteredItem = self.items
            return
        }
        self.filteredItem = self.items.filter({ $0.name.lowercased().contains(text.lowercased())})
    }
}


extension CountriesViewController: UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        self.filteredItem = self.items
        self.tableView.reloadData()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        self.filteredItem = self.items
        self.tableView.reloadData()
        
    }
}
