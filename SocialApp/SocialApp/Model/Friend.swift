//
//  Friend.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 29.11.2020.
//

import Foundation

//struct Friend: Codable {
//    let response: FriendResponse
//}
//
//struct FriendResponse: Codable {
//    let count: Int
//    let items: [FriendItem]
//}
//
//struct FriendCity: Codable {
//    let id: Int
//    let title: String
//}
//
//struct FriendCountry: Codable {
//    let id: Int
//    let title: String
//}
//
//struct FriendOccupation: Codable {
//    let type: String
//    let id: Int
//    let name: String
//}
//
//struct FriendLastSeen: Codable {
//    let time: Int
//    let platform: Int
//}
//
//struct FriendItem: Codable {
//    let id: Int
//    let domain: String
//    let online: Int
//    let first_name: String
//    let last_name: String
//    let nickname: String
//    let status: String
//    let bdate: String
//    let sex: Int
//    let relation: Int
//    let photo_50: String
//    let photo_400_orig: String
//    let city: FriendCity
//    let country: FriendCountry
//    let occupation: FriendOccupation
//    let last_seen: FriendLastSeen
//}

// MARK: - Parsing with Decodable

class Friend: Decodable {
    var firstName: String = ""
    var id: Int = 0
    var lastName: String = ""
    var isClosed: Bool = false
    var sex: Int = 0
    var photo50: String = ""
    var online: Int = 0
    var nickname: String = ""
    var domain: String = ""
    var bdate: String = ""
    var city: String = ""
    var country: String = ""
    var photo400orig: String = ""
    var status: String = ""
    var lastSeen: Int = 0
    var occupationName: String = ""
    var occupationType: String = ""
    var relation: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case id = "id"
        case lastName = "last_name"
        case isClosed = "is_closed"
        case sex = "sex"
        case photo50 = "photo_50"
        case online = "online"
        case nickname = "nickname"
        case domain = "domain"
        case bdate = "bdate"
        case city = "city" // container
        case country = "country" // container
        case photo400orig = "photo_400_orig"
        case status = "status"
        case lastSeen = "last_seen" // container
        case occupation = "occupation" // container
        case relation = "relation"
    }
    
    enum CodingCity: String, CodingKey {
        case city = "title"
    }
    
    enum CodingCountry: String, CodingKey {
        case country = "title"
    }
    
    enum CodingLastSeen: String, CodingKey {
        case lastSeen = "time"
    }
    
    enum CodingOccupation: String, CodingKey {
        case occupationName = "name"
        case occupationType = "type"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.firstName = try values.decode(String.self, forKey: .firstName)
        self.id = try values.decode(Int.self, forKey: .id)
        self.lastName = try values.decode(String.self, forKey: .lastName)
        self.isClosed = try values.decode(Bool.self, forKey: .isClosed)
        self.sex = try values.decode(Int.self, forKey: .sex)
        self.photo50 = try values.decode(String.self, forKey: .photo50)
        self.online = try values.decode(Int.self, forKey: .online)
        self.nickname = try values.decode(String.self, forKey: .nickname)
        self.domain = try values.decode(String.self, forKey: .domain)
        self.bdate = try values.decode(String.self, forKey: .bdate)
        self.photo400orig = try values.decode(String.self, forKey: .photo400orig)
        self.status = try values.decode(String.self, forKey: .status)
        self.relation = try values.decode(Int.self, forKey: .relation)
        
        let cityContainer = try values.nestedContainer(keyedBy: CodingCity.self, forKey: .city)
        self.city = try cityContainer.decode(String.self, forKey: .city)
        
        let countryContainer = try values.nestedContainer(keyedBy: CodingCountry.self, forKey: .country)
        self.country = try countryContainer.decode(String.self, forKey: .country)
        
        let lastSeenContainer = try values.nestedContainer(keyedBy: CodingLastSeen.self, forKey: .lastSeen)
        self.lastSeen = try lastSeenContainer.decode(Int.self, forKey: .lastSeen)
        
        let occupationContainer = try values.nestedContainer(keyedBy: CodingOccupation.self, forKey: .occupation)
        self.occupationType = try occupationContainer.decode(String.self, forKey: .occupationType)
        self.occupationName = try occupationContainer.decode(String.self, forKey: .occupationName)
    }
}

class FriendData: Decodable {
    let response: FriendResponse
}

class FriendResponse: Decodable {
    let count: Int
    let items: [Friend]
}
