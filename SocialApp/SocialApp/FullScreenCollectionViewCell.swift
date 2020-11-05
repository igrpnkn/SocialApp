//
//  FullScreenCollectionViewCell.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 26.10.2020.
//

import UIKit

class FullScreenCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    @IBOutlet weak var fullScreenImageView: UIImageView!
    @IBOutlet weak var scrollFullScreen: UIScrollView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.scrollFullScreen.delegate = self
        self.scrollFullScreen.minimumZoomScale = 1.0
        self.scrollFullScreen.maximumZoomScale = 3.0 
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
         return fullScreenImageView
    }
    
    // Uncomment to recover scroll when zoom ends
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollFullScreen.zoomScale = 1.0
    }
    
}
