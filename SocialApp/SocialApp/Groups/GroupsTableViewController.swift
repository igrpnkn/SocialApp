//
//  GroupsTableViewController.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 05.10.2020.
//

import UIKit
import RealmSwift

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
        
        startActivityIndicator()
    
        self.realmToken = groups?.observe({ (changes: RealmCollectionChange) in
            print("\nINFO: Realm <Groups> has been changed.\n")
            switch changes {
            case .initial(let results):
                print("\nINFO: Realm Groups Data has been initiated: \(results)")
                self.groupsTableView.reloadData()
            case .update(let results, let deletions, let insertions, let modifications):
                print(results, deletions, insertions, modifications)
                
            case .error(let error):
                print("\nINFO: Realm groups.observe{} error: \(error.localizedDescription)")
            }
        })
        
//        //RealmManager.deleteAllGroupsObject()
//        if self.groupsArray.isEmpty {
//            downloadUserGroups()
//            print("\nINFO: GroupsTableViewController.viewDidLoad()")
//            print("\nINFO: Groups were loaded from Internet.")
//        }
//        else {
//            print(self.groupsArray.map { $0.name } )
//            self.downloadAvatars()
//            print("\nINFO: Groups were loaded from Realm...\n")
//            stopActivityIndicator()
//        }
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
    
    func downloadUserGroups() {
        NetworkManager.groupsGet(for: UserSession.instance.userId!) { [weak self] groups in
            //DispatchQueue.main.async {
                guard let self = self, let groupsArray = groups else { return }
                RealmManager.saveGotGroupsInRealm(groups: groupsArray)
                self.downloadAvatars()
            //}
        }
    }
    
    func downloadAvatars() {
        guard let groupsArray = self.groups else { return }
        DispatchQueue.main.async {
            for group in groupsArray {
                do {
                    let url = URL(string: group.photo50!)
                    let data = try? Data(contentsOf: url!)
                    group.avatar = UIImage(data: data!) ?? UIImage(named: "camera")!
                }
                catch {
                    print("\nINFO: ERROR while downloading group's avatars: \(error.localizedDescription)")
                    return
                }
            }
            RealmManager.saveGotGroupsInRealm(groups: Array(groupsArray))
            //self.groupsTableView.reloadData()
            print("\nINFO: GroupsTableView is reload from GroupsTableViewController.downloadAvatars() func.")
            self.stopActivityIndicator()
            print("\nINFO: All photos is downloaded.")
            print("\nINFO: Activity indicator is hidden.")
        }
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
