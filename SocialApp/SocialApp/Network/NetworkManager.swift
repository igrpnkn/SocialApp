//
//  NetworkManager.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 25.11.2020.
//

import Foundation
import Alamofire
import PromiseKit

// Alamofire's class
extension Session {
    static let custom: Session = {
        let configuration = URLSessionConfiguration.default
        let sessionManager = Session(configuration: configuration, requestQueue: DispatchQueue.global(), serializationQueue: DispatchQueue.global())
        return sessionManager
    }()
}

class NetworkManager {
    
    //public static var shared = NetworkManager()
    
    static func friendsGet(for userId: Int, completion: @escaping ([Friend]?) -> Void) {
        let parameters: Parameters = [
            "user_id": userId,
            "lang": "ru",
            "order": "name",
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
            print(respone.value!)
        }
    }
    
    static func photosGetForProfile(for userId: Int, completion: @escaping ([Photo]?) -> Void) {
        let parameters: Parameters = [
            "owner_id": userId,
            "lang": "ru",
            "album_id": "profile",
            "extended": 1,
            "photo_sizes": 1,
            "count": 30,
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

// MARK: - GROUPS METHODS
extension NetworkManager {
    
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
    
    static func groupsGet(for userId: Int) -> Promise<[Group]> {
        let schemaURL = "https://"
        let baseURL = "api.vk.com"
        let pathURL = "/method/groups.get"
        let parametersURL: Parameters = [
            "user_id": userId,
            "lang": "ru",
            "extended": 1,
            "fields": "activity,members_count,photo_50",
            "count": 500,
            "access_token": UserSession.instance.token!,
            "v": "5.126"
        ]
        let promise = Promise<[Group]> { resolver in
            Session.custom.request(schemaURL + baseURL + pathURL, method: .get, parameters: parametersURL).responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let groups = try JSONDecoder().decode(GroupData.self, from: data)
                        resolver.fulfill(groups.response.items)
                    } catch {
                        resolver.reject(error)
                    }
                case .failure(let error):
                    print("\nINFO: NetworkManager.\(#function) - Data getting failed...\nERROR: \(error.localizedDescription)")
                    resolver.reject(error)
                }
            }
        }
        return promise
    }
    
}

// MARK: - NEWSFEED METHODS
extension NetworkManager {
    
    static func newsfeedGet(for userID: Int, startTime: Int, nextFrom: String, completion: @escaping (PostResponse?) -> Void) {
        let parameters: Parameters = [
            "user_id": userID,
            "return_banned": 0,
            "filters": "post",
            "max_photos": 5,
            "start_from": nextFrom,
            "start_time": startTime,
            "count": 25,
            "fields": "",
            "access_token": UserSession.instance.token!,
            "v": "5.126"
        ]
        Session.custom.request("https://api.vk.com/method/newsfeed.get", parameters: parameters).responseData { response in
            guard
                let data = response.value
            else {
                print("\nINFO: Data getting failed...\n")
                completion(nil)
                return
            }
            guard
                let posts = try? JSONDecoder().decode(PostData.self, from: data)
            else {
                print("\nINFO: JSON parsing failed...\n")
                completion(nil)
                return
            }
            completion(posts.response)
        }
        /*
        Session.custom.request("https://api.vk.com/method/newsfeed.get", parameters: parameters).responseJSON { response in
            let json = response.value
            print(json)
        }
        */
    }
    
    static func newsfeedGet(for userID: Int, nextFrom: String, completion: @escaping (PostResponse?) -> Void) {
        let parameters: Parameters = [
            "user_id": userID,
            "return_banned": 0,
            "filters": "post",
            "max_photos": 5,
            "start_from": nextFrom,
            "count": 25,
            "fields": "",
            "access_token": UserSession.instance.token!,
            "v": "5.126"
        ]
        Session.custom.request("https://api.vk.com/method/newsfeed.get", parameters: parameters).responseData { response in
            guard
                let data = response.value
            else {
                print("\nINFO: Data getting failed...\n")
                completion(nil)
                return
            }
            guard
                let posts = try? JSONDecoder().decode(PostData.self, from: data)
            else {
                print("\nINFO: JSON parsing failed...\n")
                completion(nil)
                return
            }
            completion(posts.response)
        }
        /*
        Session.custom.request("https://api.vk.com/method/newsfeed.get", parameters: parameters).responseJSON { response in
            let json = response.value
            print(json)
        }
        */
    }
    
}

// MARK: - REQUEST BUILDER's METHODS

extension NetworkManager {

    static func biuldRequest() -> DataRequest {
        let parameters: Parameters = [
            "user_id": UserSession.instance.userId!,
            "lang": "ru",
            "order": "name",
            "count": 500,
            "name_case": "nom",
            "fields": "domain,online,first_name,last_name,nickname,status,bdate,sex,relation,photo_50,photo_max,city,country,occupation,last_seen",
            "access_token": UserSession.instance.token!,
            "v": "5.126"
        ]
        return Session.custom.request("https://api.vk.com/method/friends.get", parameters: parameters)
    }
    
    static func groupsGetRequest(for userId: Int) -> DataRequest {
        let parameters: Parameters = [
            "user_id": userId,
            "lang": "ru",
            "extended": 1,
            "fields": "activity,members_count,photo_50",
            "count": 500,
            "access_token": UserSession.instance.token!,
            "v": "5.126"
        ]
        return Session.custom.request("https://api.vk.com/method/groups.get", parameters: parameters)
    }
    
}
