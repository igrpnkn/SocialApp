//
//  DateFormatterExtension.swift
//  SocialApp
//
//  Created by Игорь Пенкин on 06.03.2021.
//

import Foundation

extension DateFormatter {
    
    static public var shared = DateFormatter()
    
    public func setCommonFormat() {
        DateFormatter.shared.timeStyle = DateFormatter.Style.short //Set time style
        DateFormatter.shared.dateStyle = DateFormatter.Style.medium //Set date style
        DateFormatter.shared.timeZone = .current
    }
    
}
