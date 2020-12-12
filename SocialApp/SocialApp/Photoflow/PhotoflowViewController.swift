//
//  PhotoflowViewController.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 25.10.2020.
//

import UIKit
import RealmSwift

class PhotoflowViewController: UIViewController {

    @IBOutlet weak var photoflowCollectionView: UICollectionView!
    let activityIndicator = UIActivityIndicatorView()
    
    let reuseIdentifier = "PhotoflowCollectionViewCell"
    var photoflow: [Photo] = RealmManager.photosGetFromRealm() ?? []
    var photoArray: [UIImage?] = []
    var userId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoflowCollectionView.frame.size = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
        photoflowCollectionView.dataSource = self
        photoflowCollectionView.delegate = self
        startActivityIndicator()
        
        //RealmManager.deleteAllPhotosObject()
        if self.photoflow.isEmpty {
            downloadPhotoflow()
            print("\nINFO: PhotoflowViewController.viewDidLoad()")
            print("\nINFO: Photoflow was loaded from Internet.")
        }
        else {
            self.downloadPhotos()
            print("\nINFO: Photos were loaded from Realm.\n")
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

extension PhotoflowViewController {
    
    func downloadPhotoflow() {
        NetworkManager.photosGetForProfile(for: userId!) { [weak self] photoflow in
            DispatchQueue.main.async {
                guard let self = self, let photoflow = photoflow else { return }
                self.photoflow = photoflow
                RealmManager.saveGotPhotosInRealm(photos: self.photoflow)
                //print(self.photoData.map { $0.type } )
                //print("\nINFO: TableView is reload from NetworkManager.friendsGet(for:) closure.")
                self.downloadPhotos()
            }
        }
    }
    
    func downloadPhotos() {
        //DispatchQueue.main.async {
        for photo in self.photoflow {
            let size = photo.sizes.filter { (size) -> Bool in
                return size.type == "x"
            }
            guard let photoURL = size.first?.url else {
                return
            }
            if let url = URL(string: photoURL) {
                guard let data = try? Data(contentsOf: url) else { return }
                photoArray.append(UIImage(data: data))
                print("Photo downloaded: \(url)")
            }
        }
        self.photoflowCollectionView.reloadData()
        print("\nINFO: TableView is reload from PhotoflowViewController.downloadPhotos() method.")
        stopActivityIndicator()
        print("\nINFO: All photos are downloaded.")
        print("\nINFO: Activity indicator is hidden.")
        //}
    }

    func startActivityIndicator() {
        activityIndicator.center.x = self.view.center.x
        activityIndicator.center.y = self.view.frame.width / 2
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        self.view.addSubview(activityIndicator)
    }
    
    func stopActivityIndicator() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
    }
    
}
