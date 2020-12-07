//
//  Photo.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 06.12.2020.
//

import Foundation
import UIKit

class PhotoSizes: Decodable {
    var height: Int? = 0
    var type: String? = ""
    var url: String? = ""
    var width: Int? = 0
    
    enum CodingKeys: String, CodingKey {
        case height = "height"
        case type = "type"
        case url = "url"
        case width = "width"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        self.height = try? container?.decode(Int.self, forKey: .height)
        self.type = try? container?.decode(String.self, forKey: .type)
        self.url = try? container?.decode(String.self, forKey: .url)
        self.width = try? container?.decode(Int.self, forKey: .width)
    }
}

class Photo: Decodable {
    var date: Int
    var id: Int
    //var commentsCount: Int
    //var likesCount: Int
    var text: String
    var sizes: [PhotoSizes]
}

class PhotoResponse: Decodable {
    var count: Int
    var items: [Photo]
}

class PhotoData: Decodable {
    var response: PhotoResponse
}
