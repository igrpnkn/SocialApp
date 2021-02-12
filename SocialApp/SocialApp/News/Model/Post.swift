//
//  Post.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 12.01.2021.
//

import Foundation

// MARK: - Data
class PostData: Decodable {
    let response: PostResponse
}

// MARK: - /response
class PostResponse: Decodable {
    let items: [PostItem]?
    let profiles: [PostProfile]?
    let groups: [PostGroup]?
    let next_from: String?
}

// MARK: - /response/items
class PostItem: Decodable {
    let attachments: [PostAttachment]?
    let can_doubt_category: Bool?
    let can_set_category: Bool?
    let carousel_offset: Int?
    let comments: PostComments?
    let date: Int?
    let donut: PostDonut?
    let is_favorite: Bool?
    let likes: PostLikes?
    let marked_as_ads: Int?
    let post_id: Int?
    let post_source: PostSource?
    let post_type: String?
    let reposts: PostReposts?
    let short_text_rate: Double? // or String?
    let signer_id: Int?
    let source_id: Int? // or String?
    let text: String?
    let topic_id: Int?
    let type: String?
    let views: PostViews?
    // 21 fields
}

class PostAttachment: Decodable {
    let type: String?
    let photo: Photo?
//    let link: Link?
//    let video: Video?
//    let posted_photo: PostedPhoto?
//    let audio: Audio?
//    let doc: Document?
//    let note: Note?
//    let app: App?
}

class PostComments: Decodable {
    let count: Int?
    let can_post: Int?
    let groups_can_post: Bool?
}

class PostDonut: Decodable {
    let is_donut: Bool?
}

class PostLikes: Decodable {
    var count: Int?
    var user_likes: Int?
    let can_like: Int?
    let can_publish: Int?
}

class PostSource: Decodable {
    let type: String?
}

class PostReposts: Decodable {
    let count: Int?
    let user_reposted: Int?
}

class PostViews: Decodable {
    let count: Int?
}

// MARK: - /response/profiles
class PostProfile: Decodable {
    let id: Int?
    let first_name: String?
    let last_name: String?
    let photo_50: String?
}

// MARK: - /response/groups
class PostGroup: Decodable {
    let id: Int?
    let name: String?
    let screen_name: String?
    let photo_50: String?
}
