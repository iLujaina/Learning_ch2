import SwiftUI

@main
struct MyApp: App {

    @State private var appViewModel = AppViewModel()

    var body: some Scene {
        WindowGroup {

            if appViewModel.hasSavedGoal {
                CurrentDayView(
                    selectedPeriod: .week
                )
            } else {
                onboardingView()
            }
        }
    }
}
