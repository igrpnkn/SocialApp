//
//  User.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 07.10.2020.
//

import Foundation
import UIKit

struct User {
    var name: String
    var lastName: String
    var image: UIImage
    var age: Int?
    
    init(name: String, lastName: String, image: UIImage, age: Int?) {
        self.name = name
        self.lastName = lastName
        self.image = image
        if let userAge = age {
            self.age = userAge
        }
    }
}
