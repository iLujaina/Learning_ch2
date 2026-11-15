//
//  AppViewModel.swift
//  Learning_ch2
//
//  Created by Lujain on 05/06/1448 AH.
//

import Foundation
import Observation

enum AppScreen {
    case onboarding
    case learningGoal
    case activity
}

@Observable
class AppViewModel {

    var hasSeenOnboarding: Bool
    

    init() {
        hasSeenOnboarding = UserDefaults.standard.bool(
            forKey: "hasSeenOnboarding"
        )

       
    }

    var currentScreen: AppScreen {
        if hasSavedGoal {
            return .activity
        }

        if hasSeenOnboarding {
            return .learningGoal
        }

        return .onboarding
    }

    func completeOnboarding() {
        hasSeenOnboarding = true

        UserDefaults.standard.set(
            true,
            forKey: "hasSeenOnboarding"
        )
    }

    func goalDidSave() {

        UserDefaults.standard.set(
            true,
            forKey: "hasSavedGoal"
        )
    }
    
    var hasSavedGoal: Bool {
        UserDefaults.standard.bool(forKey: "hasSavedGoal")
    }
}
