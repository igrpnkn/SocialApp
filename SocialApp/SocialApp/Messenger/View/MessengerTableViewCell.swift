//
//  MessengerTableViewCell.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 13.10.2020.
//

import UIKit

class MessengerTableViewCell: UITableViewCell {

    private var avatar = UIImageView()
    private var name = UILabel()
    private var message = UILabel()
    private var lastSeen = UILabel()
    private var readLabel = UIImageView()
    private var activeness = UIImageView()
    private var messageStatus = MessageStatusView()
    //@IBOutlet weak private var messageCount: UILabel!
    
    private struct Dimensions {
        static let leading: CGFloat = 6
        static let trailing: CGFloat = 6
        static let top: CGFloat = 10
        static let bottom: CGFloat = 10
        static let zero: CGFloat = 0
        static let avatarSize: CGSize = CGSize(width: 62, height: 62)
        static let titleHeight: CGFloat = 20
        static let textHeight: CGFloat = 40
        static let lastSeenSize: CGSize = CGSize(width: 64, height: 20)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initCommon()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initCommon()
    }
    
    func initCommon() {
        self.selectionStyle = .none
        
        self.avatar.clipsToBounds = true
        self.avatar.layer.cornerRadius = 19
        addSubview(avatar)
        
        self.name.font = .boldSystemFont(ofSize: 18)
        self.name.tintColor = .label
        self.name.numberOfLines = 1
        addSubview(name)
        
        self.message.font = .systemFont(ofSize: 16)
        self.message.tintColor = .systemGray3
        self.message.textColor = .systemGray3
        self.message.numberOfLines = 2
        addSubview(message)
        
        self.lastSeen.font = .systemFont(ofSize: 12)
        self.lastSeen.tintColor = .systemGray3
        self.lastSeen.textColor = .systemGray3
        self.lastSeen.numberOfLines = 1
        addSubview(lastSeen)
        
        self.readLabel.tintColor = .systemBlue
        addSubview(readLabel)
        
        self.activeness.tintColor = .systemGreen
        addSubview(activeness)
        
        self.messageStatus.clipsToBounds = true
        self.messageStatus.layer.cornerRadius = 5
        self.messageStatus.backgroundColor = .systemBlue
        addSubview(messageStatus)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(message: Message) {
        self.avatar.image = message.friendImage
        self.name.text = message.friendName
        self.message.text = message.friendMessege
        self.lastSeen.text = message.friendLastSeen
        self.readLabel.image = UIImage(systemName: "eye.fill")
        self.readLabel.isHidden = true
        self.activeness.image = message.friendActiveness
        //self.messageCount.text = message.friendMessageCount
        self.messageStatus.setCount(number: message.friendMessageCount, isHidden: false)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutAvatarFrame()
        layoutLastSeenFrame()
        layoutNameFrame()
        layoutMessageFrame()
        layoutReadLabelFrame()
        layoutActivenessFrame()
        layoutMessageStatusFrame()
        layoutMessageCountFrame()
    }
    
    private func layoutAvatarFrame() {
        self.avatar.frame = CGRect(x: Dimensions.leading, y: Dimensions.top, width: Dimensions.avatarSize.width, height: Dimensions.avatarSize.height)
    }
    
    private func layoutLastSeenFrame() {
        self.lastSeen.frame = CGRect(x: bounds.width-Dimensions.lastSeenSize.width,
                                     y: Dimensions.top,
                                     width: Dimensions.lastSeenSize.width,
                                     height: Dimensions.titleHeight)
    }
    
    private func layoutNameFrame() {
        let offset = Dimensions.leading+Dimensions.trailing+Dimensions.avatarSize.width
        self.name.frame = CGRect(x: offset,
                                 y: Dimensions.top,
                                 width: bounds.width-offset-Dimensions.leading-lastSeen.bounds.width,
                                 height: Dimensions.titleHeight)
    }
    
    private func layoutMessageFrame() {
        let offset = Dimensions.leading+Dimensions.trailing+Dimensions.avatarSize.width
        self.message.frame = CGRect(x: offset,
                                    y: name.frame.maxY+Dimensions.leading,
                                 width: bounds.width-offset-Dimensions.leading-lastSeen.bounds.width,
                                 height: Dimensions.textHeight)
    }
    
    private func layoutReadLabelFrame() {
        
    }
    
    private func layoutActivenessFrame() {
        self.activeness.frame = CGRect(x: avatar.frame.maxX-10, y: avatar.frame.maxY-10, width: 14, height: 14)
    }
    
    private func layoutMessageStatusFrame() {
        
    }
    
    private func layoutMessageCountFrame() {
        
    }
    
    private func getLabelWidth(text: String, font: UIFont) -> CGFloat {
        // определяем максимальную ширину текста - это ширина ячейки минус отступы слева и справа
        let maxWidth = bounds.width - Dimensions.leading - Dimensions.trailing - avatar.frame.origin.x - avatar.frame.width
        // получаем размеры блока под надпись
        // используем максимальную ширину и максимально возможную высоту
        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        // получаем прямоугольник под текст в этом блоке и уточняем шрифт
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        // получаем ширину блока, переводим её в Double
        let width = Double(rect.size.width)
        // получаем высоту блока, переводим её в Double
        let height = Double(rect.size.height)
        // получаем размер, при этом округляем значения до большего целого числа
        let size = CGSize(width: ceil(width), height: ceil(height))
        return size.width
    }
    
    private func getLabelSize(label: UILabel) -> CGSize {
        let labelSize: CGSize
        if let labelText = label.text, !labelText.isEmpty {
            labelSize = getLabelSize(text: labelText, font: label.font)
        } else {
            labelSize = .zero
        }
        return labelSize
    }
    
    private func getLabelSize(text: String, font: UIFont) -> CGSize {
        // определяем максимальную ширину текста - это ширина ячейки минус отступы слева и справа
        let maxWidth = bounds.width - Dimensions.leading - Dimensions.trailing - avatar.frame.origin.x - avatar.frame.width
        // получаем размеры блока под надпись
        // используем максимальную ширину и максимально возможную высоту
        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        // получаем прямоугольник под текст в этом блоке и уточняем шрифт
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        // получаем ширину блока, переводим её в Double
        let width = Double(rect.size.width)
        // получаем высоту блока, переводим её в Double
        let height = Double(rect.size.height)
        // получаем размер, при этом округляем значения до большего целого числа
        let size = CGSize(width: ceil(width), height: ceil(height))
        return size
    }
    
}
