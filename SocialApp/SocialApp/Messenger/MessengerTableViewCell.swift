//
//  MessengerTableViewCell.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 13.10.2020.
//

import UIKit

class MessengerTableViewCell: UITableViewCell {

    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var friendMessege: UILabel!
    @IBOutlet weak var friendLastSeen: UILabel!
    @IBOutlet weak var friendReadLabel: UIImageView!
    @IBOutlet weak var friendActiveness: UIImageView!
    @IBOutlet weak var friendMessageStatus: MessageStatusView!
    @IBOutlet weak var friendMessageCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
