//
//  UserSession.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 25.11.2020.
//

import Foundation

class UserSession {
    static var instance = UserSession()
    
    private init() {}
    
    var token: String?
    var userId: Int?
}
