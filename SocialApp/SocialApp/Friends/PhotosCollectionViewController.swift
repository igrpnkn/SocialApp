//
//  PhotosCollectionViewController.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 06.10.2020.
//

import UIKit

class PhotosCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    private let reuseIdentifier = "PhotosCollectionViewCell"
    let countCells: Int = 2
    let offset: CGFloat = 2.0
    
    var imageArray: [UIImage?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.hidesBackButton = false
        
        //self.collectionView!.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: "PhotosCollectionViewCell")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return imageArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotosCollectionViewCell
        
//        if let image = imageArray[indexPath.item] {
//            cell.photoImage.image = image
//            cell.photoView.contentMode = .scaleAspectFill
//        }
        
        if let image = imageArray[indexPath.item] {
            let imageView = UIImageView(image: image)
            imageView.frame = cell.bounds
            cell.addSubview(imageView)
        }
        
        return cell
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width / CGFloat(countCells)
        let cellHeight = cellWidth
        let spacing = CGFloat(countCells + 1) * offset / CGFloat(countCells)
        return CGSize(width: cellWidth - spacing, height: cellHeight - (offset*2))
        //return CGSize(width: cellWidth - spacing, height: cellHeight)
    }
} 

