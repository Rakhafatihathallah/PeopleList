//
//  HapticManager.swift
//  PeopleList
//
//  Created by Rakha Fatih Athallah on 05/01/23.
//

import Foundation
import UIKit

fileprivate final class HapticManager: ObservableObject {
    
    static let shared = HapticManager()
    
    private let feedback = UINotificationFeedbackGenerator()
    
    private init() {}
    
    func trigger(_ notification: UINotificationFeedbackGenerator.FeedbackType) {
        //now we can choose any type of feedback
        feedback.notificationOccurred(notification)
    }
}

func haptic(_ notification: UINotificationFeedbackGenerator.FeedbackType) {
    if UserDefaults.standard.bool(forKey: UserDefaultKeys.hapticsEnabled) {
        HapticManager.shared.trigger(notification)
    }
}
