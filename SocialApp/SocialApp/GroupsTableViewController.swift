//
//  GroupsTableViewController.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 05.10.2020.
//

import UIKit

class GroupsTableViewController: UITableViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var groupsTableView: UITableView!
    
//    let groupsArray: [Group] = [
//        Group(name: "First group", image: UIImage(named: "musicGroup")!, followersCount: 111, publicationsCount: 128),
//        Group(name: "Second group", image: UIImage(named: "musicGroup")!, followersCount: 112, publicationsCount: 128),
//        Group(name: "Third group", image: UIImage(named: "musicGroup")!, followersCount: 113, publicationsCount: 128),
//        Group(name: "Fourth group", image: UIImage(named: "musicGroup")!, followersCount: 114, publicationsCount: 128),
//        Group(name: "Fifth group", image: UIImage(named: "musicGroup")!, followersCount: 115, publicationsCount: 128),
//        Group(name: "Sixth group", image: UIImage(named: "musicGroup")!, followersCount: 116, publicationsCount: 128),
//        Group(name: "Seventh group", image: UIImage(named: "musicGroup")!, followersCount: 117, publicationsCount: 128),
//        Group(name: "Eighth group", image: UIImage(named: "musicGroup")!, followersCount: 118, publicationsCount: 128),
//        Group(name: "Nineth group", image: UIImage(named: "musicGroup")!, followersCount: 119, publicationsCount: 128),
//        Group(name: "Tenth group", image: UIImage(named: "musicGroup")!, followersCount: 120, publicationsCount: 128),
//        Group(name: "Eleventh group", image: UIImage(named: "musicGroup")!, followersCount: 121, publicationsCount: 128),
//        Group(name: "Twelveth group", image: UIImage(named: "musicGroup")!, followersCount: 122, publicationsCount: 128),
//        Group(name: "Private group", image: UIImage(named: "musicGroup")!, followersCount: 123, publicationsCount: 128)
//    ]
    var searchedGroup: [Group] = []
    
    let searchField = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchField.searchBar.text else {
            return false
        }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchField.isActive && !searchBarIsEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupsTableView.delegate = self
        groupsTableView.dataSource = self
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        searchField.searchResultsUpdater = self
        searchField.obscuresBackgroundDuringPresentation = false
        searchField.searchBar.placeholder = "Type to search..."
        navigationItem.searchController = searchField
        definesPresentationContext = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        /*
        if isFiltering {
            return searchedGroup.count
        } else {
            return groupsArray.count
        }
        */
        switch isFiltering {
        case true:
            return searchedGroup.count
        case false:
            let rowsOfGroupWeSubscripted = GroupDataBase.instance.item.filter { (i) -> Bool in
                return i.subscription == true
            }
            return rowsOfGroupWeSubscripted.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsTableViewCell", for: indexPath) as! GroupsTableViewCell
        
        var dataFromArray: Group
        
        if isFiltering {
            dataFromArray = searchedGroup[indexPath.row]
        } else {
            let rowsOfGroupWeSubscripted = GroupDataBase.instance.item.filter { (i) -> Bool in
                return i.subscription == true
            }
            dataFromArray = rowsOfGroupWeSubscripted[indexPath.row]
        }
        
        cell.groupName.text = dataFromArray.name
        cell.groupImage.image = dataFromArray.image
        cell.groupFollowers.text = "\(dataFromArray.followersCount ?? 0) followers"
        cell.groupSubscription.isHidden = !dataFromArray.subscription
        cell.groupDescription.text = dataFromArray.description

        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        searchedGroup = GroupDataBase.instance.item.filter{(i) -> Bool in return i.subscription == true}.filter{(i: Group) -> Bool in return i.name.lowercased().contains(searchText.lowercased())}
        
//        searchedGroup = GroupDataBase.instance.item.filter({ (group: Group) -> Bool in
//            return group.name.lowercased().contains(searchText.lowercased())
//        })
        groupsTableView.reloadData()
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

    
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProfile" {
            if let indexPath = groupsTableView.indexPathForSelectedRow {
                let group: Group
                if isFiltering {
                    group = searchedGroup[indexPath.row]
                } else {
                    group = groupsArray[indexPath.row]
                }
                let profileVC = segue.destination as! ProfileViewController
                profileVC.group = group
            }
        }
    }
    */

}
