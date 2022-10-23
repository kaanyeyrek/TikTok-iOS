//
//  HapticsManager.swift
//  TikTok
//
//  Created by Kaan Yeyrek on 9/29/22.
//

import Foundation
import UIKit

// Object that deals with haptic feedback
final class HapticsManager {
    // Shared singleton instance
    static let shared = HapticsManager()
    // Private constructor
    private init() {}
    
//MARK: - Public func
    // Vibrate for selection
    public func vibrateForSelection() {
        DispatchQueue.main.async {
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
            generator.prepare()
        }
    }
    // Trigger Feedback vibration based on event type
    // Parameter type:  Success, Error or Warning type
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        DispatchQueue.main.async {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type)
        }
    }

    
}
