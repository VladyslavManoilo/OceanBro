//
//  GameDifficulty.swift
//  Ocean Bro Casino
//
//  Created by DeveloperMB2020 on 09.09.2024.
//

import Foundation

enum GameDifficulty: String, Identifiable, CaseIterable {
    case easy
    case hard
    
    var id: String {
        return rawValue
    }
    
    var title: String {
        return rawValue.capitalized
    }
}
