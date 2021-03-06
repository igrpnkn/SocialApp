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
    var realmToken: NotificationToken?
    
    var statusBarIsHidden: Bool = false
    override var prefersStatusBarHidden: Bool {
            return statusBarIsHidden
        }
    
    let reuseIdentifier = "PhotoflowCollectionViewCell"
    var photoflow: Results<Photoflow>?
    var photoMetaData: Results<Photo>?
    //var photoArray: [UIImage?] = []
    var userId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        photoflowCollectionView.frame.size = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
        photoflowCollectionView.dataSource = self
        photoflowCollectionView.delegate = self
        print("\nINFO: PhotoflowViewController.viewDidLoad()")
        
        self.photoMetaData = RealmManager.getPhotosMetaData(for: self.userId!)
        self.photoflow = RealmManager.getPhotoflow(userID: self.userId!)
        startActivityIndicator()
        observeRealmPhotoflowCollection()
        downloadPhotoMetaData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
}

extension PhotoflowViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoflow!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photoflowCollectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoflowCollectionViewCell
        if let data = self.photoflow![indexPath.item].data {
            cell.photoflowImage.image = UIImage(data: data)
        }
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
        vc.photoArray = Array(self.photoflow!)
        vc.indexPath = indexPath
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension PhotoflowViewController {
    
    func observeRealmPhotoflowCollection() {
        self.realmToken = photoflow?.observe(on: DispatchQueue.main, { (changes: RealmCollectionChange) in
            switch changes {
            case .initial(let results):
                self.photoflow = results
                self.photoflowCollectionView.reloadData()
            case .update(let results, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                self.photoflowCollectionView.performBatchUpdates({
                    self.photoflowCollectionView.reloadItems(at: modifications.map { IndexPath(item: $0, section: 0) })
                    self.photoflowCollectionView.insertItems(at: insertions.map { IndexPath(item: $0, section: 0) })
                    self.photoflowCollectionView.deleteItems(at: deletions.map { IndexPath(item: $0, section: 0) })
                }, completion: nil)
            case .error(let error):
                print("\nINFO: Realm Photoflow.observe{} error: \(error.localizedDescription)")
                let alert = UIAlertController(title: "ERROR", message: "Connection to the server is not available. Please, check Wi-Fi or Internet settings.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    func downloadPhotoMetaData() {
        DispatchQueue.global().async {
            NetworkManager.photosGetForProfile(for: self.userId!) { photoMetaData in
                DispatchQueue.main.async {
                    guard let photoMetaData = photoMetaData else { return }
                    RealmManager.savePhotosMetaData(save: photoMetaData, for: self.userId!)
                    self.downloadPhotos()
                }
            }
        }
    }
    
    func downloadPhotos() {
        for photo in Array(self.photoMetaData!) {
            let size = photo.sizes.filter { (size) -> Bool in
                return size.type == "x"
            }
            guard let photoURL = size.first?.url,
                  let url = URL(string: photoURL)
            else {
                return
            }
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        RealmManager.savePhotoflow(photoID: photo.id, ownerID: photo.owner_id, data: data)
                    }
                }
                print("Photo downloaded: \(url)")
            }
        }
        print("\nINFO: All photos are downloaded.")
        print("\nINFO: TableView is reload from PhotoflowViewController.downloadPhotos() method.")
        self.photoflowCollectionView.reloadData()
        stopActivityIndicator()
    }

    func startActivityIndicator() {
        print("\nINFO: Loading \(self.description) has begun.")
        activityIndicator.center.x = (self.navigationController?.navigationBar.center.x)!
        activityIndicator.center.y = (self.navigationController?.navigationBar.center.y)!*0.75
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        self.navigationController?.view.addSubview(activityIndicator)
    }
    
    func stopActivityIndicator() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        print("\nINFO: Activity indicator is hidden.")
    }
    
}
