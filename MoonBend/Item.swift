//
//  Item.swift
//  MoonBend
//
//  Created by Isa Costa on 15/07/26.
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
