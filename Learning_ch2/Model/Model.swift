//
//  Model.swift
//  MyApp
//
//  Created by Lujain on 30/05/1448 AH.
//

import Foundation

// MARK: - Learning Period

// Input: The user's selected learning duration.
// Description: Defines the available periods for a learning goal.
// Output: A learning period: Week, Month, or Year.

enum LearningPeriod: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
}


// MARK: - Learning Activity

// Input: Learned and frozen days recorded by the user.
// Description: Stores learning activity counts and registered dates.
// Output: The user's learned days, frozen days, and activity history.

struct LearningActivity {
    var learnedDays: Int = 0
    var freezedDays: Int = 0
    var isFreezed: Bool = false
    var learnedDates: Set<Date> = []
    var freezedDates: Set<Date> = []
}



// MARK: - Goal Status

// Input: The current progress and completion state of a learning goal.
// Description: Defines the possible states of a learning goal.
// Output: Active, expired, or completed goal status.

enum GoalStatus {
    case active
    case expired
    case done
}


// MARK: - Learning Goal

// Input: The goal start date and selected learning period.
// Description: Stores the learning goal's duration and current status.
// Output: The learning goal's start date, period, and status.

struct LearningGoal {
    var startDate: Date
    var period: LearningPeriod
    var status: GoalStatus = .active
}


// MARK: - Learning Streak

// Input: The user's learning activity and last activity date.
// Description: Stores the current learning streak and its latest activity.
// Output: The current streak count and last activity timestamp.

struct LearningStreak {
    var currentStreak: Int = 0
    var lastActivityDate: Date? = nil
}
