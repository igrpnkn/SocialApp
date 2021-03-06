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
        DateFormatter.shared.setCommonFormat()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(fullName: String, lastSeen: Int?, occupation: String?, avatar: Data?, online: Int?) {
        self.friendName.text = fullName
        self.friendOccupation.text = occupation ?? ""
        if let avatar = avatar {
            self.friendImage.image = UIImage(data: avatar)
        }
        switch online {
        case 1:
            self.friendLastSeen.text = "Online"
            self.friendLastSeen.textColor = .systemGreen
        default:
            if let lastSeenTime = lastSeen {
                self.friendLastSeen.text = "Last seen " + DateFormatter.shared.string(from: Date(timeIntervalSince1970: Double(lastSeenTime)))
                self.friendLastSeen.textColor = .systemGray
            } else {
                self.friendLastSeen.text = "Deleted or banned profile"
            }
        }
    }
    
}
