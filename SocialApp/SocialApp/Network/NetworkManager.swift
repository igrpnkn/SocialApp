//
//  NetworkManager.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 25.11.2020.
//

import Foundation
import Alamofire

extension Session {
    static let custom: Session = {
        let configuration = URLSessionConfiguration.default
        let sessionManager = Session(configuration: configuration)
        return sessionManager
    }()
}

class NetworkManager {
    
    static func friendsGet() {
        let userId = UserSession.instance.userId
        let token = UserSession.instance.token
        let parameters: Parameters = [
            "user_id": userId,
            "lang": "ru",
            "order": "hints",
            "count": 7,
            "fields": "first_name,last_name,city,domain",
            "access_token": token!,
            "v": "5.126"
        ]
        Session.custom.request("https://api.vk.com/method/friends.get", parameters: parameters).responseJSON { respone in
            print(respone.value)
        }
    }
    
    static func groupsGet() {
        let userId = UserSession.instance.userId
        let token = UserSession.instance.token
        let parameters: Parameters = [
            "user_id": userId,
            "lang": "ru",
            "extended": 1,
            "fields": "members_count",
            "count": 10,
            "access_token": token!,
            "v": "5.126"
        ]
        Session.custom.request("https://api.vk.com/method/groups.get", parameters: parameters).responseJSON { respone in
            print(respone.value)
        }
    }
    
    static func groupsSearch(search: String) {
        let token = UserSession.instance.token
        let parameters: Parameters = [
            "lang": "ru",
            "q": search,
            "sort": 0,
            "count": 12,
            "access_token": token!,
            "v": "5.126"
        ]
        Session.custom.request("https://api.vk.com/method/groups.search", parameters: parameters).responseJSON { respone in
            print(respone.value)
        }
    }
    
    static func photosGet() {
        let userId = UserSession.instance.userId
        let token = UserSession.instance.token
        let parameters: Parameters = [
            "onwer_id": userId,
            "lang": "ru",
            "album_id": "profile",
            "extended": 1,
            "photo_sizes": 1,
            "count": 10,
            "access_token": token!,
            "v": "5.126"
        ]
        Session.custom.request("https://api.vk.com/method/photos.get", parameters: parameters).responseJSON { respone in
            print(respone.value)
        }
    }
}
