//
//  CurrentDayViewModel.swift
//  MyApp
//
//  Created by Lujain on 01/06/1448 AH.
//

import Foundation
import Observation

// MARK: - Current Day ViewModel

// Input: The selected learning period and saved activity history.
// Description: Manages learning, freezes, streaks, and goal progress.
// Output: Updated activity counts, streak values, and goal status.

@Observable
class CurrentDayViewModel {

    // MARK: - Properties

    var activity = LearningActivity()
    var streak = LearningStreak()
    var goal: LearningGoal

    let history: LearningHistoryStore

    private let calendar = Calendar.current

    private let streakCountKey = "currentStreak"
    private let lastActivityKey = "lastActivityDate"
    private let streakGoalStartKey = "streakGoalStartDate"

    var isGoalEnded = false


    // MARK: - Initialization

    // Input: The selected learning period.
    // Description: Loads the saved goal, activity history,
    //              and streak information.
    // Output: An initialized ViewModel with restored data.

    init(selectedPeriod: LearningPeriod) {

        let defaults = UserDefaults.standard

        let savedStartDate = defaults.object(
            forKey: "goalStartDate"
        ) as? Date

        self.goal = LearningGoal(
            startDate: savedStartDate ?? Date(),
            period: selectedPeriod
        )

        self.history = LearningHistoryStore()

        let storedStreakStart = defaults.object(
            forKey: "streakGoalStartDate"
        ) as? Date

        if let storedStreakStart,
           calendar.isDate(
                storedStreakStart,
                equalTo: goal.startDate,
                toGranularity: .second
           ) {

            streak.currentStreak = defaults.integer(
                forKey: "currentStreak"
            )

            streak.lastActivityDate = defaults.object(
                forKey: "lastActivityDate"
            ) as? Date
        }

        updateActivityCounters()
        refreshStatus()
    }


    // MARK: - Goal Information

    // Input: The goal start date and selected period.
    // Description: Calculates the end date of the learning goal.
    // Output: The goal's end date.

    var goalEndDate: Date {

        let start = calendar.startOfDay(for: goal.startDate)

        switch selectedPeriod {

        case .week:
            return calendar.date(
                byAdding: .day,
                value: 7,
                to: start
            )!

        case .month:
            return calendar.date(
                byAdding: .month,
                value: 1,
                to: start
            )!

        case .year:
            return calendar.date(
                byAdding: .year,
                value: 1,
                to: start
            )!
        }
    }


    // Input: The learning goal.
    // Description: Retrieves the current goal status.
    // Output: Active, expired, or completed.

    var goalStatus: GoalStatus {
        goal.status
    }


    // Input: A request to mark the goal as ended.
    // Description: Updates the goal-ended flag.
    // Output: Sets isGoalEnded to true.

    func endGoal() {
        isGoalEnded = true
    }


    // Input: The goal's saved period.
    // Description: Provides the selected learning duration.
    // Output: Week, Month, or Year.

    var selectedPeriod: LearningPeriod {
        goal.period
    }


    // Input: The goal's saved start date.
    // Description: Provides the beginning of the current goal.
    // Output: The goal start date.

    var goalStartDate: Date {
        goal.startDate
    }


    // MARK: - Freeze Limits

    // Input: The selected learning period.
    // Description: Determines the maximum allowed freezes.
    // Output: 2, 8, or 96 freeze days.

    var maxFreezes: Int {

        switch selectedPeriod {

        case .week:
            return 2

        case .month:
            return 8

        case .year:
            return 96
        }
    }


    // Input: The maximum and used freeze counts.
    // Description: Calculates the remaining available freezes.
    // Output: A nonnegative number of remaining freezes.

    var remainingFreezes: Int {
        max(0, maxFreezes - activity.freezedDays)
    }


    // MARK: - Daily Activity State

    // Input: Today's date and saved learning history.
    // Description: Checks whether today is registered as Learned.
    // Output: True if Learned; otherwise false.

    var isLearnedToday: Bool {
        history.isLearned(Date())
    }


    // Input: Today's date and saved freeze history.
    // Description: Checks whether today is registered as Freeze.
    // Output: True if frozen; otherwise false.

    var isFreezedToday: Bool {
        history.isFreezed(Date())
    }


    // Input: Goal status and today's learning registration.
    // Description: Determines whether learning can be recorded.
    // Output: True if registration is allowed.

    var canLogLearning: Bool {
        goal.status == .active
        && isInCurrentGoal(Date())
        && !isLearnedToday
    }


    // Input: Goal status, today's freeze state,
    //        and remaining freeze allowance.
    // Description: Determines whether Freeze can be recorded.
    // Output: True if a freeze is allowed.

    var canFreeze: Bool {
        goal.status == .active
        && isInCurrentGoal(Date())
        && !isFreezedToday
        && remainingFreezes > 0
    }


    // MARK: - Log Learning

    // Input: Today's activity state.
    // Description: Registers Learned, replacing Freeze if needed,
    //              and increments the streak once.
    // Output: Updated history, activity counts, and streak.

    func logLearning() {

        refreshStatus()

        guard canLogLearning else { return }

        let now = Date()

        registerStreakActivity(at: now)

        history.addLearnedDate(now)

        updateActivityCounters()
        saveStreak()
    }


    // MARK: - Remove Learning

    // Input: Today's Learned registration.
    // Description: Removes today's learning record and
    //              reverses its streak increment.
    // Output: Updated history, counters, and streak.

    func removeLearning() {

        guard isLearnedToday else { return }

        history.removeLearnedDate()

        streak.currentStreak = max(
            0,
            streak.currentStreak - 1
        )

        restoreLastActivityDate()

        updateActivityCounters()
        saveStreak()
    }


