//
//  MessageStatusView.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 13.10.2020.
//

import UIKit

class MessageStatusView: UIView {

    private var messageCount = UILabel()
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.bounds.width / 2
        self.layer.backgroundColor = UIColor.systemBlue.cgColor
    }
    
    func setCount(number: Int?, isHidden: Bool) {
        self.messageCount.text = String(number ?? 0)
        self.messageCount.isHidden = isHidden
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.messageCount.frame = self.bounds
        self.messageCount.font = .systemFont(ofSize: 12)
        self.messageCount.tintColor = .white
        self.messageCount.textColor = .white
        self.messageCount.textAlignment = .center
        self.addSubview(messageCount)
    }

}
