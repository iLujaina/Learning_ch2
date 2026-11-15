//
//  LearningGoal.swift
//  MyApp
//
//  Created by Lujain on 01/06/1448 AH.
//


import SwiftUI
import Playgrounds

struct LearningGoalView: View {

    @State private var showPopup = false
    @State private var navigateToCurrentDay = false
    @State private var learn = ""
    @State private var selectedPeriod: LearningPeriod = .week
    @AppStorage("hasSavedGoal") private var hasSavedGoal = false
    @AppStorage("goalName") private var savedGoalName = ""
    @AppStorage("goalPeriod") private var savedGoalPeriod = "Week"
    @AppStorage("goalStartDate") private var savedGoalStartDate = 0.0
    @State private var viewModel = LearningGoalViewModel()
    var body: some View {

        NavigationStack {

            VStack(alignment: .leading, spacing: 20) {

                Text("I want to learn")

                TextField("Swift", text: $learn)
                    .textFieldStyle(.roundedBorder)

                Text("I want to learn it in a")

                HStack(spacing: 12) {

                    Button("Week") {
                        selectedPeriod = .week
                    }
                    .frame(width: 84, height: 46)
                    .glassEffect(
                        .regular.tint(
                            selectedPeriod == .week ? .orange : .clear
                        ),
                        in: .capsule
                    )
                    .foregroundStyle(.white)

                    Button("Month") {
                        selectedPeriod = .month
                    }
                    .frame(width: 84, height: 46)
                    .glassEffect(
                        .regular.tint(
                            selectedPeriod == .month ? .orange : .clear
                        ),
                        in: .capsule
                    )
                    .foregroundStyle(.white)

                    Button("Year") {
                        selectedPeriod = .year
                    }
                    .frame(width: 84, height: 46)
                    .glassEffect(
                        .regular.tint(
                            selectedPeriod == .year ? .orange : .clear
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
                                .fixedSize(horizontal: false, vertical: true)

                            HStack(spacing: 10) {

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

                                Button {
                                    viewModel.saveGoal()
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

            .navigationDestination(isPresented: $navigateToCurrentDay) {
                CurrentDayView(selectedPeriod: selectedPeriod)
            }
        }
    }
}

#Preview {
    LearningGoalView()
        .preferredColorScheme(.dark)
}
