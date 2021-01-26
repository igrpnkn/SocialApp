//
//  DownloadingAvatarsOperation.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 26.01.2021.
//

import Foundation
import RealmSwift

class DownloadingAvatarsOperation: AsyncOperation {
    
    override func main() {
        guard let savingOperation = dependencies.first as? SavingOperation else {
            print("\nINFO: ERROR - Here is no friends to downlaod avatars in DownloadingAvatarsOperation.\(#function)")
            return
        }
        for object in savingOperation.parsedData {
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
    
    override func start() {
        if isCancelled {
            state = .finished
        } else {
            main()
            state = .executing
        }
    }

    override func cancel() {
        super.cancel()
        state = .finished
    }
    
}
