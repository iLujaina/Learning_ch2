
//
//  MyApp.swift
//  Learning_ch2
//

import SwiftUI

// MARK: - Application Entry Point

// Input: The user's saved goal status and learning period.
// Description: Uses AppViewModel to determine the initial screen.
// Output: Displays the activity screen or onboarding screen.

@main
struct MyApp: App {

    // MARK: - Properties

    @State private var appViewModel = AppViewModel()

    @AppStorage("hasSavedGoal")
    private var hasSavedGoal = false

    @AppStorage("goalPeriod")
    private var savedGoalPeriod = "Week"


    // MARK: - App Scene

    // Input: Saved goal status and selected learning period.
    // Description: Builds the main app window and displays
    //              the screen selected by AppViewModel.
    // Output: A SwiftUI scene with the appropriate screen.

    var body: some Scene {

        WindowGroup {

            switch appViewModel.currentScreen(
                hasSavedGoal: hasSavedGoal
            ) {

            case .activity:

                // MARK: - Activity Screen

                // Input: The saved learning period.
                // Description: Opens the user's existing goal.
                // Output: CurrentDayView with the saved period.

                CurrentDayView(
                    selectedPeriod: appViewModel.selectedPeriod(
                        from: savedGoalPeriod
                    )
                )


            case .onboarding:

                // MARK: - Onboarding Screen

                // Input: No saved learning goal.
                // Description: Opens the goal setup screen.
                // Output: The onboarding interface.

                onboardingView()
            }
        }
    }
}
