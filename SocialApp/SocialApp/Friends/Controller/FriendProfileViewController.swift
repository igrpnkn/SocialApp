//
//  FriendProfileViewController.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 16.10.2020.
//

import UIKit

class FriendProfileViewController: UIViewController  {
    
    @IBOutlet weak var friendProfileTableView: UITableView!
    let activityIndicator = UIActivityIndicatorView()
    
    var friendProfile: Friend?
    let titles = [ "Photoflow", "Friends", "Communities" ]
    let titleIcons = [ "photo.on.rectangle", "person.fill", "person.3.fill" ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendProfileTableView.dataSource = self
        friendProfileTableView.delegate = self
//        self.navigationController?.navigationBar.prefersLargeTitles = true
//        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        self.title = "\(friendProfile?.lastName ?? "Profile") \(friendProfile?.firstName ?? "unavailable")"
        
        print("\nINFO: FriendProfileTableViewController.viewDidLoad()\n")
        
        startActivityIndicator()
        downloadProfilePhoto()
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
            cell.photoImage.image = friendProfile?.avatarMax
            cell.frame.size.height = cell.bounds.width
            return cell
        case 1:
            let cell = friendProfileTableView.dequeueReusableCell(withIdentifier: "FriendProfileDetailsTableViewCell", for: indexPath) as! FriendProfileDetailsTableViewCell
            cell.configureCell(status: friendProfile?.status, id: friendProfile?.id, birthday: friendProfile?.bdate, city: friendProfile?.city, country: friendProfile?.country, occupation: friendProfile?.occupationName, relation: friendProfile?.relation)
            return cell
        default:
            let cell = friendProfileTableView.dequeueReusableCell(withIdentifier: "FriendProfileTableViewCell", for: indexPath) as! FriendProfileTableViewCell
            cell.icon.image = UIImage(systemName: titleIcons[indexPath.row])
            cell.title.text = titles[indexPath.row]
            cell.subTitle.text = "more"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let photoflowViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PhotoflowViewController") as! PhotoflowViewController
            photoflowViewController.modalPresentationStyle = .fullScreen
            photoflowViewController.userId = friendProfile?.id
            self.navigationController?.pushViewController(photoflowViewController, animated: true)
        }
    }
}

extension FriendProfileViewController {
    
    func downloadProfilePhoto() {
        guard let photoURL = friendProfile?.photoMax else {
            print("\nERROR - DOWNLOADING PROFILE PHOTO: Breaken URL while downloading \(friendProfile?.domain ?? "UNKNOWN's") main photo.")
            friendProfile?.avatar = UIImage(named: "camera")
            self.stopActivityIndicator()
            return
        }
        DispatchQueue.main.async {
            if let url = URL(string: photoURL) {
                guard let data = try? Data(contentsOf: url) else { return }
                self.friendProfile?.avatarMax = UIImage(data: data)
                print("Photo downloaded: \(url)")
                self.stopActivityIndicator()
            }
            self.stopActivityIndicator()
            self.friendProfileTableView.reloadData()
            print("\nINFO: TableView is reload from FriendsTableViewController.downloadAvatars() func.")
            print("\nAll photos is downloaded...")
            print("\nActivity indicator is hidden...")
        }
    }

    func startActivityIndicator() {
        activityIndicator.center.x = self.view.center.x
        activityIndicator.center.y = self.view.frame.width / 2
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
