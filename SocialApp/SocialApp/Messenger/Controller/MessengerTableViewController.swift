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
    
    var messagesArray: [Message] = MessagesService().getMessages()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messengerTableView.delegate = self
        self.messengerTableView.dataSource = self
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        let searchBar = UISearchController(searchResultsController: nil)
        searchBar.searchResultsUpdater = self
        self.navigationItem.searchController = searchBar
        self.messengerTableView.register(MessengerTableViewCell.self, forCellReuseIdentifier: reusableCell)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messagesArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableCell, for: indexPath) as! MessengerTableViewCell
        cell.configure(message: messagesArray[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(82)
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? MessengerTableViewCell {
            cell.animationOfTouchDown()
        }
    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? MessengerTableViewCell {
            cell.animationOfTouchUp()
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            messagesArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .none:
            print("\nINFO: Table was edited with .none :)")
        case .insert:
            messagesArray.append(messagesArray[indexPath.row])
            tableView.insertRows(at: [indexPath], with: .fade)
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
