//
//  FriendsTableViewCell.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 05.10.2020.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var friendLastSeen: UILabel!
    @IBOutlet weak var friendOccupation: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(fullName: String, lastSeen: Int?, occupation: String?) {
        self.friendName.text = fullName
        //self.friendImage.image = image
        if let lastSeenTime = lastSeen {
            self.friendLastSeen.text = String(lastSeenTime)
        } else {
            self.friendLastSeen.text = "Deleted or banned"
        }
        self.friendOccupation.text = occupation ?? ""
    }
    
}
