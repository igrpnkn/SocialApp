//
//  Photoflow.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 01.01.2021.
//

import Foundation
import RealmSwift

class Photoflow: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var ownerID: Int = 0
    @objc dynamic var data: Data? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
