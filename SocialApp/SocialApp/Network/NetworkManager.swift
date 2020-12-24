//
//  NetworkManager.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 25.11.2020.
//

import Foundation
import Alamofire
import RealmSwift

// Alamofire's class
extension Session {
    static let custom: Session = {
        let configuration = URLSessionConfiguration.default
        let sessionManager = Session(configuration: configuration)
        return sessionManager
    }()
}

class NetworkManager {
    
    //public static var shared = NetworkManager()
    
    static func friendsGet(for userId: Int, completion: @escaping ([Friend]?) -> Void) {
        let parameters: Parameters = [
            "user_id": userId,
            "lang": "ru",
            "order": "hints",
            "count": 500,
            "name_case": "nom",
            "fields": "domain,online,first_name,last_name,nickname,status,bdate,sex,relation,photo_50,photo_max,city,country,occupation,last_seen",
            "access_token": UserSession.instance.token!,
            "v": "5.126"
        ]
        Session.custom.request("https://api.vk.com/method/friends.get", parameters: parameters).responseData { response in
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
        }
    }
    
    static func groupsGet(for userId: Int, completion: @escaping ([Group]?) -> Void) {
        let parameters: Parameters = [
            "user_id": userId,
            "lang": "ru",
            "extended": 1,
            "fields": "activity,members_count,photo_50",
            "count": 500,
            "access_token": UserSession.instance.token!,
            "v": "5.126"
        ]
        Session.custom.request("https://api.vk.com/method/groups.get", parameters: parameters).responseData { response in
            //print("\nINFO: Raw Data of response: \(response.value)")
            guard
                let data = response.value
            else {
                print("\nINFO: NetworkManager.groupsGet() - Data getting failed...")
                completion(nil)
                return
            }
            guard
                let groups = try? JSONDecoder().decode(GroupData.self, from: data)
            else {
                print("\nINFO: NetworkManager.groupsGet() - JSON parsing failed...")
                completion(nil)
                return
            }
            print("\nINFO: Groups from NetworkManager: \(groups.response.items.count)")
            print(groups.response.items.map { $0.name } )
            completion(groups.response.items)
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
    
    static func photosGetForProfile(for userId: Int, completion: @escaping ([Photo]?) -> Void) {
        let parameters: Parameters = [
            "owner_id": userId,
            "lang": "ru",
            "album_id": "profile",
            "extended": 1,
            "photo_sizes": 1,
            "count": 10,
            "access_token": UserSession.instance.token!,
            "v": "5.126"
        ]
        
        Session.custom.request("https://api.vk.com/method/photos.get", parameters: parameters).responseData { response in
            //print(response.value)
            guard
                let data = response.value
            else {
                print("\nINFO: Data getting failed...")
                completion(nil)
                return
            }
            guard
                let photos = try? JSONDecoder().decode(PhotoData.self, from: data)
            else {
                print("\nINFO: JSON parsing failed...")
                completion(nil)
                return
            }
            completion(photos.response.items)
            print("\nPhotos from JSON - count: \(photos.response.count)")
            print("\nPhotos from NetworkManager: \(photos.response.items.count)")
            print(photos.response.items.map { $0.id } )
            print(photos.response.items.map { $0.sizes.map { $0.url
            } } )
            //print(photos)
        }
    }
}

