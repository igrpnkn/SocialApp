//
//  MessengerTableViewController.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 13.10.2020.
//

import UIKit

class MessengerTableViewController: UITableViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var messengerTableView: UITableView!
    
    let reusableCell = "MessengerTableViewCell"
    var friendsArray: [User] = [
        User(name: "Johnny", lastName: "Appleseed", image: UIImage(named: "guy")!, age: 18, friendship: true),
        User(name: "Bobby", lastName: "Axelroude", image: UIImage(named: "guy")!, age: 18, friendship: true),
        User(name: "Michael", lastName: "Composer", image: UIImage(named: "guy")!, age: 18, friendship: true),
        User(name: "Bob", lastName: "Dommergoo", image: UIImage(named: "guy")!, age: 18, friendship: true),
        User(name: "Micky", lastName: "Fiedgerald", image: UIImage(named: "guy")!, age: 18, friendship: true),
        User(name: "Tom", lastName: "Hawkins", image: UIImage(named: "guy")!, age: 18, friendship: true),
        User(name: "Alex", lastName: "Burntman", image: UIImage(named: "guy")!, age: 18, friendship: true),
        User(name: "Mike", lastName: "Rouhgeman", image: UIImage(named: "guy")!, age: 18, friendship: true),
        User(name: "Rashid", lastName: "Daddario", image: UIImage(named: "guy")!, age: 18, friendship: true),
        User(name: "Jude", lastName: "Chappman", image: UIImage(named: "guy")!, age: 18, friendship: true),
        User(name: "Alexander", lastName: "Cross", image: UIImage(named: "guy")!, age: 18, friendship: true)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.messengerTableView.delegate = self
        self.messengerTableView.dataSource = self
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        let searchBar = UISearchController(searchResultsController: nil)
        searchBar.searchResultsUpdater = self
        self.navigationItem.searchController = searchBar

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friendsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableCell, for: indexPath) as! MessengerTableViewCell
        
        cell.friendImage.image = UIImage(named: "guy")
        //cell.friendImage.layer.cornerRadius = cell.friendImage.bounds.width / 2
        cell.friendName.text = friendsArray[indexPath.row].lastName + " " + friendsArray[indexPath.row].name
        cell.friendLastSeen.text = "10:08"
        cell.friendMessege.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        cell.friendReadLabel.image = UIImage(systemName: "eye.fill")
        cell.friendActiveness.image = UIImage(systemName: "circle.fill")?.withTintColor(.systemGreen)
        cell.friendMessageStatus.layer.backgroundColor = UIColor.systemBlue.cgColor
        cell.friendMessageCount.text = "123"
        cell.friendMessageCount.isHidden = false
        cell.friendReadLabel.isHidden = true
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            friendsArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text!)
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
