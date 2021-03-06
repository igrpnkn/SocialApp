//
//  NewsMediaCollectionViewCell.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 19.10.2020.
//

import UIKit

class NewsMediaCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var newsMediaPhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        newsMediaPhoto.contentMode = .scaleAspectFill
    }
}
