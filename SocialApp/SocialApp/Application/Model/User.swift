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
    var image: UIImage?
    var age: Int?
    var lastSeen: String = "Last seen recently"
    var city: String? = "Moscow"
    var work: String? = "Luxesoft JSC"
    var friendship: Bool
    
    init(name: String, lastName: String, image: UIImage, age: Int?, friendship: Bool) {
        self.name = name
        self.lastName = lastName
        self.image = image
        if let userAge = age {
            self.age = userAge
        }
        self.friendship = friendship
    }
}

class UserDataBase {
    
    static let instance = UserDataBase()
    
    private init() {}
    
    var item: [User] = [
        User(name: "Johnny", lastName: "Appleseed", image: UIImage(named: "guy")!, age: 18, friendship: true),
        User(name: "Bobby", lastName: "Axelroude", image: UIImage(named: "guy")!, age: 18, friendship: true),
        User(name: "Michael", lastName: "Composer", image: UIImage(named: "guy")!, age: 18, friendship: true),
        User(name: "Bob", lastName: "Dommergoo", image: UIImage(named: "guy")!, age: 18, friendship: true),
        User(name: "Micky", lastName: "Fiedgerald", image: UIImage(named: "guy")!, age: 18, friendship: true),
        User(name: "Tom", lastName: "Hawkins", image: UIImage(named: "guy")!, age: 18, friendship: true),
        User(name: "Alex", lastName: "Burntman", image: UIImage(named: "guy")!, age: 18, friendship: true),
        User(name: "Mike", lastName: "Rouhgeman", image: UIImage(named: "guy")!, age: 18, friendship: true),
        User(name: "Rashid", lastName: "Daddario", image: UIImage(named: "guy")!, age: 18, friendship: true),
        User(name: "Jude", lastName: "Chappman", image: UIImage(named: "guy")!, age: 18, friendship: true),
        User(name: "Alexander", lastName: "Cross", image: UIImage(named: "guy")!, age: 18, friendship: true),
        User(name: "Malckovich", lastName: "John", image: UIImage(named: "guy")!, age: 18, friendship: false),
        User(name: "Averin", lastName: "Oleg", image: UIImage(named: "guy")!, age: 18, friendship: false),
        User(name: "Yevanovich", lastName: "Peter", image: UIImage(named: "guy")!, age: 18, friendship: false),
        User(name: "Voznyak", lastName: "Steve", image: UIImage(named: "guy")!, age: 18, friendship: false),
        User(name: "Conerry", lastName: "Sean", image: UIImage(named: "guy")!, age: 18, friendship: false),
        User(name: "Crauw", lastName: "Rassell", image: UIImage(named: "guy")!, age: 18, friendship: false),
        User(name: "Macarthur", lastName: "Niel", image: UIImage(named: "guy")!, age: 18, friendship: false)
    ]
}
