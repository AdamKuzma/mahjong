//
//  HapticFeedback.swift
//  Mahjong
//
//  Created by Adam Kuzma on 10/7/24.
//

import UIKit

class HapticFeedbackManager {
    static func triggerLightFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}
