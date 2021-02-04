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
    
 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.scrollDirection = .horizontal
//        let flowLayoutWidth = mediaCollectionView.bounds.width/2
//        flowLayout.itemSize = CGSize(width: flowLayoutWidth, height: flowLayoutWidth)
//        flowLayout.minimumLineSpacing = 5.0
//        flowLayout.minimumInteritemSpacing = 1.0
//        self.mediaCollectionView.collectionViewLayout = flowLayout
        
        mediaCollectionView.delegate = self
        mediaCollectionView.dataSource = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    func setImagesArray(images: [UIImage]?) {
//        self.imagesArray = images
//    }
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
        //cell.frame.size.height = collectionView.frame.height
        //cell.frame.size.width = cell.frame.height
//        if let image = imagesArray?[indexPath.item] {
//            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
//            imageView.image = image
//            //imageView.frame = cell.bounds
//            imageView.contentMode = .scaleAspectFill
//            cell.addSubview(imageView)
//        }
        if let image = imagesArray?[indexPath.item] {
            cell.newsMediaPhoto.image = UIImage(data: image)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        var offset: CGFloat = 1.0
//        var countCells: Int = 1
//        let cellHeight = collectionView.frame.height / CGFloat(countCells)
//        let cellWidth = cellHeight
//        let spacing = CGFloat(countCells + 1) * offset / CGFloat(countCells)
//        return CGSize(width: cellWidth - spacing, height: cellHeight - offset)
        let countCells: CGFloat = 2.0
        let offset: CGFloat = 2.0
        let frameCV = collectionView.frame
        let widthCell = frameCV.width / countCells
        let heightCell = widthCell
        let spacing = (countCells + 1.0) * offset / countCells
        return CGSize(width: widthCell - spacing, height: heightCell - (offset*2))
    }
}
