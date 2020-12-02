//
//  FullScreenViewController.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 26.10.2020.
//

import UIKit

class FullScreenViewController: UIViewController {

    @IBOutlet weak var fullScreenCollectionView: UICollectionView!
    
    let reuseIdentifier = "FullScreenCollectionViewCell"
    var photoArray: [UIImage?] = []
    var indexPath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullScreenCollectionView.delegate = self
        fullScreenCollectionView.dataSource = self
        self.navigationController?.hidesBarsOnTap = true
        self.navigationController?.isNavigationBarHidden = true
//        self.navigationController?.navigationBar.barTintColor = .black
//        self.navigationController?.navigationBar.isTranslucent = false
        
        fullScreenCollectionView.performBatchUpdates(nil) { (result) in
            self.fullScreenCollectionView.scrollToItem(at: self.indexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.hidesBarsOnTap = false
        self.navigationController?.isNavigationBarHidden = false
//        self.navigationController?.navigationBar.barTintColor = .white
//        self.navigationController?.navigationBar.isTranslucent = true
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

extension FullScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FullScreenCollectionViewCell
        if let image = photoArray[indexPath.item] {
            cell.fullScreenImageView.image = image
        }
        cell.fullScreenImageView.contentMode = .scaleAspectFit
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height)
    }
}
