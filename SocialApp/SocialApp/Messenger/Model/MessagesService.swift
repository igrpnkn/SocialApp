//
//  MessagesService.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 06.02.2021.
//

import Foundation
import UIKit

class Message {
    var friendImage: UIImage?
    var friendName: String?
    var friendMessege: String?
    var friendLastSeen: String?
    var friendActiveness: UIImage?
    var friendMessageCount: Int?
}

class MessagesService {
    
    private var messages: [Message] = []
    
    func getMessages() -> [Message] {
        let message = Message()
        message.friendImage = UIImage(named: "guy")
        message.friendName = "Johnny Appleseed"
        message.friendMessege = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        message.friendLastSeen = "10:08"
        message.friendActiveness = UIImage(systemName: "circle.fill")?.withTintColor(.systemGreen)
        message.friendMessageCount = 123
        for _ in 0...100 {
            self.messages.append(message)
        }
        return self.messages
    }
    
}
