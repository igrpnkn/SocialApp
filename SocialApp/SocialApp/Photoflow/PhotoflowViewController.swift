//
//  PhotoflowViewController.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 25.10.2020.
//

import UIKit

class PhotoflowViewController: UIViewController {

    @IBOutlet weak var photoflowCollectionView: UICollectionView!
    
    let reuseIdentifier = "PhotoflowCollectionViewCell"
    var photoArray: [UIImage?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoflowCollectionView.dataSource = self
        photoflowCollectionView.delegate = self
        for i in 0...10 {
            photoArray.append(UIImage(named: "guy\(i)"))
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension PhotoflowViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photoflowCollectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoflowCollectionViewCell
        let image = photoArray[indexPath.item]
        cell.photoflowImage.image = image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let countCells: CGFloat = 3.0
        let offset: CGFloat = 2.0
        let frameCV = collectionView.frame
        let widthCell = frameCV.width / countCells
        let heightCell = widthCell
        let spacing = (countCells + 1.0) * offset / countCells
        return CGSize(width: widthCell - spacing, height: heightCell - (offset*2))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "FullScreenViewController") as! FullScreenViewController
        vc.photoArray = photoArray
        vc.indexPath = indexPath
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
