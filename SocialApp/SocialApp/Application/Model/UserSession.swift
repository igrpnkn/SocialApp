//
//  UserSession.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 25.11.2020.
//

import Foundation
import Firebase
import FirebaseDatabase

class UserSession {
    static var instance = UserSession()
    
    private init() {}
    
    var token: String?
    var userId: Int?
}

class FirebaseUserSession {
    // 1
    let authDate: String
    let userID: Int
    let ref: DatabaseReference?
    
    init(authDate: String, userID: Int) {
        // 2 - when database is empty
        self.ref = nil
        self.authDate = authDate
        self.userID = userID
    }
    
    init?(snapshot: DataSnapshot) {
        // 3 - loading from database by snapshot
        guard
            let value = snapshot.value as? [String: Any],
            let userID = value["userID"] as? Int,
            let authDate = value["authDate"] as? String else {
                return nil
        }
        self.ref = snapshot.ref
        self.authDate = authDate
        self.userID = userID
    }
    
    func toAnyObject() -> [String: Any] {
        // 4 - rule for dictionary
        return [
            "userID": userID,
            "authDate": authDate
        ]
    }
}
