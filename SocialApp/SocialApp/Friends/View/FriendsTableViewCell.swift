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
    
    func configureCell(for viewModel: FriendViewModel) {
        self.friendName.text = viewModel.lastName + " " + viewModel.firstName
        self.friendOccupation.text = viewModel.occupationName
        self.friendImage.image = viewModel.avatar
        switch viewModel.online {
        case 1:
            self.friendLastSeen.text = "Online"
            self.friendLastSeen.textColor = .systemGreen
        default:
            if let lastSeenTime = viewModel.lastSeen {
                self.friendLastSeen.text = "Last seen " + DateFormatter.shared.string(from: Date(timeIntervalSince1970: Double(lastSeenTime)))
                self.friendLastSeen.textColor = .systemGray
            } else {
                self.friendLastSeen.text = "Deleted or banned profile"
            }
        }
    }
    
}
