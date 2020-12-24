//
//  GroupsTableViewCell.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 05.10.2020.
//

import UIKit

class GroupsTableViewCell: UITableViewCell {

    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupFollowers: UILabel!
    @IBOutlet weak var groupSubscription: UIImageView!
    @IBOutlet weak var groupDescription: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(name: String, image: Data?, followersCount: Int?, activity: String?) {
        self.groupName.text = name
        self.groupFollowers.text = String(followersCount!) + " subscribers"
        self.groupDescription.text = activity
        self.groupSubscription.isHidden = false
        if let image = image {
            self.groupImage.image = UIImage(data: image)
        }
    }

}
