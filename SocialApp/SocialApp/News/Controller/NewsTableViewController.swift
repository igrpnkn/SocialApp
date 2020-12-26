//
//  NewsTableViewController.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 18.10.2020.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    let reuseHeaderIdentifier = "NewsHeaderTableViewCell"
    let reuseTextIdentifier = "NewsTextTableViewCell"
    let reuseMediaIdentifier = "NewsMediaTableViewCell"
    let reuseFooterIdentifier = "NewsFooterTableViewCell"
    
    @IBOutlet weak var newsTableView: UITableView!
    
    var newsArray: [News] = NewsDataBase.instance.item
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableView.delegate = self
        newsTableView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return newsArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 14))
        sectionHeaderView.backgroundColor = UIColor.systemGray6
        return sectionHeaderView
    }
    
    /*
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 16))
        sectionFooterView.backgroundColor = UIColor.systemGray6
        return sectionFooterView
    }
    */
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseHeaderIdentifier, for: indexPath) as! NewsHeaderTableViewCell
            cell.avatar.image = newsArray[indexPath.section].avatar
            cell.author.text = newsArray[indexPath.section].author
            cell.time.text = newsArray[indexPath.section].time
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseTextIdentifier, for: indexPath) as! NewsTextTableViewCell
            cell.postedText.text = newsArray[indexPath.section].text!
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseMediaIdentifier, for: indexPath) as! NewsMediaTableViewCell
            cell.imagesArray = newsArray[indexPath.section].images
            cell.mediaCollectionView.reloadData()
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseFooterIdentifier, for: indexPath) as! NewsFooterTableViewCell
            cell.likeCount.text = String(newsArray[indexPath.section].likeCount!)
            cell.commentCount.text = String(newsArray[indexPath.section].commentCount!)
            cell.reviewCount.text = String(newsArray[indexPath.section].reviewCount!)
            cell.likeButton.tag = indexPath.section
            if newsArray[indexPath.section].liked == true {
                cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                cell.likeButton.tintColor = UIColor.systemRed
                cell.likeButton.animationOfPulsation()
            } else if newsArray[indexPath.section].liked == false {
                cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                cell.likeButton.tintColor = UIColor.label
            }
            return cell
        default:
            print("What the hell was here!? o_O")
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseMediaIdentifier, for: indexPath) as! NewsMediaTableViewCell
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 2:
            if 0 == newsArray[indexPath.section].images?.count ?? 0 {
                return 0
            } else if 1 == newsArray[indexPath.section].images?.count ?? 0 {
                return tableView.frame.width
            } else {
                return tableView.frame.width/2
            }
        default:
            return tableView.estimatedRowHeight
        }
    }
    
    @IBAction private func likeButtonPressed(_ sender: UIButton) {
        print("Button LIKE in \(sender.tag) section of NEWSFEED has been pressed!")
        switch newsArray[sender.tag].liked {
        case true:
            print("Post is being disliked!")
            newsArray[sender.tag].likeCount! -= 1
            NewsDataBase.instance.item[sender.tag].likeCount! -= 1
            if newsArray[sender.tag].likeCount! == NewsDataBase.instance.item[sender.tag].likeCount! {
                newsArray[sender.tag].liked = false
                NewsDataBase.instance.item[sender.tag].liked = false
            } else {
                print("Disliking failed!")
            }
            if newsArray[sender.tag].liked == NewsDataBase.instance.item[sender.tag].liked {
                print("Disliking succeeded!")
                self.newsTableView.reloadData()
            } else {
                print("Disliking failed!")
            }
        case false:
            print("Post is being liked!")
            newsArray[sender.tag].likeCount! += 1
            NewsDataBase.instance.item[sender.tag].likeCount! += 1
            if newsArray[sender.tag].likeCount! == NewsDataBase.instance.item[sender.tag].likeCount! {
                newsArray[sender.tag].liked = true
                NewsDataBase.instance.item[sender.tag].liked = true
            } else {
                print("Liking failed!")
            }
            if newsArray[sender.tag].liked == NewsDataBase.instance.item[sender.tag].liked {
                print("Liking succeeded!")
                self.newsTableView.reloadData()
            } else {
                print("Liking failed!")
            }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

