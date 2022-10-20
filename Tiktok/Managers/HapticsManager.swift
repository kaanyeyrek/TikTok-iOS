//
//  HapticsManager.swift
//  TikTok
//
//  Created by Kaan Yeyrek on 9/29/22.
//

import Foundation
import UIKit


final class HapticsManager {
    
    static let shared = HapticsManager()
    
    private init() {}
    
    
    public func vibrateForSelection() {
        DispatchQueue.main.async {
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
            generator.prepare()
        }
        
    }
        
        public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
            DispatchQueue.main.async {
                let generator = UINotificationFeedbackGenerator()
                generator.prepare()
                generator.notificationOccurred(type)
                
            }
    }
    
    
}
