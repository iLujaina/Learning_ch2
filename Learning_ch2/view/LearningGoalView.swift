//
//  LearningGoal.swift
//  MyApp
//
//  Created by Lujain on 01/06/1448 AH.
//


import SwiftUI
import Playgrounds

// MARK: - Learning Goal View

// Input: The saved goal name and selected learning period.
// Description: Allows users to edit and update their goal.
// Output: Saves the new goal and opens the activity screen.

struct LearningGoalView: View {

    // MARK: - Properties

    @State private var showPopup = false
    @State private var navigateToCurrentDay = false

    @State private var viewModel = LearningGoalViewModel()


    // MARK: - View Body

    var body: some View {

        NavigationStack {

            VStack(alignment: .leading, spacing: 20) {

                // MARK: - Goal Name

                Text("I want to learn")

                TextField("Swift", text: $viewModel.goalName)
                    .textFieldStyle(.roundedBorder)


                // MARK: - Learning Period

                Text("I want to learn it in a")

                HStack(spacing: 12) {

                    Button("Week") {
                        viewModel.selectedPeriod = .week
                    }
                    .frame(width: 84, height: 46)
                    .glassEffect(
                        .regular.tint(
                            viewModel.selectedPeriod == .week
                            ? .orange : .clear
                        ),
                        in: .capsule
                    )
                    .foregroundStyle(.white)


                    Button("Month") {
                        viewModel.selectedPeriod = .month
                    }
                    .frame(width: 84, height: 46)
                    .glassEffect(
                        .regular.tint(
                            viewModel.selectedPeriod == .month
                            ? .orange : .clear
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
                            ? .orange : .clear
                        ),
                        in: .capsule
                    )
                    .foregroundStyle(.white)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Learning Goal")
            .navigationBarTitleDisplayMode(.inline)


            // MARK: - Toolbar

            // Input: The checkmark button tap.
            // Description: Opens the update confirmation popup.
            // Output: Displays the confirmation popup.

            .toolbar {

                ToolbarItem(placement: .topBarTrailing) {

                    Button {

                        withAnimation(.easeInOut(duration: 0.25)) {
                            showPopup = true
                        }

                    } label: {

                        Image(systemName: "checkmark")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 36, height: 36)
                            .background(.orange, in: Circle())
                    }
                    .buttonStyle(.plain)
                }
            }


            // MARK: - Custom Popup

            // Input: The user's confirmation to update the goal.
            // Description: Displays confirmation and cancellation.
            // Output: Saves the new goal after confirmation.

            .overlay {

                if showPopup {

                    ZStack {

                        Color.black.opacity(0.55)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation {
                                    showPopup = false
                                }
                            }

                        VStack(alignment: .leading, spacing: 20) {

                            Text("Update goal")
                                .font(.system(size: 23, weight: .bold))
                                .foregroundStyle(.white)

                            Text("If you update now, your streak will start over.")
                                .font(.system(size: 20))
                                .foregroundStyle(.gray)
                                .fixedSize(
                                    horizontal: false,
                                    vertical: true
                                )

                            HStack(spacing: 10) {

                                // MARK: - Dismiss Button

                                Button {

                                    withAnimation {
                                        showPopup = false
                                    }

                                } label: {

                                    Text("Dismiss")
                                        .font(.system(size: 20))
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 56)
                                }
                                .foregroundStyle(.white)
                                .background(
                                    Color.gray.opacity(0.25),
                                    in: Capsule()
                                )


                                // MARK: - Update Button

                                // Input: Updated goal name and period.
                                // Description: Saves the goal if valid.
                                // Output: Opens CurrentDayView
                                //         with the selected period.

                                Button {

                                    guard viewModel.saveGoal() else {
                                        return
                                    }

                                    showPopup = false
                                    navigateToCurrentDay = true

                                } label: {

                                    Text("Update")
                                        .font(.system(size: 20))
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 56)
                                }
                                .foregroundStyle(.white)
                                .background(
                                    Color.orange,
                                    in: Capsule()
                                )
                            }
                            .padding(.top, 10)
                        }
                        .padding(24)
                        .frame(maxWidth: 350)
                        .glassEffect(
                            .regular.tint(Color.black.opacity(0.8)),
                            in: .rect(cornerRadius: 35)
                        )
                        .padding(.horizontal, 20)
                        .transition(
                            .scale(scale: 0.95)
                                .combined(with: .opacity)
                        )
                    }
                    .zIndex(10)
                }
            }


            // MARK: - Navigation

            // Input: The successfully saved learning period.
            // Description: Navigates to the updated goal.
            // Output: CurrentDayView with the new period.

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
    LearningGoalView()
        .preferredColorScheme(.dark)
}
