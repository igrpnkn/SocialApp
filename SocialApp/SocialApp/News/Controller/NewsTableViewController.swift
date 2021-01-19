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
    
    var newsFeed: [News]? = []
    var newsFeedBiulder = NewsFeedBiulder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableView.delegate = self
        newsTableView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        //self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        downloadNews(fromNext: "")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return newsFeed?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 14))
        sectionHeaderView.backgroundColor = UIColor.systemGray5
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
        case 0: // Header
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseHeaderIdentifier, for: indexPath) as! NewsHeaderTableViewCell
            //let author = self.matchPostAuthor(authorID: newsFeed?.items?[indexPath.section].source_id, postSection: indexPath.section)
            cell.configureCell(avatar: newsFeed?[indexPath.section].avatar, author: newsFeed?[indexPath.section].author, time: newsFeed?[indexPath.section].time)
            return cell
        case 1: // Text
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseTextIdentifier, for: indexPath) as! NewsTextTableViewCell
            cell.configureCell(text: newsFeed?[indexPath.section].text)
            return cell
        case 2: // Photos
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseMediaIdentifier, for: indexPath) as! NewsMediaTableViewCell
            cell.imagesArray = newsFeed?[indexPath.section].photos
            cell.mediaCollectionView.reloadData()
            return cell
        case 3: // Footer
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseFooterIdentifier, for: indexPath) as! NewsFooterTableViewCell
            cell.configureCell(likes: newsFeed?[indexPath.section].likeCount, comments: newsFeed?[indexPath.section].commentCount, reviews: newsFeed?[indexPath.section].reviewCount, userLiked: newsFeed?[indexPath.section].liked)
            cell.likeButton.tag = indexPath.section
            return cell
        default:
            print("\nINFO: What the hell was here!? o_O\n")
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseHeaderIdentifier, for: indexPath) as! NewsHeaderTableViewCell
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 2:
            if 0 == newsFeed?[indexPath.section].photosURL?.count ?? 0 {
                return 0
            } else if 1 == newsFeed?[indexPath.section].photosURL?.count ?? 0 {
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
        if 1 == newsFeed?[sender.tag].liked ?? 0 {
            print("Post is being disliked!")
            newsFeed?[sender.tag].likeCount! -= 1
            newsFeed?[sender.tag].liked = 0
            self.newsTableView.reloadData()
        } else {
            print("Post is being liked!")
            newsFeed?[sender.tag].likeCount! += 1
            newsFeed?[sender.tag].liked = 1
            self.newsTableView.reloadData()
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

extension NewsTableViewController {
    
    func downloadNews(fromNext: String) {
        NetworkManager.newsfeedGet(for: UserSession.instance.userId!, nextFrom: fromNext, completion: { response in
            guard let response = response,
                  let posts = response.items
            else {
                print("\nINFO: ERROR - While getting respone objects in \(#function)\n")
                return
            }
            print("\nINFO: \(#function) has total parsed posts: \(posts.count)")
            self.biuldNewsFeed(newsFeed: response)
        })
    }
    
    func biuldNewsFeed(newsFeed response: PostResponse) {
        self.newsFeed = self.newsFeedBiulder.buildNewsFeed(parsedJSON: response)
        print("\nINFO: \(#function) has total built news: \(newsFeed?.count ?? 0)")
        self.newsTableView.reloadData()
        downloadMedia()
    }
    
    func downloadMedia() {
        DispatchQueue.global().async {
            print("\nINFO: \(#function) Starting downloading avatars.")
            for news in self.newsFeed! {
                if let url = URL(string: news.avatarURL!) {
                    if let data = try? Data(contentsOf: url) {
                        news.avatar = data
                    }
                }
            }
            DispatchQueue.main.async {
                print("\nINFO: \(#function) Reloading data after downloading avatars.")
                self.newsTableView.reloadData()
            }
        }
        
        DispatchQueue.global().async {
            print("\nINFO: \(#function) Starting downloading photos.")
            for news in self.newsFeed! {
                if let urlStrings = news.photosURL {
                    for urlString in urlStrings {
                        if let url = URL(string: urlString) {
                            if let data = try? Data(contentsOf: url) {
                                news.photos?.append(data)
                            }
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                print("\nINFO: \(#function) Reloading data after downloading photos.")
                self.newsTableView.reloadData()
            }
        }
        
    }
    
    /*
    func matchPostAuthor(authorID: Int?, postSection: Int) -> String? {
        guard let authorID = authorID else {
            print("\nINFO: ERROR - Unexpectedly nil in \(#function)\n")
            return nil
        }
        if authorID < 0 {
            let author = self.newsFeed?.groups?.filter({ $0.id == (-1 * authorID) })
            return author?.first?.name
        } else {
            let author = self.newsFeed?.profiles?.filter({ $0.id == authorID })
            return ((author?.first?.first_name ?? "") + " " + (author?.first?.last_name ?? ""))
        }
    }
    */
}
