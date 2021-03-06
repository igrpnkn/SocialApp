//
//  GroupsTableViewController.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 05.10.2020.
//

import UIKit
import RealmSwift
import PromiseKit

class GroupsTableViewController: UITableViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var groupsTableView: UITableView!
    let activityIndicator = UIActivityIndicatorView()
    var realmToken: NotificationToken?  // it is responsible for updating state of Realm objects or collections
    
    //var groupsArray: [Group] = RealmManager.groupsGetFromRealm() ?? []
    var groups: Results<Group>? = RealmManager.groupsGetFromRealm()
    
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
        self.groupsTableView.delegate = self
        self.groupsTableView.dataSource = self
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        searchField.searchResultsUpdater = self
        searchField.obscuresBackgroundDuringPresentation = false
        searchField.searchBar.placeholder = "Search..."
        navigationItem.searchController = searchField
        definesPresentationContext = true
        
        setupRefreshControl()
        startActivityIndicator()
        observeRealmGroupsCollection()
        downloadUserGroups()
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
            return groups?.count ?? 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsTableViewCell", for: indexPath) as! GroupsTableViewCell
        guard let groups = self.groups else {
            return cell
        }
        var dataFromArray: Group
        if isFiltering {
            dataFromArray = searchedGroup[indexPath.row]
        } else {
            dataFromArray = groups[indexPath.row]
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
        if let groupsForSearching = self.groups {
            searchedGroup = Array(groupsForSearching).filter {(i: Group) -> Bool in return i.name.lowercased().contains(searchText.lowercased())}
            groupsTableView.reloadData()
        }
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
    
    private func observeRealmGroupsCollection() {
        self.realmToken = groups?.observe(on: DispatchQueue.main, { (changes: RealmCollectionChange) in
            print("\nINFO: Realm <Groups> has been changed.\n")
            switch changes {
            case .initial(let results):
                print("\nINFO: Realm Groups Data has been initiated: \(results)")
                self.groupsTableView.reloadData()
            case .update(let results, let deletions, let insertions, let modifications):
                print("\nINFO: Realm Groups data has been updated:\nResults: \(results),\nDeletions: \(deletions),\nInsertion: \(insertions),\nModifications: \(modifications)")
                self.groupsTableView.beginUpdates()
                self.groupsTableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                self.groupsTableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                self.groupsTableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                self.groupsTableView.endUpdates()
            case .error(let error):
                print("\nINFO: Realm groups.observe{} error: \(error.localizedDescription)")
            }
        })
    }
    
    private func downloadUserGroups() {
        DispatchQueue.global().async {
            NetworkManager.groupsGet(for: UserSession.instance.userId!) { [weak self] groups in
                guard let self = self, let groupsArray = groups else { return }
                RealmManager.deleteObjects(delete: Group.self) // is used to resolve logical conflict when we have deleted Group in vk.com but in RealmDB it still is there
                RealmManager.saveGotGroupsInRealm(groups: groupsArray)
                self.stopActivityIndicator()
                self.downloadAvatars(groupsData: Array(self.groups!))
            }
        }
    }
    
    private func downloadAvatars(groupsData: [Group]) {
        for group in groupsData {
            if let url = URL(string: group.photo50!),
               let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    RealmManager.saveAvatarForGroupID(image: data, groupID: group.id)
                }
            }
        }
    }
    
    private func promisingUserGroups() {
        firstly {
            NetworkManager.groupsGet(for: UserSession.instance.userId!)
        }.get(on: .main, flags: nil) { (parsedGroups) in
            RealmManager.deleteObjects(delete: Group.self) // is used to resolve logical conflict when we have deleted Group in vk.com but in RealmDB it still is there
            RealmManager.saveGotGroupsInRealm(groups: parsedGroups)
        }.done(on: .global(), flags: nil) { (parsedGroups) in
            self.downloadAvatars(groupsData: parsedGroups)
        }.done(on: .main, flags: nil) {
            self.stopActivityIndicator()
        }.catch { (error) in
            print("\nINFO: ERROR - \(error.localizedDescription)")
        }
    }
    
    func startActivityIndicator() {
        print("\nINFO: Loading \(self.description) has begun.")
        activityIndicator.center.x = self.view.center.x
        activityIndicator.center.y = self.view.frame.width / 5
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
    }
    
    override func refreshData() {
        self.refreshControl?.beginRefreshing()
        downloadUserGroups()
        print("\nINFO: \(#function) : Data refreshing...")
        refreshControl?.endRefreshing()
    }
}
