//
//  AccountTableViewCell.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 22.10.2020.
//

import UIKit

class AccountTableViewCell: UITableViewCell {
    
    let circleLeft = UIView()
    let circleCenter = UIView()
    let circleRight = UIView()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let viewBackground = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.width))
        viewBackground.layer.backgroundColor = UIColor.clear.cgColor
        
        circleLeft.center = CGPoint(x: viewBackground.center.x - 30, y: viewBackground.center.y)
        circleLeft.bounds.size = CGSize(width: 20, height: 20)
        circleLeft.layer.backgroundColor = UIColor.systemGray4.cgColor
        circleLeft.layer.masksToBounds = true
        circleLeft.layer.cornerRadius = circleLeft.bounds.height/2
        circleLeft.layer.opacity = 1
        
        circleCenter.center = CGPoint(x: viewBackground.center.x, y: viewBackground.center.y)
        circleCenter.bounds.size = CGSize(width: 20, height: 20)
        circleCenter.layer.backgroundColor = UIColor.systemGray4.cgColor
        circleCenter.layer.masksToBounds = true
        circleCenter.layer.cornerRadius = circleCenter.bounds.height/2
        circleCenter.layer.opacity = 1
        
        circleRight.center = CGPoint(x: viewBackground.center.x + 30, y: viewBackground.center.y)
        circleRight.bounds.size = CGSize(width: 20, height: 20)
        circleRight.layer.backgroundColor = UIColor.systemGray4.cgColor
        circleRight.layer.masksToBounds = true
        circleRight.layer.cornerRadius = circleRight.bounds.height/2
        circleRight.layer.opacity = 1
        
        viewBackground.addSubview(circleLeft)
        viewBackground.addSubview(circleCenter)
        viewBackground.addSubview(circleRight)
        self.addSubview(viewBackground)
        
        //self.animateLoading()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func animateLoading() {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.circleLeft.layer.opacity = 0.5
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.25, options: [.repeat, .autoreverse], animations: {
            self.circleCenter.layer.opacity = 0.5
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.5, options: [.repeat, .autoreverse], animations: {
            self.circleRight.layer.opacity = 0.5
        }, completion: nil)

    }
    
}
