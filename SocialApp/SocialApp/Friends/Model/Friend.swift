//
//  Friend.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 29.11.2020.
//

import Foundation
import UIKit
import RealmSwift

// MARK: - Parsing with Decodable
class Friend: Object, Decodable {
    
    // required fields
    @objc dynamic var firstName: String = ""
    @objc dynamic var id: Int = 0
    @objc dynamic var lastName: String = ""
    @objc dynamic var isClosed: Bool = false
    @objc dynamic var canAccessClosed: Bool = false
    // optional fields
    @objc dynamic var sex: Int = 0
    @objc dynamic var photo50: String? = ""
    @objc dynamic var online: Int = 0
    @objc dynamic var nickname: String? = ""
    @objc dynamic var domain: String? = ""
    @objc dynamic var bdate: String? = ""
    @objc dynamic var city: String? = ""
    @objc dynamic var country: String? = ""
    @objc dynamic var photoMax: String? = ""
    @objc dynamic var status: String? = ""
    @objc dynamic var lastSeen: Int = 0
    @objc dynamic var occupationName: String? = ""
    @objc dynamic var occupationType: String? = ""
    @objc dynamic var relation: Int = 0
    @objc dynamic var avatar: Data? = nil
    // property to save avatar downloaded later
    var photos = List<Photo>()
    var avatarMax: UIImage = UIImage(named: "camera")!
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case id = "id"
        case lastName = "last_name"
        case isClosed = "is_closed"
        case canAccessClosed = "can_access_closed"
        case sex = "sex"
        case photo50 = "photo_50"
        case online = "online"
        case nickname = "nickname"
        case domain = "domain"
        case bdate = "bdate"
        case city = "city" // container
        case country = "country" // container
        case photoMax = "photo_max"
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
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.firstName = try values.decode(String.self, forKey: .firstName)
        self.id = try values.decode(Int.self, forKey: .id)
        self.lastName = try values.decode(String.self, forKey: .lastName)
        if let isClosedValue = try? values.decode(Bool.self, forKey: .isClosed) {
            self.isClosed = isClosedValue
        }
        //self.isClosed = try values.decode(Bool.self, forKey: .isClosed)
        if let canAccessClosedValue = try? values.decode(Bool.self, forKey: .canAccessClosed) {
            self.canAccessClosed = canAccessClosedValue
        }
        //self.canAccessClosed = try values.decode(Bool.self, forKey: .canAccessClosed)
        if let sexValue = try? values.decode(Int.self, forKey: .sex) {
            self.sex = sexValue
        }
        //self.sex = try values.decode(Int.self, forKey: .sex)
        if let photo50Value = try? values.decode(String.self, forKey: .photo50) {
            self.photo50 = photo50Value
        }
        //self.photo50 = try values.decode(String.self, forKey: .photo50)
        if let onlineValue = try? values.decode(Int.self, forKey: .online) {
            self.online = onlineValue
        }
        //self.online = try values.decode(Int.self, forKey: .online)
        self.nickname = try? values.decode(String.self, forKey: .nickname)
        self.domain = try? values.decode(String.self, forKey: .domain)
        self.bdate = try? values.decode(String.self, forKey: .bdate)
        self.photoMax = try? values.decode(String.self, forKey: .photoMax)
        self.status = try? values.decode(String.self, forKey: .status)
        if let relationValue = try? values.decode(Int.self, forKey: .relation) {
            self.relation = relationValue
        }
        //self.relation = try values.decode(Int.self, forKey: .relation)

        let cityContainer = try? values.nestedContainer(keyedBy: CodingCity.self, forKey: .city)
        self.city = try? cityContainer?.decode(String.self, forKey: .city)

        let countryContainer = try? values.nestedContainer(keyedBy: CodingCountry.self, forKey: .country)
        self.country = try? countryContainer?.decode(String.self, forKey: .country)

        let lastSeenContainer = try? values.nestedContainer(keyedBy: CodingLastSeen.self, forKey: .lastSeen)
        if let lastSeenValue = try? lastSeenContainer?.decode(Int.self, forKey: .lastSeen) {
            self.lastSeen = lastSeenValue
        }
        //self.lastSeen = try! lastSeenContainer?.decode(Int.self, forKey: .lastSeen) as! Int

        let occupationContainer = try? values.nestedContainer(keyedBy: CodingOccupation.self, forKey: .occupation)
        self.occupationType = try? occupationContainer?.decode(String.self, forKey: .occupationType)
        self.occupationName = try? occupationContainer?.decode(String.self, forKey: .occupationName)
    }
}

class FriendData: Decodable {
    let response: FriendResponse
}

class FriendResponse: Decodable {
    let count: Int
    let items: [Friend]
}
