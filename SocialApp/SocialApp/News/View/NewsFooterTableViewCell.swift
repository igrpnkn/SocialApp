//
//  NewsFooterTableViewCell.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 18.10.2020.
//

import UIKit

class NewsFooterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var reviewCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(likes: Int?, comments: Int?, reviews: Int?, userLiked: Int?) {
        if let likes = likes {
            self.likeCount.text = String(likes)
        }
        if let comments = comments {
            self.commentCount.text = String(comments)
        }
        if let reviews = reviews {
            self.reviewCount.text = String(reviews)
        }
        if userLiked == 1 {
            self.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            self.likeButton.tintColor = UIColor.systemRed
            self.likeButton.animationOfPulsation()
        } else if userLiked == 0 {
            self.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            self.likeButton.tintColor = UIColor.label
        }
    }
    
}
