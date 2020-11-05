//
//  FriendProfileViewController.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 16.10.2020.
//

import UIKit

class FriendProfileViewController: UIViewController  {
    
    @IBOutlet weak var friendProfileTableView: UITableView!
    
    let titles = [ "Photoflow", "Friends", "Communities" ]
    let titleIcons = [ "photo.on.rectangle", "person.fill", "person.3.fill" ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendProfileTableView.dataSource = self
        friendProfileTableView.delegate = self
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension FriendProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < 2 {
            return 1
        } else {
            return titles.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = friendProfileTableView.dequeueReusableCell(withIdentifier: "FriendProfileAvatarTableViewCell", for: indexPath) as! FriendProfileAvatarTableViewCell
            cell.photoImage.image = UIImage(named: "guy")
            cell.frame.size.width = cell.frame.height
            return cell
        case 1:
            let cell = friendProfileTableView.dequeueReusableCell(withIdentifier: "FriendProfileDetailsTableViewCell", for: indexPath) as! FriendProfileDetailsTableViewCell
            cell.status.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
            cell.idProfile.text = "id1223456789"
            cell.birthday.text = "31 декабря 1991 г."
            cell.city.text = "Moscow, Russian Federation"
            cell.work.text = "Softluxe JSC, Network Engineer"
            cell.marriage.text = "Single"
            return cell
        default:
            let cell = friendProfileTableView.dequeueReusableCell(withIdentifier: "FriendProfileTableViewCell", for: indexPath) as! FriendProfileTableViewCell
            cell.icon.image = UIImage(systemName: titleIcons[indexPath.row])
            cell.title.text = titles[indexPath.row]
            cell.subTitle.text = "123K"
            return cell
        }
    }
}
