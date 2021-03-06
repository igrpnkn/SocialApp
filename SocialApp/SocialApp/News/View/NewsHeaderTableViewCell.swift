//
//  NewsHeaderTableViewCell.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 18.10.2020.
//

import UIKit

class NewsHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.avatar.image = UIImage(named: "camera")
        DateFormatter.shared.setCommonFormat()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(avatar: Data?, author: String?, time: Int?) {
        if let author = author {
            self.author.text = author
        }
        if let avatar = avatar {
            self.avatar.image = UIImage(data: avatar)
        }
        if let time = time {
            self.time.text = "Posted " + DateFormatter.shared.string(from: Date(timeIntervalSince1970: Double(time)))
        }
    }
    
}
