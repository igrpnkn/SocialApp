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
 
    
    
}
