//
//  GroupsSearchTableViewCell.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 06.10.2020.
//

import UIKit

class GroupsSearchTableViewCell: UITableViewCell {

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

}