    // MARK: - Freeze Day

    // Input: Today's activity and remaining freeze allowance.
    // Description: Registers Freeze without increasing
    //              the streak, replacing Learned if needed.
    // Output: Updated freeze history, counters, and activity time.

    func freezeDay() {

        refreshStatus()

        guard canFreeze else { return }

        let now = Date()

        if isLearnedToday {

            streak.currentStreak = max(
                0,
                streak.currentStreak - 1
            )
        }

        history.addFreezedDate(now)

        // Freeze preserves the streak without adding a day.
        streak.lastActivityDate = now

        updateActivityCounters()
        saveStreak()
    }


    // MARK: - Remove Freeze

    // Input: Today's Freeze registration.
    // Description: Removes the freeze and restores
    //              the latest remaining activity date.
    // Output: Updated history and freeze counters.

    func removeFreeze() {

        guard isFreezedToday else { return }

        history.removeFreezedDate()

        restoreLastActivityDate()

        updateActivityCounters()
        saveStreak()
    }


    // MARK: - Activity Counters

    // Input: Saved Learned and Freeze dates within the goal.
    // Description: Synchronizes activity data with the history
    //              and recalculates activity counters.
    // Output: Updated LearningActivity properties.

    private func updateActivityCounters() {

        let start = calendar.startOfDay(
            for: goalStartDate
        )

        let learnedCount = history.learnedDates.filter {
            $0 >= start && $0 < goalEndDate
        }.count

        let freezeCount = history.freezedDates.filter {
            $0 >= start && $0 < goalEndDate
        }.count

        activity.learnedDates = history.learnedDates
        activity.freezedDates = history.freezedDates

        activity.freezedDays = freezeCount

        activity.learnedDays = max(
            0,
            learnedCount - freezeCount
        )

        activity.isFreezed = isFreezedToday
    }


    // MARK: - Streak Management

    // Input: The date of a new Learned registration.
    // Description: Checks streak expiration and adds
    //              one day for the new learning record.
    // Output: Updated currentStreak and lastActivityDate.

    private func registerStreakActivity(at date: Date) {

        updateStreak(now: date)

        streak.currentStreak += 1
        streak.lastActivityDate = date
    }


    // Input: The current date.
    // Description: Resets the streak after 32 hours
    //              without a valid learning or freeze activity.
    // Output: A reset streak if the inactivity limit is reached.

    func updateStreak(now: Date = Date()) {

        guard goal.status == .active else { return }

        guard let lastDate = streak.lastActivityDate else {
            return
        }

        if now.timeIntervalSince(lastDate) >= 32 * 60 * 60 {

            streak.currentStreak = 0
            streak.lastActivityDate = nil

            saveStreak()
        }
    }


    // MARK: - Restore Last Activity

    // Input: The remaining Learned and Freeze dates.
    // Description: Finds the latest remaining recorded day
    //              after an activity is removed.
    // Output: Updates lastActivityDate or clears it.

    private func restoreLastActivityDate() {

        streak.lastActivityDate = (
            history.learnedDates.union(
                history.freezedDates
            )
        ).max()
    }


    // MARK: - Save Streak

    // Input: The current streak and last activity date.
    // Description: Persists streak data using UserDefaults.
    // Output: Saved streak information for future app sessions.

    private func saveStreak() {

        let defaults = UserDefaults.standard

        defaults.set(
            streak.currentStreak,
            forKey: streakCountKey
        )

        if let lastDate = streak.lastActivityDate {

            defaults.set(
                lastDate,
                forKey: lastActivityKey
            )

        } else {

            defaults.removeObject(
                forKey: lastActivityKey
            )
        }

        defaults.set(
            goal.startDate,
            forKey: streakGoalStartKey
        )
    }


    // MARK: - Goal Status

    // Input: The current date.
    // Description: Checks goal expiration and completion.
    // Output: Updated goal status and streak state.

    func refreshStatus(now: Date = Date()) {

        guard goal.status == .active else { return }

        if now >= goalEndDate {

            goal.status = allGoalDaysRegistered
                ? .done
                : .expired

            streak.currentStreak = 0
            streak.lastActivityDate = nil

            saveStreak()

            return
        }

        updateStreak(now: now)
    }


    // MARK: - Goal Date Validation

    // Input: A date.
    // Description: Checks whether the date belongs
    //              to the current learning goal.
    // Output: True if inside the goal; otherwise false.

    private func isInCurrentGoal(_ date: Date) -> Bool {

        let day = calendar.startOfDay(for: date)
        let start = calendar.startOfDay(for: goalStartDate)

        return day >= start && day < goalEndDate
    }


    // MARK: - Goal Completion

    // Input: All registered goal dates.
    // Description: Checks that each goal day is recorded
    //              and the freeze limit is respected.
    // Output: True if the goal is complete.

    private var allGoalDaysRegistered: Bool {

        var day = calendar.startOfDay(for: goalStartDate)

        while day < goalEndDate {

            let isRegistered =
                history.learnedDates.contains(day)
                || history.freezedDates.contains(day)

            if !isRegistered {
                return false
            }

            guard let nextDay = calendar.date(
                byAdding: .day,
                value: 1,
                to: day
            ) else {
                return false
            }

            day = nextDay
        }

        return goalFreezeCount <= maxFreezes
    }


    // MARK: - Goal Freeze Count

    // Input: Freeze dates during the current goal.
    // Description: Counts the freezes used within the goal period.
    // Output: The number of registered freeze days.

    private var goalFreezeCount: Int {

        history.freezedDates.filter {
            $0 >= calendar.startOfDay(for: goalStartDate)
            && $0 < goalEndDate
        }.count
    }
}
