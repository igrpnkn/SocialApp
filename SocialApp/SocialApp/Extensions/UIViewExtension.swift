//
//  UIViewExtension.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 22.10.2020.
//

import Foundation
import UIKit

extension UIView {
    
    func animationOfTouchDown() {
        let touchDown = CASpringAnimation(keyPath: "transform.scale")
        touchDown.duration = 0.4
        touchDown.fromValue = 1
        touchDown.toValue = 0.9
        touchDown.autoreverses = false
        touchDown.initialVelocity = 20
        touchDown.damping = 10
        touchDown.isRemovedOnCompletion = false
        touchDown.fillMode = .forwards
        layer.add(touchDown, forKey: nil)
    }
    
    func animationOfTouchUp() {
        let touchDown = CASpringAnimation(keyPath: "transform.scale")
        touchDown.duration = 0.4
        touchDown.fromValue = 1
        touchDown.toValue = 1
        touchDown.autoreverses = false
        touchDown.initialVelocity = 20
        touchDown.damping = 10
        touchDown.isRemovedOnCompletion = false
        touchDown.fillMode = .forwards
        layer.add(touchDown, forKey: nil)
    }
 
    func setGradientBackground(fromColor: UIColor, toColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [fromColor.cgColor, toColor.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
