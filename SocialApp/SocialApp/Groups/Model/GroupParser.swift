//
//  GroupParser.swift
//  SocialApp
//
//  Created by developer on 28.01.2021.
//

import Foundation
import PromiseKit

class GroupParser: Thenable {
    
    typealias T = Data
    
    var result: Result<Data>?
    
    func pipe(to: @escaping (Result<Data>) -> Void) {
        // Have no idea what do here...
    }
    
    static func parse(data: T) -> Promise<[Group]> {
        let promise = Promise<[Group]> { resolver in
            do {
                let groups = try JSONDecoder().decode(GroupData.self, from: data)
                resolver.fulfill(groups.response.items)
            } catch {
                resolver.reject(error)
            }
        }
        return promise
    }
    
}
