//
//  AvatarDownloader.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 26.01.2021.
//

import Foundation
import RealmSwift

class AvatarDownloader {
    
    enum objectType {
        case friend, group
    }
    
    func downloadForType<T>(objects: [T], objectType: objectType) {
        switch objectType {
        case .friend:
            guard let objects = objects as? [Friend] else { return }
            for object in objects {
                if let url = URL(string: object.photo50!) {
                    DispatchQueue.global().async {
                        if let data = try? Data(contentsOf: url) {
                            DispatchQueue.main.async {
                                RealmManager.saveAvatarForUserID(image: data, userID: object.id)
                            }
                        }
                    }
                }
            }
        case .group:
            guard let objects = objects as? [Group] else { return }
            for object in objects {
                if let url = URL(string: object.photo50!) {
                    DispatchQueue.global().async {
                        if let data = try? Data(contentsOf: url) {
                            DispatchQueue.main.async {
                                RealmManager.saveAvatarForUserID(image: data, userID: object.id)
                            }
                        }
                    }
                }
            }
        }
        
        
    }
    
}
