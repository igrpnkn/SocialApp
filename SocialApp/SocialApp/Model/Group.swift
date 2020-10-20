//
//  Group.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 07.10.2020.
//

import Foundation
import UIKit

struct Group {
    var name: String
    var image: UIImage
    var followersCount: Int?
    var publicationsCount: Int?
    var subscription: Bool
    var description: String?
    
    init(name: String, image: UIImage, followersCount: Int?, publicationsCount: Int?, subscription: Bool, description: String?) {
        self.name = name
        self.image = image
        if let followers = followersCount {
            self.followersCount = followers
        }
        if let publications = publicationsCount {
            self.publicationsCount = publications
        }
        self.subscription = subscription
        if let descriptionState = description {
            self.description = descriptionState
        }
    }
}

class GroupDataBase {
    
    static let instance = GroupDataBase()
    
    private init() {}
    
    var item: [Group] = [
        Group(name: "First group", image: UIImage(named: "musicGroup")!, followersCount: 111, publicationsCount: 128, subscription: false, description: "Humor"),
        Group(name: "Second group", image: UIImage(named: "musicGroup")!, followersCount: 112, publicationsCount: 128, subscription: false, description: "Humor"),
        Group(name: "Third group", image: UIImage(named: "musicGroup")!, followersCount: 113, publicationsCount: 128, subscription: false, description: "Humor"),
        Group(name: "Fourth group", image: UIImage(named: "musicGroup")!, followersCount: 114, publicationsCount: 128, subscription: false, description: "Humor"),
        Group(name: "Fifth group", image: UIImage(named: "musicGroup")!, followersCount: 115, publicationsCount: 128, subscription: false, description: "Humor"),
        Group(name: "Sixth group", image: UIImage(named: "musicGroup")!, followersCount: 116, publicationsCount: 128, subscription: false, description: "Humor"),
        Group(name: "Seventh group", image: UIImage(named: "musicGroup")!, followersCount: 117, publicationsCount: 128, subscription: false, description: "Humor"),
        Group(name: "Eighth group", image: UIImage(named: "musicGroup")!, followersCount: 118, publicationsCount: 128, subscription: false, description: "Humor"),
        Group(name: "Nineth group", image: UIImage(named: "musicGroup")!, followersCount: 119, publicationsCount: 128, subscription: false, description: "Humor"),
        Group(name: "Tenth group", image: UIImage(named: "musicGroup")!, followersCount: 120, publicationsCount: 128, subscription: false, description: "Humor"),
        Group(name: "Eleventh group", image: UIImage(named: "musicGroup")!, followersCount: 121, publicationsCount: 128, subscription: false, description: "Humor"),
        Group(name: "Twelveth group", image: UIImage(named: "musicGroup")!, followersCount: 122, publicationsCount: 128, subscription: false, description: "Humor"),
        Group(name: "Private group", image: UIImage(named: "musicGroup")!, followersCount: 123, publicationsCount: 128, subscription: true, description: "Adult content"),
        Group(name: "Public group", image: UIImage(named: "musicGroup")!, followersCount: 124, publicationsCount: 128, subscription: true, description: "News"),
        Group(name: "Commercial group", image: UIImage(named: "musicGroup")!, followersCount: 125, publicationsCount: 128, subscription: true, description: "Business")
    ]
}
