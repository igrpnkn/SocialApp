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
    var photoArray: [Photoflow] = []
    var indexPath: IndexPath?
    var statusBarIsHidden: Bool = true
    override var prefersStatusBarHidden: Bool {
            return statusBarIsHidden
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullScreenCollectionView.delegate = self
        fullScreenCollectionView.dataSource = self
        self.navigationController?.hidesBarsOnTap = true
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.isTranslucent = true
        
        fullScreenCollectionView.performBatchUpdates(nil) { (result) in
            self.fullScreenCollectionView.scrollToItem(at: self.indexPath!, at: .centeredHorizontally, animated: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //super.viewWillDisappear(animated)
        self.navigationController?.hidesBarsOnTap = false
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = .systemGray6
        self.navigationController?.navigationBar.isTranslucent = true
        self.statusBarIsHidden = false
        self.setNeedsStatusBarAppearanceUpdate()
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
        if let data = photoArray[indexPath.item].data {
            cell.fullScreenImageView.image = UIImage(data: data)
        }
        cell.fullScreenImageView.contentMode = .scaleAspectFit
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height)
    }
}
