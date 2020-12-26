//
//  FriendsTableViewController.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 05.10.2020.
//

import UIKit
import RealmSwift

class FriendsTableViewController: UITableViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var friendsTableView: UITableView!
    let activityIndicator = UIActivityIndicatorView()
    var realmToken: NotificationToken?
    
    // Array for downloaded objects
    //var friendsArray: [Friend] = RealmManager.friendsGetFromRealm() ?? []
    var friends: Results<Friend>? = RealmManager.friendsGetFromRealm()
    
    // Indexation...
    var friendIndex: [String] = []
    func createIndex() {
        // Logic of indexation - getting unique first letter of .lastName into friendIndex[]
        var temporaryIndex: [String] = []
        for item in self.friends! {
            temporaryIndex.append(String(item.lastName.first!))
        }
        friendIndex = Array(Set(temporaryIndex)).sorted()
        print("\nCreated index: ")
        print(self.friendIndex)
    }
    //
    
    // Search...
    var searchedFriend: [Friend] = []
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
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        searchField.searchResultsUpdater = self
        searchField.obscuresBackgroundDuringPresentation = false
        searchField.searchBar.placeholder = "Search..."
        navigationItem.searchController = searchField
        definesPresentationContext = true
        
        startActivityIndicator()
        observeRealmFriendsCollection()
        downloadUserFriends()
//        RealmManager.deleteAllFriendsObject()
//        if self.friendsArray.isEmpty {
//            downloadFriends()
//            print("\nINFO: FriendsTableViewController.viewDidLoad()")
//            print("\nINFO: Friends were loaded from Internet.")
//        }
//        else {
//            //self.friendsArray =
//            self.createIndex()
//            print(self.friendsArray.map { $0.firstName } )
//            self.downloadAvatars()
//            print("\nINFO: Friends were loaded from Realm...\n")
//            stopActivityIndicator()
//        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        switch isFiltering {
        case true:
            return 1
        case false:
            return friendIndex.count
        }
        //return friendIndex.count
    }
    
    
    // Does not work with method: tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    /*
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch isFiltering {
        case true:
            return "Found:"
        case false:
            return String(friendIndex[section])
        }
    }
    */
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 28))
        sectionHeaderView.backgroundColor = UIColor.systemGray5
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: sectionHeaderView.frame.width, height: 28))
        label.tintColor = .label
        switch isFiltering {
        case true:
            label.text = "Found:"
        case false:
            label.text = String(friendIndex[section])
        }
        sectionHeaderView.addSubview(label)
        return sectionHeaderView
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return friendIndex
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch isFiltering {
        case true:
            return searchedFriend.count
        case false:
            let buffer = friends!.filter{ [weak self] (friend) -> Bool in
                self?.friendIndex[section] == String(friend.lastName.first!)
            }
            return buffer.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell", for: indexPath) as! FriendsTableViewCell
        let friends = Array(self.friends!)
        var dataFromArray: Friend
        if isFiltering {
            dataFromArray = searchedFriend[indexPath.row]
        } else {
            let buffer = friends.filter{ (friend) -> Bool in
                self.friendIndex[indexPath.section] == String(friend.lastName.first!)
            }
            dataFromArray = buffer[indexPath.row]
        }
        cell.configureCell(fullName: "\(dataFromArray.lastName) \(dataFromArray.firstName)", lastSeen: dataFromArray.lastSeen, occupation: dataFromArray.occupationName, avatar: dataFromArray.avatar, online: dataFromArray.online)
        return cell
    }
        
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? FriendsTableViewCell {
            cell.contentView.animationOfTouchDown()
        }
    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? FriendsTableViewCell {
            cell.contentView.animationOfTouchUp()
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        searchedFriend = friends!.filter({ (i) -> Bool in return (i.lastName.lowercased().contains(searchText.lowercased()) || i.firstName.lowercased().contains(searchText.lowercased())) })
        friendsTableView.reloadData()
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "segueToPeople":
            print("\nINFO: Segue to SearchPeopleViewController has been choosen.\n")
            return
        case "segueToFriendProfile":
            print("\nINFO: Segue to FriendProfileViewController has been choosen.\n")
            if let indexPath = friendsTableView.indexPathForSelectedRow {
                let friend: Friend
                let friendsArray = Array(self.friends!)
                if isFiltering {
                    friend = searchedFriend[indexPath.row]
                 } else {
                    let buffer = friendsArray.filter{ (friend) -> Bool in
                        self.friendIndex[indexPath.section] == String(friend.lastName.first!)
                    }
                    friend = buffer[indexPath.row]
                 }
                let friendProfileVC = segue.destination as! FriendProfileViewController
                friendProfileVC.friendProfile = friend
            }
        default:
            print("ERROR - NAVIGATION: Unknown segue from FriendsTableViewController.")
            return
        }
    }
    
}

extension FriendsTableViewController {
    
    func observeRealmFriendsCollection() {
        self.realmToken = friends?.observe(on: DispatchQueue.main, { (changes: RealmCollectionChange) in
            switch changes {
            case .initial(let results):
                print("\nINFO: Realm Groups Data has been initiated: \(results)")
                self.createIndex()
                self.friendsTableView.reloadData()
            case .update(let results, let deletions, let insertions, let modifications):
                print("\nINFO: Realm Friends data has been updated:\nResults: \(results.count),\nDeletions: \(deletions),\nInsertion: \(insertions),\nModifications: \(modifications)")
//                self.friendsTableView.beginUpdates()
//
//                for item in deletions {
//
//                }
//
//                self.friendsTableView.deleteRows(at: deletions, with: .automatic)
//
//                self.friendsTableView.endUpdates()
            case .error(let error):
                print("\nINFO: Realm friends.observe{} error: \(error.localizedDescription)")
            }
        })
    }
    
    func downloadUserFriends() {
        NetworkManager.friendsGet(for: UserSession.instance.userId!) { [weak self] friends in
            guard let self = self, let friendsArray = friends else { return }
            RealmManager.saveGotFriendsInRealm(freinds: friendsArray)
            self.downloadAvatars()
        }
    }
    
    func downloadAvatars() {
        for friend in self.friends! {
            guard
                let url = URL(string: friend.photo50!),
                let data = try? Data(contentsOf: url)
            else {
                print("\nINFO: ERROR - While downloading avatar for friend ID: \(friend.id) \n")
                return
            }
            RealmManager.saveAvatarForUserID(image: data, userID: friend.id)
        }
        print("\nINFO: TableView is reload from FriendsTableViewController.downloadAvatars() func.")
        self.stopActivityIndicator()
        print("\nINFO: All photos is downloaded.")
        print("\nINFO: Activity indicator is hidden.")
    }

    func startActivityIndicator() {
        print("\nINFO: Loading \(self.description) has begun.")
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
