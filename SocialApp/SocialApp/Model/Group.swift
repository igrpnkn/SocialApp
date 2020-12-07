//
//  Group.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 07.10.2020.
//

import Foundation
import UIKit

// MARK: - Parsing with Decodable
class Group: Decodable {
    // required fields
    var id: Int = 0
    var name: String = ""
    // optional fields
    var activity: String? = ""
    var membersCount: Int? = 0
    var photo50: String? = ""
    // property to save avatar downloaded separately
    var avatar: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case activity = "activity"
        case membersCount = "members_count"
        case photo50 = "photo_50"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.activity = try? container.decode(String.self, forKey: .activity)
        self.membersCount = try? container.decode(Int.self, forKey: .membersCount)
        self.photo50 = try? container.decode(String.self, forKey: .photo50)
    }
}

class GroupData: Decodable {
    let response: GroupResponse
}

class GroupResponse: Decodable {
    let count: Int
    let items: [Group]
}
