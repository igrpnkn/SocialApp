//
//  VKScopeBitmask.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 25.11.2020.
//

import Foundation

struct VKScopeBitmask: OptionSet {
    let rawValue: Int
    
    static let notify = VKScopeBitmask(rawValue: 1 << 0)
    static let friends = VKScopeBitmask(rawValue: 1 << 1)
    static let photos = VKScopeBitmask(rawValue: 1 << 2)
    static let status = VKScopeBitmask(rawValue: 1 << 10)
    static let wall = VKScopeBitmask(rawValue: 1 << 13)
    static let offline = VKScopeBitmask(rawValue: 1 << 16)
    static let groups = VKScopeBitmask(rawValue: 1 << 18)
    
    static let all: VKScopeBitmask = [
        .notify, .friends, .photos, .status, .wall, .offline, .groups
    ]
}
