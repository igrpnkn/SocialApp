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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
