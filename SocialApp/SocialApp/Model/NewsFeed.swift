//
//  NewsFeed.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 18.10.2020.
//

import Foundation
import UIKit

struct News {
    var avatar: UIImage?
    var author: String?
    var time: String?
    var text: String?
    var images: [UIImage]?
    var likeCount: Int?
    var commentCount: Int?
    var reviewCount: Int?
    
    init(avatar: UIImage?, author: String?, time: String?, text: String?, images: [UIImage]?, likeCount: Int?, commentCount: Int?, reviewCount: Int?) {
        self.avatar = avatar
        self.author = author
        self.time = time
        self.text = text
        self.images = images
        self.likeCount = likeCount
        self.commentCount = commentCount
        self.reviewCount = reviewCount
    }
}

class NewsDataBase {
    
    static let instance = NewsDataBase()
    
    private init() {}
    
    var item: [News] = [
        News(avatar: UIImage(named: "logo_mac"), author: "iOS Dev community", time: "About 2 hours ago", text: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu.", images: [UIImage(named: "guy")!], likeCount: 321, commentCount: 231, reviewCount: 1423),
        News(avatar: UIImage(named: "logo_mac"), author: "iOS Dev community", time: "About 2 hours ago", text: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", images: [UIImage(named: "guy")!, UIImage(named: "musicGroup")!], likeCount: 321, commentCount: 231, reviewCount: 1423),
        News(avatar: UIImage(named: "logo_mac"), author: "iOS Dev community", time: "About 2 hours ago", text: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", images: [UIImage(named: "guy")!, UIImage(named: "musicGroup")!, UIImage(named: "unknown")!], likeCount: 321, commentCount: 231, reviewCount: 1423),
        News(avatar: UIImage(named: "logo_mac"), author: "iOS Dev community", time: "About 2 hours ago", text: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", images: [UIImage(named: "guy")!, UIImage(named: "musicGroup")!, UIImage(named: "musicGroup")!, UIImage(named: "guy")!], likeCount: 321, commentCount: 231, reviewCount: 1423),
        News(avatar: UIImage(named: "logo_mac"), author: "iOS Dev community", time: "About 2 hours ago", text: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", images: nil, likeCount: 321, commentCount: 231, reviewCount: 1423)
    ]
}
