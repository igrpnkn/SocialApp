//
//  FriendProfileDetailsTableViewCell.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 24.10.2020.
//

import UIKit

class FriendProfileDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var idProfile: UILabel!
    @IBOutlet weak var birthday: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var work: UILabel!
    @IBOutlet weak var marriage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
