//
//  NewsMediaTableViewCell.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 18.10.2020.
//

import UIKit

class NewsMediaTableViewCell: UITableViewCell {

    @IBOutlet weak var mediaCollectionView: UICollectionView!
    
    let reuseMediaIdentifier = "NewsMediaCollectionViewCell"
    var imagesArray: [Data]? = nil
    var imagesCount: Int {
        return imagesArray?.count ?? 0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mediaCollectionView.delegate = self
        mediaCollectionView.dataSource = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension NewsMediaTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let _ = imagesArray {
            return imagesArray!.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseMediaIdentifier, for: indexPath) as! NewsMediaCollectionViewCell
        if let image = imagesArray?[indexPath.item] {
            cell.newsMediaPhoto.image = UIImage(data: image)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch imagesCount {
        case 0:
            return CGSize(width: 0, height: 0)
        case 1:
            return CGSize(width: self.bounds.width, height: self.bounds.width)
        default:
            let countCells: CGFloat = 2.0
            let offset: CGFloat = 2.0
            let frameCV = collectionView.frame
            let widthCell = frameCV.width / countCells
            let heightCell = widthCell
            let spacing = (countCells + 1.0) * offset / countCells
            return CGSize(width: widthCell - spacing, height: heightCell - (offset*2))
        }
    }
}
