//
//  AppFeedbackGenerator.swift
//  Ocean Bro Casino
//
//  Created by DeveloperMB2020 on 11.09.2024.
//

import UIKit

struct AppFeedbackGenerator {
    static func occureImpact(with style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let impactGenerator = UIImpactFeedbackGenerator(style: style)
        impactGenerator.prepare() // Prepare the generator
        impactGenerator.impactOccurred() // Trigger the feedback
    }
}
