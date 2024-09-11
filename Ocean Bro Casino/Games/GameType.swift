//
//  GameType.swift
//  Ocean Bro Casino
//
//  Created by DeveloperMB2020 on 09.09.2024.
//

import SwiftUI

enum GameType: String, Identifiable, CaseIterable {
    case threeInRow
    case fishEater
    case findTreasure
    
    var id: String {
        return rawValue
    }
    
    var title: String {
        switch self {
        case .fishEater:
            return "Fish Eater"
        case .findTreasure:
            return "Find Treasure"
        case .threeInRow:
            return "Three in Row"
        }
    }
    
    var previewImage: Image {
        switch self {
        case .fishEater:
            return Image(.fishEaterPreview)
        case .findTreasure:
            return Image(.findTreasurePreview)
        case .threeInRow:
            return Image(.threeInRowPreview)
        }
    }
}
