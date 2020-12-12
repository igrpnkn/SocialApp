//
//  RealmManager.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 11.12.2020.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static func deleteObjects<T: Object>(delete classType: T.Type) {
        do {
            let realm = try Realm()
            let objects = realm.objects(classType)
            try! realm.write {
                realm.delete(objects)
            }
        }
        catch {
            print("\nINFO: Error of deleting realm objects in RealmManager.deleteObjects<T: Object>(delete classType: T.Type):")
            print(error.localizedDescription)
        }
    }
    
}

// MARK: - FRIENDS METHODS

extension RealmManager {
    
    static func saveGotFriendsInRealm(freinds: [Friend]) {
        let realm = try! Realm()
        // 1 способ
        try? realm.write{
            realm.add(freinds)
        }
        // 2 способ
        /*
         realm.beginWrite()
         realm.add(freinds)
         try? realm.commitWrite()
         */
    }
    
    static func friendsGetFromRealm() -> [Friend]? {
        let realm = try! Realm()
        let friends = realm.objects(Friend.self)
        return Array(friends)
    }
    
    static func deleteAllFriendsObject() {
        do {
            let realm = try Realm()
            let objects = realm.objects(Friend.self)
            try! realm.write {
                realm.delete(objects)
            }
        }
        catch {
            print("\nINFO: Error of deleting realm objects in RealmManager.deleteObject(for key: String):")
            print(error.localizedDescription)
        }
    }
    
}

// MARK: - GROUPS METHODS

extension RealmManager {
    
    static func saveGotGroupsInRealm(groups: [Group]) {
        let realm = try! Realm()
        try? realm.write{
            realm.add(groups)
        }
    }
    
    static func groupsGetFromRealm() -> [Group]? {
        let realm = try! Realm()
        let groups = realm.objects(Group.self)
        return Array(groups)
    }
    
    static func deleteAllGroupsObject() {
        do {
            let realm = try Realm()
            let objects = realm.objects(Group.self)
            try! realm.write {
                realm.delete(objects)
            }
        }
        catch {
            print("\nINFO: Error of deleting realm objects in RealmManager.deleteObject(for key: String):")
            print(error.localizedDescription)
        }
    }
    
}

// MARK: - PHOTO METHODS
extension RealmManager {
    
    static func saveGotPhotosInRealm(photos: [Photo]) {
        let realm = try! Realm()
        try? realm.write{
            realm.add(photos)
        }
    }
    
    static func photosGetFromRealm() -> [Photo]? {
        let realm = try! Realm()
        let photos = realm.objects(Photo.self)
        return Array(photos)
    }
    
    static func deleteAllPhotosObject() {
        do {
            let realm = try Realm()
            let objects = realm.objects(Group.self)
            try! realm.write {
                realm.delete(objects)
            }
        }
        catch {
            print("\nINFO: Error of deleting realm objects in RealmManager.deleteObject(for key: String):")
            print(error.localizedDescription)
        }
    }
    
}
