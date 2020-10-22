//
//  FriendsTableViewController.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 05.10.2020.
//

import UIKit

class FriendsTableViewController: UITableViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var friendsTableView: UITableView!
    
    // Getting friends from all users...
    let friendsArray: [User] = UserDataBase.instance.item.filter({ (item) -> Bool in
        return item.friendship == true
    })
    
    // Indexation...
    var friendIndex: [String] = []
    func createIndex() {
        // Logic of indexation - getting unique first letter of .lastName into friendIndex[]
        var temporaryIndex: [String] = []
        for item in friendsArray {
            temporaryIndex.append(String(item.lastName.first!))
        }
        friendIndex = Array(Set(temporaryIndex)).sorted()
    }
    //
    
    // Search...
    var searchedFriend: [User] = []
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
        
        createIndex()
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
        sectionHeaderView.backgroundColor = UIColor.systemGray6
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
            let buffer = friendsArray.filter{ (friend) -> Bool in
                friendIndex[section] == String(friend.lastName.first!)
            }
            return buffer.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell", for: indexPath) as! FriendsTableViewCell
        var dataFromArray: User
        if isFiltering {
            dataFromArray = searchedFriend[indexPath.row]
        } else {
            let buffer = friendsArray.filter{ (friend) -> Bool in
                friendIndex[indexPath.section] == String(friend.lastName.first!)
            }
            dataFromArray = buffer[indexPath.row]
        }
        cell.friendName.text = "\(dataFromArray.lastName) \(dataFromArray.name)"
        cell.friendImage.image = dataFromArray.image
        cell.friendLastSeen.text = "Last seen recently"
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
        searchedFriend = friendsArray.filter({ (i) -> Bool in return i.friendship == true }).filter({ (i) -> Bool in return (i.lastName.lowercased().contains(searchText.lowercased()) || i.name.lowercased().contains(searchText.lowercased())) })
        
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
        case "segueToPhotos":
            let photosCVC = segue.destination as! PhotosCollectionViewController
            photosCVC.title = "Photoflow"
            photosCVC.imageArray = [UIImage(named: "unknown"), UIImage(named: "musicGroup"), UIImage(named: "guy")]
        case "segueToPeople":
            print("Segue to People has been choosen.")
            return
        case "segueToFriendProfile":
            if let indexPath = friendsTableView.indexPathForSelectedRow {
                let friend: User
                if isFiltering {
                    friend = searchedFriend[indexPath.row]
                 } else {
                    let buffer = friendsArray.filter{ (friend) -> Bool in
                        friendIndex[indexPath.section] == String(friend.lastName.first!)
                    }
                    friend = buffer[indexPath.row]
                 }
                
//                let buffer = friendsArray.filter{ (friend) -> Bool in
//                    friendIndex[indexPath.section] == String(friend.lastName.first!)
//                }
//                friend = buffer[indexPath.row]
                
                let friendProfileVC = segue.destination as! FriendProfileViewController
                friendProfileVC.title = "\(friend.lastName) \(friend.name)"
            }
        default:
            print("ERROR - NAVIGATION: Unknown segue from FriendsTableViewController.")
            return
        }
        
    }
    
}
