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
    
    static func saveGotFriendsInRealm(friends: [Friend]) {
        let realm = try! Realm()
        print(realm.configuration.fileURL)
        // 1 способ
        print("\n\nBefore saving in Realm: \(friends.map({$0.lastName }))")
        try? realm.write{
            realm.add(friends, update: .modified)
        }
        // 2 способ
        /*
         realm.beginWrite()
         realm.add(freinds)
         try? realm.commitWrite()
         */
    }
    
    static func saveAvatarForUserID(image data: Data?, userID: Int) {
        let realm = try! Realm()
        let friend = realm.object(ofType: Friend.self, forPrimaryKey: userID)
        try? realm.write{
            friend?.avatar = data
        }
    }
    
    static func friendsGetFromRealm() -> Results<Friend>? {
        let realm = try! Realm()
        print(realm.configuration.fileURL)
        let friends = realm.objects(Friend.self)
        return friends
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
            realm.add(groups, update: .modified)
        }
    }
    
    static func saveAvatarForGroupID(image data: Data?, groupID: Int) {
        let realm = try! Realm()
        let group = realm.object(ofType: Group.self, forPrimaryKey: groupID)
        try? realm.write{
            group?.avatar = data
        }
    }
    
    static func groupsGetFromRealm() -> Results<Group>? {
        let realm = try! Realm()
        print(realm.configuration.fileURL)
        let groups = realm.objects(Group.self)
        return groups
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
    
//    static func saveGotPhotosInRealm(photos: [Photo]) {
//        let realm = try! Realm()
//        try? realm.write{
//            realm.add(photos, update: .modified)
//        }
//    }
    static func savePhotosMetaData(save photos: [Photo], for userID: Int) {
        guard let realm = try? Realm() else {
            print("\nERROR - GETTING ACCESS TO REALM: Aborting saving photos for userID: \(userID).")
            return
        }
        do {
            //let friend = realm.objects(Friend.self).filter("id == %@", userID)
            let friend = realm.object(ofType: Friend.self, forPrimaryKey: userID)!
            let photoList = List<Photo>()
            photoList.append(objectsIn: photos)
            print("\n\n\\nINFO:  PHOTO LIST: \n\(photoList)\n\n\n")
            try realm.write {
                friend.photos = photoList
                realm.add(friend.photos, update: .modified)
            }
        } catch {
            print("\nERROR - APPENDING/ADDING TRANSACTION: Aborting saving photos for userID: \(userID).")
        }
    }
    
//    static func photosGetFromRealm() -> [Photo]? {
//        let realm = try! Realm()
//        let photos = realm.objects(Photo.self)
//        return Array(photos)
//    }
    static func getPhotosMetaData(for userID: Int) -> Results<Photo>? {
        guard let realm = try? Realm() else {
            print("\nERROR - GETTING ACCESS TO REALM: Aborting getting photos for userID: \(userID).")
            return nil
        }
        let photoMetaData = realm.objects(Photo.self).filter("owner_id == %@", userID)
        return photoMetaData
    }
    
    static func deleteAllPhotos() {
        do {
            let realm = try Realm()
            let objects = realm.objects(Photo.self)
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

// MARK: - PHOTOFLOW METHODS
extension RealmManager {
    
    static func savePhotoflow(photoID: Int, ownerID: Int, data: Data?) {
        let realm = try! Realm()
        let photoflow = Photoflow()
        photoflow.id = photoID
        photoflow.ownerID = ownerID
        photoflow.data = data
        try? realm.write{
            realm.add(photoflow, update: .modified)
        }
    }
    
    static func getPhotoflow(userID: Int) -> Results<Photoflow>? {
        guard let realm = try? Realm() else {
            print("\nERROR - GETTING ACCESS TO REALM: Aborting getting photos for userID: \(userID).\n")
            return nil
        }
        let photoflow = realm.objects(Photoflow.self).filter("ownerID == %@", userID)
        return photoflow
    }
    
    static func deletePhotoflow(userID: Int) {
        do {
            let realm = try Realm()
            let objects = realm.objects(Photoflow.self).filter("ownerID == %@", userID)
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
