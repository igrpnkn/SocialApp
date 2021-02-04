//
//  Video.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 15.01.2021.
//

import Foundation

class Video: Decodable {
    let access_key: String
    let can_comment: Int
    let can_like: Int
    let can_repost: Int
    let can_subscribe: Int
    let can_add_to_faves: Int
    let can_add: Int
    let comments: Int
    let date: Int
    let description: String
    let duration: Int
    //let image: [VideoImage]
    //let first_frame: [VideoFirstFrame]
    let width: Int
    let height: Int
    let id: Int
    let owner_id: Int
    let title: String
    let is_favorite: Bool
    let track_code: String
    let type: String
    let views: Int
}

class VideoImage: Decodable {
    let height: Int
    let width: Int
    let url: String
    let with_padding: Int?
}

class VideoFirstFrame: Decodable {
    let height: Int
    let width: Int
    let url: String
}
