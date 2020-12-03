//
//  NetworkManager.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 25.11.2020.
//

import Foundation
import Alamofire

// Alamofire's class
extension Session {
    static let custom: Session = {
        let configuration = URLSessionConfiguration.default
        let sessionManager = Session(configuration: configuration)
        return sessionManager
    }()
}

class NetworkManager {
    
    
    static func friendsGet(for userId: Int, completion: @escaping ([Friend]?) -> Void) -> Request {
        let parameters: Parameters = [
            "user_id": userId,
            "lang": "ru",
            "order": "hints",
            "count": 100,
            "name_case": "nom",
            "fields": "domain,online,first_name,last_name,nickname,status,bdate,sex,relation,photo_50,photo_400_orig,city,country,occupation,last_seen",
            "access_token": UserSession.instance.token!,
            "v": "5.126"
        ]
        
        return Session.custom.request("https://api.vk.com/method/friends.get", parameters: parameters).responseData { response in
            guard
                let data = response.value
            else {
                print("INFO: Data getting failed...")
                completion(nil)
                return
            }
            guard
                let friends = try? JSONDecoder().decode(FriendData.self, from: data)
            else {
                print("INFO: JSON parsing failed...")
                completion(nil)
                return
            }
            
            completion(friends.response.items)
            print("\nFriends from NetworkManager: \(friends.response.items.count)")
            print(friends.response.items.map { $0.firstName } )
            //print(friend)
        }
    }
    
    static func groupsGet() {
        let userId = UserSession.instance.userId
        let token = UserSession.instance.token
        let parameters: Parameters = [
            "user_id": userId!,
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
