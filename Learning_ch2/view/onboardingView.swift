//
//  onboardingView.swift
//  MyApp
//
//  Created by Lujain on 29/05/1448 AH.
//

//
//  onboardingView.swift
//  MyApp
//
//  Created by Lujain on 29/05/1448 AH.
//

import SwiftUI
import Playgrounds

// MARK: - Onboarding View

// Input: The user's learning goal name and selected period.
// Description: Displays the onboarding screen and collects
//              the information needed to create a learning goal.
// Output: Saves a new goal and opens CurrentDayView.

struct onboardingView: View {

    // MARK: - Properties

    @State private var viewModel = LearningGoalViewModel()

    @State private var navigateToCurrentDay = false


    // MARK: - View Body

    // Input: The learning goal name and selected period.
// Description: Builds the onboarding interface.
// Output: A screen for creating a new learning goal.

    var body: some View {

        NavigationStack {

            VStack {

                // MARK: - Welcome Section

                // Input: None.
                // Description: Displays the welcome icon and title.
                // Output: The onboarding welcome section.

                VStack(spacing: 70) {

                    Image(systemName: "flame.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(.orange)
                        .padding()

                    Text("Hello **Learner**")
                        .font(.system(size: 34))
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                }


                // MARK: - Goal Input

                // Input: The goal name entered by the user.
                // Description: Connects the text field directly
                //              to LearningGoalViewModel.
                // Output: An updated goalName value.

                Group {

                    Text("This app will help you learn everyday!")
                        .font(.system(size: 17))
                        .foregroundStyle(.gray)

                    Text("I want to learn")
                        .font(.system(size: 16))
                        .font(.headline)
                        .padding()

                    TextField(
                        "Swift",
                        text: $viewModel.goalName
                    )

                    Text("I want to learn it in a ")
                        .padding()
                }
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )


                // MARK: - Learning Period Selection

                // Input: The user's selected learning period.
                // Description: Updates the period in the ViewModel.
                // Output: Week, Month, or Year selection.

                HStack(spacing: 12) {

                    Button("Week") {

                        viewModel.selectedPeriod = .week

                    }
                    .frame(width: 84, height: 46)
                    .glassEffect(
                        .regular.tint(
                            viewModel.selectedPeriod == .week
                            ? .orange
                            : .clear
                        ),
                        in: .capsule
                    )
                    .foregroundStyle(.white)
                    .cornerRadius(22)


                    Button("Month") {

                        viewModel.selectedPeriod = .month

                    }
                    .frame(width: 84, height: 46)
                    .glassEffect(
                        .regular.tint(
                            viewModel.selectedPeriod == .month
                            ? .orange
                            : .clear
                        ),
                        in: .capsule
                    )
                    .foregroundStyle(.white)


                    Button("Year") {

                        viewModel.selectedPeriod = .year

                    }
                    .frame(width: 84, height: 46)
                    .glassEffect(
                        .regular.tint(
                            viewModel.selectedPeriod == .year
                            ? .orange
                            : .clear
                        ),
                        in: .capsule
                    )
                    .foregroundStyle(.white)

                }
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )


                Spacer()


                // MARK: - Start Learning Button

                // Input: The goal name and selected period.
                // Description: Requests goal validation and saving
                //              through LearningGoalViewModel.
                // Output: Navigates to CurrentDayView after
                //         a successful save.

                Button {

                    guard viewModel.saveGoal() else {
                        return
                    }

                    navigateToCurrentDay = true

                } label: {

                    Text("Start Learning")
                        .frame(width: 151, height: 46)
                        .background(.orange)
                        .foregroundStyle(.white)
                        .cornerRadius(22)
                }
                .disabled(!viewModel.canSaveGoal)
                .opacity(
                    viewModel.canSaveGoal ? 1 : 0.5
                )


                Text("You can edit your desire later")

            }

            // MARK: - Navigation

            // Input: A successfully saved learning goal.
            // Description: Opens the activity screen
            //              using the selected goal period.
            // Output: CurrentDayView.

            .navigationDestination(
                isPresented: $navigateToCurrentDay
            ) {

                CurrentDayView(
                    selectedPeriod: viewModel.selectedPeriod
                )
            }
        }
    }
}


// MARK: - Preview

#Preview {

    onboardingView()
        .preferredColorScheme(.dark)
}


// MARK: - Playground

#Playground {
    _ = 1 + 2
}
