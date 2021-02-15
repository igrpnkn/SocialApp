//
//  FriendsProfileTableViewController.swift
//  SocialApp
//
//  Created by developer on 15.02.2021.
//

import Foundation

import UIKit

class FriendsProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var friendProfileTableView: UITableView!
    let activityIndicator = UIActivityIndicatorView()
    
    var friendProfile: Friend?
    let titles = [ "Photoflow", "Friends", "Communities" ]
    let titleIcons = [ "photo.on.rectangle", "person.fill", "person.3.fill" ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = .clear
        friendProfileTableView.dataSource = self
        friendProfileTableView.delegate = self
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        self.title = "\(friendProfile?.lastName ?? "Profile") \(friendProfile?.firstName ?? "unavailable")"
        
        print("\nINFO: FriendProfileTableViewController.viewDidLoad()\n")
        
        startActivityIndicator()
        downloadProfilePhoto()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
}

extension FriendsProfileTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < 2 {
            return 1
        } else {
            return titles.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return tableView.bounds.width
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let photoflowViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PhotoflowViewController") as! PhotoflowViewController
            photoflowViewController.modalPresentationStyle = .fullScreen
            photoflowViewController.userId = friendProfile?.id
            photoflowViewController.title = "Profile photos"
            self.navigationController?.pushViewController(photoflowViewController, animated: true)
        }
    }
}

extension FriendsProfileTableViewController {
    
    func downloadProfilePhoto() {
        guard let photoURL = friendProfile?.photoMax else {
            print("\nERROR - DOWNLOADING PROFILE PHOTO: Breaken URL while downloading \(friendProfile?.domain ?? "UNKNOWN's") main photo.")
            self.stopActivityIndicator()
            return
        }
        DispatchQueue.main.async {
            if let url = URL(string: photoURL) {
                guard let data = try? Data(contentsOf: url) else { return }
                self.friendProfile?.avatarMax = UIImage(data: data) ?? UIImage(named: "camera")!
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
    
}
