//
//  MessageStatusView.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 13.10.2020.
//

import UIKit

class MessageStatusView: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        self.clipsToBounds = true
        self.layer.cornerRadius = self.bounds.width / 2
        self.layer.backgroundColor = UIColor.systemBlue.cgColor
        
    }
    

}
