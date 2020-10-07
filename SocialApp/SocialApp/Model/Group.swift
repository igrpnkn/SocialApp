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
    
    init(name: String, image: UIImage, followersCount: Int?, publicationsCount: Int?) {
        self.name = name
        self.image = image
        if let followers = followersCount {
            self.followersCount = followers
        }
        if let publications = publicationsCount {
            self.publicationsCount = publications
        }
    }
}
