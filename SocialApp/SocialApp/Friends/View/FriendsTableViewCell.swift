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
    
    func configureCell(fullName: String, lastSeen: Int?, occupation: String?, avatar: UIImage?, online: Int?) {
        self.friendName.text = fullName
        self.friendImage.image = avatar ?? UIImage(named: "camera")
        self.friendOccupation.text = occupation ?? ""
        
        switch online {
        case 1:
            self.friendLastSeen.text = "Online"
            self.friendLastSeen.textColor = .systemGreen
        default:
            if let lastSeenTime = lastSeen {
                let date = Date(timeIntervalSince1970: Double(lastSeenTime))
                let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
                dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
                dateFormatter.timeZone = .current
                let localDate = dateFormatter.string(from: date)
                self.friendLastSeen.text = "Last seen " + String(localDate)
                self.friendLastSeen.textColor = .systemGray
            } else {
                self.friendLastSeen.text = "Deleted or banned profile"
            }
        }
    }
    
}
