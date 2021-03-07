//
//  FriendViewModelAdapter.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 06.03.2021.
//

import Foundation
import RealmSwift

class FriendViewModelAdapter {
    
    private var friendCollection = RealmManager.friendsGetFromRealm()
    private var realmNotificationToken: NotificationToken?
    
    func getFriendCollection(completion: @escaping([FriendViewModel]) -> Void) {
        NetworkManager.friendsGet(for: UserSession.instance.userId!) { [weak self] friends in
            guard let friendsArray = friends  else { return }
            RealmManager.deleteAllFriendsObject() // is used to resolve logical conflict when we have deleted Friend in vk.com but in RealmDB it still is there
            RealmManager.saveGotFriendsInRealm(friends: friendsArray)
            AvatarDownloader().downloadForType(objects: friendsArray, objectType: .friend)
        }
        self.realmNotificationToken = friendCollection?.observe(on: DispatchQueue.main, { [weak self] (changes: RealmCollectionChange) in
            guard let self = self else { return }
            switch changes {
            case .initial(let results):
                var friends: [FriendViewModel] = []
                friends = results.map { self.getFriend(from: $0) }
                completion(friends)
            case .update(let results, let deletions, let insertions, let modifications):
                var friends: [FriendViewModel] = []
                friends = results.map { self.getFriend(from: $0) }
                completion(friends)
            case .error(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func getFriend(from realmFirend: Friend) -> FriendViewModel {
        var friend = FriendViewModel(firstName: realmFirend.firstName,
                                     id: realmFirend.id,
                                     lastName: realmFirend.lastName,
                                     online: realmFirend.online,
                                     domain: realmFirend.domain ?? "no info",
                                     bdate: realmFirend.bdate ?? "no info",
                                     city: realmFirend.city ?? "no info",
                                     country: realmFirend.country ?? "no info",
                                     status: realmFirend.status ?? "no info",
                                     lastSeen: realmFirend.lastSeen,
                                     occupationName: realmFirend.occupationName ?? "no info",
                                     relation: realmFirend.relation,
                                     avatar: UIImage(named: "camera"),
                                     avatar50px: realmFirend.photo50!,
                                     avatarMax: realmFirend.avatarMax)
        if let avatarData = realmFirend.avatar {
            friend.avatar = UIImage(data: avatarData)
        }
        return friend
    }
    
}
