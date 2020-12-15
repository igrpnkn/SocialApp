//
//  Photo.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 06.12.2020.
//

import Foundation
import UIKit
import RealmSwift

class PhotoSizes: Object, Decodable {
    @objc dynamic var height: Int = 0
    @objc dynamic var type: String? = ""
    @objc dynamic var url: String? = ""
    @objc dynamic var width: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case height = "height"
        case type = "type"
        case url = "url"
        case width = "width"
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        self.type = try? container?.decode(String.self, forKey: .type)
        self.url = try? container?.decode(String.self, forKey: .url)
        if let widthValue = try? container?.decode(Int.self, forKey: .width) {
            self.width = widthValue
        }
        if let heightValue = try? container?.decode(Int.self, forKey: .height) {
            self.height = heightValue
        }
    }
}

class Photo: Object, Decodable {
    @objc dynamic var date: Int = 0
    @objc dynamic var id: Int = 0
    //var commentsCount: Int
    //var likesCount: Int
    @objc dynamic var text: String = ""
    var sizes = List<PhotoSizes>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override init() {
    }
}

class PhotoResponse: Decodable {
    var count: Int
    var items: [Photo]
}

class PhotoData: Decodable {
    var response: PhotoResponse
}
