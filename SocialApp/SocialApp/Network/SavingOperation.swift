//
//  SavingOperation.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 24.01.2021.
//

import Foundation

class SavingOperation: Operation {
    
    var parsedData: [Friend] = []
    
    override func main() {
        print("\nINFO: ParsingOperation has started.")
        guard let parsingOperation = dependencies.first as? ParsingOperation
        else {
            print("\nINFO: Operation #SavingOperation was returned from \(#function).")
            return
        }
        self.parsedData = parsingOperation.parsedData
        RealmManager.deleteAllFriendsObject() // is used to resolve logical conflict when we have deleted Friend in vk.com but in RealmDB it still is there
        RealmManager.saveGotFriendsInRealm(friends: self.parsedData)
        print("\nFriends from SavingOperation: \(parsingOperation.parsedData.count)")
        print(parsingOperation.parsedData.map { $0.firstName } )
        print("\nINFO: ParsingOperation has done.")
    }
    
}
