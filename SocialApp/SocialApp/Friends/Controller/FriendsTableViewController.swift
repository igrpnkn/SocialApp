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
    
    // Downloaded objects
    //var friends: Results<Friend>? = RealmManager.friendsGetFromRealm()
    //var realmToken: NotificationToken?
    
    var friendsAdapter = FriendViewModelAdapter()
    var friends: [FriendViewModel] = []
    
    // Search...
    var searchedFriend: [FriendViewModel] = []
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
        
        setupRefreshControl()
        startActivityIndicator()
        
        // adapter way
        friendsAdapter.getFriendCollection { [weak self] (friends) in
            guard let self = self else { return }
            self.friends = friends
            self.friendsTableView.reloadData()
            self.stopActivityIndicator()
        }
        
        // classic way
        //downloadUserFriends()
        
        // operation way
        //downloadUserFriendsWithOperations()
        
        // realm token onservation
        //observeRealmFriendsCollection()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
        //return friendIndex.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return searchedFriend.count
        } else {
            return friends.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell", for: indexPath) as! FriendsTableViewCell
        var dataFromArray: FriendViewModel
        if isFiltering {
            dataFromArray = searchedFriend[indexPath.row]
        } else {
            dataFromArray = friends[indexPath.row]
        }
        cell.configureCell(for: dataFromArray)
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
        searchedFriend = friends.filter({ (i) -> Bool in return (i.lastName.lowercased().contains(searchText.lowercased()) || i.firstName.lowercased().contains(searchText.lowercased())) })
        friendsTableView.reloadData()
    }
    
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
                let friend: FriendViewModel
                let friendsArray = self.friends
                if isFiltering {
                    friend = searchedFriend[indexPath.row]
                 } else {
                    friend = friendsArray[indexPath.row]
                 }
                let friendProfileVC = segue.destination as! FriendsProfileTableViewController
                //friendProfileVC.friendProfile = friend
            }
        default:
            print("ERROR - NAVIGATION: Unknown segue from FriendsTableViewController.")
            return
        }
    }
    
}

extension FriendsTableViewController {
    /*
    func observeRealmFriendsCollection() {
        self.realmToken = friends?.observe(on: DispatchQueue.main, { (changes: RealmCollectionChange) in
            switch changes {
            case .initial(let results):
                print("\nINFO: Realm Friends data has been initiated: \(results)")
                self.friends = results
                self.friendsTableView.reloadData()
                self.stopActivityIndicator()
            case .update(let results, let deletions, let insertions, let modifications):
                self.friendsTableView.beginUpdates()
                self.friendsTableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)
                }), with: .automatic)
                self.friendsTableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                self.friendsTableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                self.friendsTableView.endUpdates()
                self.stopActivityIndicator()
            case .error(let error):
                print("\nINFO: Realm friends.observe{} error: \(error.localizedDescription)")
                let alert = UIAlertController(title: "ERROR", message: "Connection to the server is not available. Please, check Wi-Fi or Internet settings.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    */
    func downloadUserFriends() {
        NetworkManager.friendsGet(for: UserSession.instance.userId!) { [weak self] friends in
            guard let self = self, let friendsArray = friends  else { return }
            RealmManager.deleteAllFriendsObject() // is used to resolve logical conflict when we have deleted Friend in vk.com but in RealmDB it still is there
            RealmManager.saveGotFriendsInRealm(friends: friendsArray)
            self.downloadAvatars()
        }
    }
    
    func downloadUserFriendsWithOperations() {
        //self.refreshControl?.beginRefreshing()
        let operationQueue = OperationQueue()
        
        let request = NetworkManager.biuldRequest()
        let networkOperation = NetworkOperation.init(request: request)
        
        let parsingOperation = ParsingOperation()
        parsingOperation.addDependency(networkOperation)
        
        let savingOperation = SavingOperation()
        savingOperation.addDependency(parsingOperation)
        
        let downladingAvatarsOperation = DownloadingAvatarsOperation()
        downladingAvatarsOperation.addDependency(savingOperation)
        
        operationQueue.addOperation(networkOperation)
        operationQueue.addOperation(parsingOperation)
        OperationQueue.main.addOperation(savingOperation)
        OperationQueue.main.addOperation(downladingAvatarsOperation)
        //self.refreshControl?.endRefreshing()
    }
    
    func downloadAvatars() {
        AvatarDownloader().downloadForType(objects: friends, objectType: .friend)
        self.stopActivityIndicator()
    }
    
    func startActivityIndicator() {
        print("\nINFO: Loading \(self.description) has begun.")
        activityIndicator.center.x = (self.navigationController?.navigationBar.center.x)!
        activityIndicator.center.y = (self.navigationController?.navigationBar.center.y)!*0.75
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        self.navigationController?.view.addSubview(activityIndicator)
    }
    
    func stopActivityIndicator() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
    }
    
    override func refreshData() {
        self.refreshControl?.beginRefreshing()
        downloadUserFriendsWithOperations()
        print("\nINFO: \(#function) : Data refreshing...")
        refreshControl?.endRefreshing()
    }
    
}
