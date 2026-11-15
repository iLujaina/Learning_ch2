//
//  Model.swift
//  MyApp
//
//  Created by Lujain on 30/05/1448 AH.
//

import Foundation

enum LearningPeriod: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
}

struct LearningActivity {
    var learnedDays: Int = 0
    var freezedDays: Int = 0
    var isFreezed: Bool = false
    var learnedDates: Set<Date> = []
    var freezedDates: Set<Date> = []
}

struct FreezeData {
    let freezesPerWeek: Int = 2
    let freezesPerMonth: Int = 8
    let freezesPerYear: Int = 96
}
enum GoalStatus {
    case active
    case expired
    case done
}

struct LearningGoal {
    var startDate: Date
    var period: LearningPeriod
    var status: GoalStatus = .active
}

struct LearningStreak {
    var currentStreak: Int = 0
    var lastActivityDate: Date? = nil
}
