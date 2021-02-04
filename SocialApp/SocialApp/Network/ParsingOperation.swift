//
//  ParsingOperation.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 24.01.2021.
//

import Foundation

class ParsingOperation: Operation {
    
    var parsedData: [Friend] = []
    
    override func main() {
        guard let networkOperation = dependencies.first as? NetworkOperation,
              let data = networkOperation.data
        else {
            print("\nINFO: Operation #ParsingOperation was returned from \(#function).")
            return
        }
        guard let friends = try? JSONDecoder().decode(FriendData.self, from: data)
        else {
            print("INFO: Operation #ParsingOperation was returned due to JSON parsing failed.")
            return
        }
        self.parsedData = friends.response.items
        print("\nFriends from ParsingOperation: \(self.parsedData.count)")
        print(self.parsedData.map { $0.firstName } )
        print("\nINFO: ParsingOperation has done.")
    }
    
}
