//
//  AppViewModel.swift
//  Learning_ch2
//
//  Created by Lujain on 05/06/1448 AH.
//

import Foundation
import Observation

// MARK: - App Screen

// Input: The saved learning goal status.
// Description: Defines the app's initial screens.
// Output: Onboarding or Activity.

enum AppScreen {
    case onboarding
    case activity
}


// MARK: - App ViewModel

// Input: Saved goal status and learning period.
// Description: Determines the app's initial screen
//              and converts the saved learning period.
// Output: The appropriate screen and LearningPeriod.

@Observable
class AppViewModel {

    // MARK: - Initial Navigation

    // Input: Whether a saved learning goal exists.
    // Description: Determines the screen to display.
    // Output: Activity if a goal exists, otherwise Onboarding.

    func currentScreen(hasSavedGoal: Bool) -> AppScreen {

        if hasSavedGoal {
            return .activity
        }

        return .onboarding
    }


    // MARK: - Selected Learning Period

    // Input: The saved learning period string.
    // Description: Converts the stored value
    //              into a LearningPeriod.
    // Output: Week, Month, or Year.

    func selectedPeriod(from savedValue: String) -> LearningPeriod {

        LearningPeriod(rawValue: savedValue) ?? .week
    }
}
