//
//  Session.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 19.11.2020.
//

class Session {
    static var instance = Session()
    
    private init() {}
    
    var token: String?
    var userId: Int?
}
