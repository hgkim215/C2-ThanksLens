//
//  Item.swift
//  ThanksLens
//
//  Created by 김현기 on 4/14/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
