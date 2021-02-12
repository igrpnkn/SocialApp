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
    static let audio = VKScopeBitmask(rawValue: 1 << 3)
    static let video = VKScopeBitmask(rawValue: 1 << 4)
    static let stories = VKScopeBitmask(rawValue: 1 << 6)
    static let pages = VKScopeBitmask(rawValue: 1 << 7)
    static let status = VKScopeBitmask(rawValue: 1 << 10)
    static let notes = VKScopeBitmask(rawValue: 1 << 11)
    static let messages = VKScopeBitmask(rawValue: 1 << 12)
    static let wall = VKScopeBitmask(rawValue: 1 << 13)
    static let ads = VKScopeBitmask(rawValue: 1 << 15)
    static let offline = VKScopeBitmask(rawValue: 1 << 16)
    static let docs = VKScopeBitmask(rawValue: 1 << 17)
    static let groups = VKScopeBitmask(rawValue: 1 << 18)
    static let notifications = VKScopeBitmask(rawValue: 1 << 19)
    static let stats = VKScopeBitmask(rawValue: 1 << 20)
    static let email = VKScopeBitmask(rawValue: 1 << 22)
    static let market = VKScopeBitmask(rawValue: 1 << 27)
    
    static let all: VKScopeBitmask = [
        .notify, .friends, .photos, .audio, .video, .stories, .pages, .status, .notes, .wall, .ads, .offline, .docs, .groups, .notifications, .stats
    ]
}
