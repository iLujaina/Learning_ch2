//
//  CurrentDayViewModel.swift
//  MyApp
//
//  Created by Lujain on 01/06/1448 AH.
//

import Foundation
import Observation

@Observable
class CurrentDayViewModel {

    var activity = LearningActivity()
    var streak = LearningStreak()
    var goal: LearningGoal
    
    private let calendar = Calendar.current

    init(selectedPeriod: LearningPeriod) {
        self.goal = LearningGoal(
            startDate: Date(),
            period: selectedPeriod
        )
    }
    var isGoalEnded = false

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

    var goalStatus: GoalStatus {
        goal.status
    }
        
    func endGoal() {
        isGoalEnded = true
    }
   
    var selectedPeriod: LearningPeriod {
        goal.period
    }
    var goalStartDate: Date {
        goal.startDate
    }
    
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
    var isLearnedToday: Bool {
        activity.learnedDates.contains(
            calendar.startOfDay(for: Date())
        )
    }

    var isFreezedToday: Bool {
        activity.freezedDates.contains(
            calendar.startOfDay(for: Date())
        )
    }
    var canLogLearning: Bool {
        !isLearnedToday
    }

    var canFreeze: Bool {
        !isFreezedToday && remainingFreezes > 0
    }
 
    
    func logLearning() {
        refreshStatus()
        guard canLogLearning else { return }

        let now = Date()
        let today = calendar.startOfDay(for: now)

        let wasFreezed = activity.freezedDates.contains(today)

        if wasFreezed {
            activity.freezedDates.remove(today)
        } else {
            registerStreakActivity(at: now)
        }

        activity.learnedDates.insert(today)
        activity.isFreezed = false

        updateActivityCounters()
    }
    
   
    func freezeDay() {
        refreshStatus()
        guard canFreeze else { return }

        let now = Date()
        let today = calendar.startOfDay(for: now)

        let wasLearned = activity.learnedDates.contains(today)

        if wasLearned {
            activity.learnedDates.remove(today)
        } else {
            registerStreakActivity(at: now)
        }

        activity.freezedDates.insert(today)
        activity.isFreezed = true

        updateActivityCounters()
    }

   
    var remainingFreezes: Int {
        max(0, maxFreezes - activity.freezedDays)
    }
    private func isInCurrentGoal(_ date: Date) -> Bool {
        let day = calendar.startOfDay(for: date)
        let start = calendar.startOfDay(for: goalStartDate)

        return day >= start && day < goalEndDate
    }
    
    private func updateActivityCounters() {
        let start = calendar.startOfDay(for: goalStartDate)

        let learnedCount = activity.learnedDates.filter {
            $0 >= start && $0 < goalEndDate
        }.count

        let freezeCount = activity.freezedDates.filter {
            $0 >= start && $0 < goalEndDate
        }.count

        activity.freezedDays = freezeCount

        activity.learnedDays = max(
            0,
            learnedCount - freezeCount
        )
    }

    private func registerStreakActivity(at date: Date) {
        let today = calendar.startOfDay(for: date)

        if let lastDate = streak.lastActivityDate,
           calendar.isDate(lastDate, inSameDayAs: today) {
            return
        }

        updateStreak(now: date)

        streak.currentStreak += 1
        streak.lastActivityDate = date
    }
    func refreshStatus(now: Date = Date()) {

        guard goal.status == .active else { return }

        if now >= goalEndDate {

            goal.status = allGoalDaysRegistered
                ? .done
                : .expired

            streak.currentStreak = 0
            streak.lastActivityDate = nil

            return
        }

        updateStreak(now: now)
    }
    func updateStreak(now: Date = Date()) {

        guard goal.status == .active else { return }

        let lastDate = streak.lastActivityDate ?? goalStartDate

        if now.timeIntervalSince(lastDate) >= 32 * 60 * 60 {
            streak.currentStreak = 0
            streak.lastActivityDate = nil
        }
    }
    private var allGoalDaysRegistered: Bool {

        var day = calendar.startOfDay(for: goalStartDate)

        while day < goalEndDate {

            let isRegistered =
                activity.learnedDates.contains(day) ||
                activity.freezedDates.contains(day)

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
    private var goalFreezeCount: Int {
        activity.freezedDates.filter {
            $0 >= calendar.startOfDay(for: goalStartDate)
            && $0 < goalEndDate
        }.count
    }
   
}
