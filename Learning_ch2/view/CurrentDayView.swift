
//
//  CurrentDay.swift
//  MyApp
//
//  Created by Lujain on 29/05/1448 AH.
//

import SwiftUI
import Playgrounds

// MARK: - Current Day View

// Input: The selected learning period and saved activity history.
// Description: Displays daily learning activities, streaks,
//              freezes, and the weekly calendar.
// Output: An interactive activity tracking screen.

struct CurrentDayView: View {

    // MARK: - Properties

    @State private var viewModel: CurrentDayViewModel
    @State private var statusTimer: Timer?

    @Environment(\.scenePhase) private var scenePhase

    // MARK: - Initialization

    // Input: The selected learning period.
    // Description: Initializes the activity ViewModel.
    // Output: A ViewModel configured for the selected period.

    init(selectedPeriod: LearningPeriod) {
        _viewModel = State(
            initialValue: CurrentDayViewModel(
                selectedPeriod: selectedPeriod
            )
        )
    }

    // MARK: - View Body

    // Input: Activity history, goal status, and streak data.
    // Description: Builds the main activity interface.
    // Output: The CurrentDayView screen.

    var body: some View {

        NavigationStack {

            let calendar = Calendar.current

            VStack {

                // MARK: - Header

                // Input: User navigation actions.
                // Description: Displays the activity title
                //              and navigation buttons.
                // Output: Header with calendar and goal links.

                HStack {

                    Text("Activity")
                        .font(.system(size: 40))
                        .fontWeight(.heavy)

                    Spacer()

                    Group {

                        NavigationLink {
                            BeginningView()
                        } label: {
                            Image(systemName: "calendar")
                        }
                        .frame(width: 44, height: 44)

                        NavigationLink {
                            LearningGoalView()
                        } label: {
                            Image(systemName: "pencil.and.outline")
                        }
                        .frame(width: 44, height: 44)

                    }
                    .glassEffect()
                    .foregroundStyle(.white)
                }

                // MARK: - Current Date

                // Input: The current system date.
                // Description: Displays the weekday, day, and month.
                // Output: A formatted date label.

                Text(
                    Date(),
                    format: .dateTime
                        .weekday(.wide)
                        .day()
                        .month(.wide)
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.gray)

                // MARK: - Weekly Calendar

                // Input: The current week and saved activity dates.
                // Description: Displays seven days with activity colors.
                // Output: A weekly calendar.

                HStack(spacing: 12) {

                    ForEach(0..<7, id: \.self) { day in

                        if let startOfWeek = calendar.dateInterval(
                            of: .weekOfYear,
                            for: Date()
                        )?.start,

                        let date = calendar.date(
                            byAdding: .day,
                            value: day,
                            to: startOfWeek
                        ) {

                            VStack(spacing: 8) {

                                Text(
                                    date,
                                    format: .dateTime.weekday(.narrow)
                                )
                                .font(.system(size: 18))
                                .font(.caption)

                                Text(
                                    date,
                                    format: .dateTime.day()
                                )
                                .font(.system(size: 18))
                                .font(.headline)

                                // MARK: - Calendar Day Colors

                                // Input: The saved activity status.
                                // Description: Displays translucent orange
                                //              for Learned, translucent blue
                                //              for Freeze, and solid orange
                                //              for an unregistered current day.
                                // Output: A colored circle behind the date.

                                .background {

                                    if viewModel.history.isLearned(date) {

                                        Circle()
                                            .fill(
                                                Color(
                                                    red: 1,
                                                    green: 146/255,
                                                    blue: 48/255
                                                )
                                                .opacity(0.45)
                                            )
                                            .frame(
                                                width: 40,
                                                height: 40
                                            )

                                    } else if viewModel.history.isFreezed(date) {

                                        Circle()
                                            .fill(
                                                Color(
                                                    red: 60/255,
                                                    green: 211/255,
                                                    blue: 254/255
                                                )
                                                .opacity(0.45)
                                            )
                                            .frame(
                                                width: 40,
                                                height: 40
                                            )

                                    } else if calendar.isDate(
                                        date,
                                        inSameDayAs: Date()
                                    ) {

                                        Circle()
                                            .fill(
                                                Color(
                                                    red: 1,
                                                    green: 146/255,
                                                    blue: 48/255
                                                )
                                            )
                                            .frame(
                                                width: 40,
                                                height: 40
                                            )
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding()

                // MARK: - Activity Cards

                // Input: Current streak and freeze usage.
                // Description: Displays learning statistics.
                // Output: Learned and Freezed cards.

                HStack(spacing: 12) {

                    // MARK: - Learned Card

                    // Input: The current streak count.
                    // Description: Displays the learning streak.
                    // Output: A Learned card with a flame icon.

                    VStack {

                        Image(systemName: "flame.fill")
                            .foregroundStyle(.orange)

                        Text(
                            "\(viewModel.streak.currentStreak) \(viewModel.streak.currentStreak == 1 ? "day" : "days")"
                        )
                        .font(.system(size: 16))
                        .bold()

                        Text("Learned")
                            .font(.system(size: 12))
                    }
                    .frame(width: 177, height: 102)
                    .background(
                        Color(white: 0.10),
                        in: RoundedRectangle(cornerRadius: 35)
                    )
                    .glassEffect(
                        .regular.tint(
                            Color.black.opacity(0.8)
                        ),
                        in: .rect(cornerRadius: 35)
                    )
                    .shadow(
                        color: .white.opacity(0.10),
                        radius: 7,
                        x: 0,
                        y: 2
                    )

                    // MARK: - Freezed Card

                    // Input: The number of used freezes.
                    // Description: Displays freeze activity statistics.
                    // Output: A Freezed card with a snowflake icon.

                    VStack {

                        Image(systemName: "snowflake")
                            .foregroundStyle(.cyan)

                        Text(
                            "\(viewModel.activity.freezedDays) \(viewModel.activity.freezedDays == 1 ? "day" : "days")"
                        )
                        .font(.system(size: 16))
                        .bold()

                        Text("Freezed")
                            .font(.system(size: 12))
                    }
                    .frame(width: 177, height: 102)
                    .background(
                        Color(white: 0.10),
                        in: RoundedRectangle(cornerRadius: 35)
                    )
                    .glassEffect(
                        .regular.tint(
                            Color.black.opacity(0.8)
                        ),
                        in: .rect(cornerRadius: 35)
                    )
                    .shadow(
                        color: .white.opacity(0.10),
                        radius: 7,
                        x: 0,
                        y: 2
                    )
                }

                // MARK: - Goal Status Content

                // Input: The current goal status.
                // Description: Displays activity buttons or
                //              goal completion messages.
                // Output: Active, expired, or completed content.

                VStack {

                    switch viewModel.goalStatus {

                    case .active:

                        // MARK: - Log as Learned Button

                        // Input: Today's Learned registration state.
                        // Description: Toggles today's learning record.
                        // Output: Registers or removes Learned
                        //         and updates the streak.

                        Button("Log as Learned") {

                            if viewModel.isLearnedToday {
                                viewModel.removeLearning()
                            } else {
                                viewModel.logLearning()
                            }
                        }
                        .frame(width: 272, height: 272)
                        .glassEffect(
                            .regular.tint(
                                viewModel.isLearnedToday
                                ? Color.black.opacity(0.8)
                                : Color(
                                    red: 1,
                                    green: 146/255,
                                    blue: 48/255
                                )
                            ),
                            in: .circle
                        )
                        .foregroundStyle(
                            viewModel.isLearnedToday
                            ? Color.gray
                            : Color.white
                        )
                        .font(
                            .system(size: 25, weight: .bold)
                        )
                        .disabled(
                            !viewModel.isLearnedToday
                            && !viewModel.canLogLearning
                        )

                        Spacer()

                        // MARK: - Freeze for a Day Button

                        // Input: Today's freeze state and available freezes.
                        // Description: Toggles today's Freeze registration
                        //              without increasing the streak.
                        // Output: Registers or removes Freeze
                        //         and updates activity counters.

                        Button("Freeze for a day") {

                            if viewModel.isFreezedToday {
                                viewModel.removeFreeze()
                            } else {
                                viewModel.freezeDay()
                            }
                        }
                        .frame(width: 272, height: 46)
                        .glassEffect(
                            .regular.tint(
                                viewModel.isFreezedToday
                                ? Color.black.opacity(0.8)
                                : viewModel.canFreeze
                                    ? Color(
                                        red: 60/255,
                                        green: 211/255,
                                        blue: 254/255
                                    )
                                    : Color.black.opacity(0.5)
                            ),
                            in: .rect(cornerRadius: 22)
                        )
                        .foregroundStyle(
                            viewModel.isFreezedToday
                            ? Color.gray
                            : viewModel.canFreeze
                                ? Color.white
                                : Color.gray.opacity(0.6)
                        )
                        .font(.system(size: 25))
                        .disabled(
                            !viewModel.isFreezedToday
                            && !viewModel.canFreeze
                        )

                        // MARK: - Freeze Usage

                        // Input: Used and maximum freeze counts.
                        // Description: Displays remaining freeze information.
                        // Output: A summary of used freezes.

                        Text(
                            "\(viewModel.activity.freezedDays) out of \(viewModel.maxFreezes) Freezes used"
                        )

                    case .expired:

                        // MARK: - Expired Goal

                        // Input: An expired learning goal.
                        // Description: Displays a goal expiration message.
                        // Output: A message encouraging a new goal.

                        Spacer()

                        Image(systemName: "xmark.seal.fill")
                            .font(.system(size: 55))
                            .foregroundStyle(.orange)

                        Text("You didn't reach your goal this time.")
                            .font(
                                .system(size: 20, weight: .bold)
                            )

                        Text("Want to set another goal?")
                            .foregroundStyle(.gray)

                        Spacer()

                        NavigationLink {
                            LearningGoalView()
                        } label: {

                            Label(
                                "Set a Goal",
                                systemImage: "pencil.and.outline"
                            )
                            .font(.system(size: 18))
                            .foregroundStyle(.white)
                            .frame(width: 140, height: 50)
                            .glassEffect(
                                .regular.tint(
                                    Color(
                                        red: 1,
                                        green: 146/255,
                                        blue: 48/255
                                    )
                                ),
                                in: .rect(cornerRadius: 25)
                            )
                        }

                        Spacer()

                    case .done:

                        // MARK: - Completed Goal

                        // Input: A completed learning goal.
                        // Description: Displays a success message.
                        // Output: A message encouraging the next goal.

                        Spacer()

                        Image(systemName: "hands.clap.fill")
                            .font(.system(size: 55))
                            .foregroundStyle(.orange)

                        Text("Will done!")
                            .font(
                                .system(size: 28, weight: .bold)
                            )

                        Text("Ready for your next goal?")
                            .foregroundStyle(.gray)

                        Spacer()

                        NavigationLink {
                            LearningGoalView()
                        } label: {

                            Label(
                                "Set a Goal",
                                systemImage: "pencil.and.outline"
                            )
                            .font(.system(size: 18))
                            .foregroundStyle(.white)
                            .frame(width: 140, height: 50)
                            .glassEffect(
                                .regular.tint(
                                    Color(
                                        red: 1,
                                        green: 146/255,
                                        blue: 48/255
                                    )
                                ),
                                in: .rect(cornerRadius: 25)
                            )
                        }

                        Spacer()
                    }
                }
            }
        }

        // MARK: - Goal and Streak Timer

        // Input: The current goal and streak information.
        // Description: Starts a timer that checks goal status
        //              and streak expiration every second.
        // Output: Keeps the goal and streak status updated.

        .onAppear {

            viewModel.refreshStatus()

            statusTimer?.invalidate()

            statusTimer = Timer.scheduledTimer(
                withTimeInterval: 1,
                repeats: true
            ) { _ in
                viewModel.refreshStatus()
            }
        }

        // MARK: - App Lifecycle

        // Input: Changes in the app scene phase.
        // Description: Refreshes goal and streak status
        //              when the app becomes active.
        // Output: Updated activity and goal state.

        .onChange(of: scenePhase) { _, newPhase in

            if newPhase == .active {
                viewModel.refreshStatus()
            }
        }

        // MARK: - Timer Cleanup

        // Input: The activity view disappearing.
        // Description: Stops the active status timer.
        // Output: Invalidates and clears the timer.

        .onDisappear {

            statusTimer?.invalidate()
            statusTimer = nil
        }
    }
}

// MARK: - Preview

#Preview {
    CurrentDayView(selectedPeriod: .week)
        .preferredColorScheme(.dark)
}
