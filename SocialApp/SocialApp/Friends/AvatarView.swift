//
//  AvatarView.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 09.10.2020.
//

import UIKit

class AvatarView: UIView {

    var avatar: String = "unknown"
    @IBInspectable var shadowWidth: CGFloat = 5 {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var shadowColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var shadowOpacity: Float = 0.8 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let view = UIView(frame: CGRect(x: shadowWidth, y: shadowWidth, width: self.bounds.width - shadowWidth, height: self.bounds.height - shadowWidth))
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.backgroundColor = UIColor.white.cgColor
        view.layer.cornerRadius = view.bounds.width / 2
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowColor = shadowColor.cgColor
        view.layer.shadowOpacity = shadowOpacity
        view.layer.shadowRadius = shadowWidth
        
        let imageView = UIImageView(image: UIImage(named: avatar))
        imageView.frame = view.bounds
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = view.bounds.width / 2
        view.addSubview(imageView)
        
        self.addSubview(view)
    }
}
