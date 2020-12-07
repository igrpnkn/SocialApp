//
//  GroupsTableViewController.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 05.10.2020.
//

import UIKit

class GroupsTableViewController: UITableViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var groupsTableView: UITableView!
    let activityIndicator = UIActivityIndicatorView()
    
    var groupsArray: [Group] = []
    
    // Search...
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
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupsTableView.delegate = self
        groupsTableView.dataSource = self
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        searchField.searchResultsUpdater = self
        searchField.obscuresBackgroundDuringPresentation = false
        searchField.searchBar.placeholder = "Search..."
        navigationItem.searchController = searchField
        definesPresentationContext = true
        
        startActivityIndicator()
        downloadUserGroups()
        
        print("\nINFO: GroupsTableViewController.viewDidLoad() is completed.")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch isFiltering {
        case true:
            return searchedGroup.count
        case false:
            return groupsArray.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsTableViewCell", for: indexPath) as! GroupsTableViewCell
        var dataFromArray: Group
        if isFiltering {
            dataFromArray = searchedGroup[indexPath.row]
        } else {
            dataFromArray = groupsArray[indexPath.row]
        }
        cell.configureCell(name: dataFromArray.name, image: dataFromArray.avatar, followersCount: dataFromArray.membersCount, activity: dataFromArray.activity)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? GroupsTableViewCell {
            cell.contentView.animationOfTouchDown()
        }
    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? GroupsTableViewCell {
            cell.contentView.animationOfTouchUp()
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        searchedGroup = groupsArray.filter{(i: Group) -> Bool in return i.name.lowercased().contains(searchText.lowercased())}
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

extension GroupsTableViewController {
    
    func downloadUserGroups() {
        NetworkManager.groupsGet(for: UserSession.instance.userId!) { [weak self] groupsArray in
            DispatchQueue.main.async {
                guard let self = self, let groupsArray = groupsArray else { return }
                self.groupsArray = groupsArray
                print("\nFriends from TBC: L = \(groupsArray.count), V = \(groupsArray.count), and SELF = \(self.groupsArray.count)")
                print(self.groupsArray.map { $0.name } )
                
                self.groupsTableView.reloadData()
                print("\nINFO: TableView is reload from NetworkManager.friendsGet(for:) closure.")
                
                self.downloadAvatars()
            }
        }
    }
    
    func downloadAvatars() {
        //DispatchQueue.main.async {
        for group in self.groupsArray {
            if let url = URL(string: group.photo50!) {
                guard let data = try? Data(contentsOf: url) else { return }
                group.avatar = UIImage(data: data)
                print("Photo downloaded: \(url)")
            }
        }
        self.groupsTableView.reloadData()
        print("\nINFO: TableView is reload from GroupsTableViewController.downloadAvatars() func.")
        stopActivityIndicator()
        print("\nAll photos is downloaded...")
        print("\nActivity indicator is hidden...")
        //}
    }
    
    func startActivityIndicator() {
        activityIndicator.center.x = self.view.center.x
        activityIndicator.center.y = self.view.frame.width / 5
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        self.view.addSubview(activityIndicator)
    }
    
    func stopActivityIndicator() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
    }
    
}
