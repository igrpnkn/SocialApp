//
//  UIButtonExtension.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 21.10.2020.
//

import Foundation
import UIKit

extension UIButton {
    
    func animationOfPulsation() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 1.0
        pulse.toValue = 1.3
        pulse.autoreverses = true
        pulse.repeatCount = 1
        pulse.initialVelocity = 0.7
        pulse.damping = 1.0
        layer.add(pulse, forKey: nil)
    }
    
    func animationOfFlashing() {
        let flash = CASpringAnimation(keyPath: "opacity")
        flash.duration = 0.3
        flash.fromValue = 1.0
        flash.toValue = 0.3
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        layer.add(flash, forKey: nil)
    }
    
    func animationOfShaking() {
        let shake = CASpringAnimation(keyPath: "position")
        let fromValue = NSValue(cgPoint: CGPoint(x: center.x - 5, y: center.y))
        let toValue = NSValue(cgPoint: CGPoint(x: center.x + 5, y: center.y))
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        shake.fromValue = fromValue
        shake.toValue = toValue
        layer.add(shake, forKey: nil)
    }
}
