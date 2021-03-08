//
//  News.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 08.03.2021.
//

import Foundation


class News {
    var avatar: Data?
    var avatarURL: String?
    var author: String?
    var time: Int?
    var text: String?
    var photos: [Data]? = []
    var photosURL: [String]? = []
    var likeCount: Int?
    var commentCount: Int?
    var reviewCount: Int?
    var liked: Int?
}
