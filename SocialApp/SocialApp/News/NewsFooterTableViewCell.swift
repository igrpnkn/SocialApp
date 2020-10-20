//
//  NewsFooterTableViewCell.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 18.10.2020.
//

import UIKit

class NewsFooterTableViewCell: UITableViewCell {
    
    @IBAction func pressedLike(_ sender: Any) {
        print("Button LIKE pressed!!!")
    }
    
    @IBAction func pressedComment(_ sender: Any) {
        print("Button COMMENT pressed!!!")
    }
    
    @IBAction func pressedForward(_ sender: Any) {
        print("Button FORWARD pressed!!!")
    }
    
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

}
