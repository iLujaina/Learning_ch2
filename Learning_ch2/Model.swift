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
}

struct FreezeData {
    let freezesPerWeek: Int = 2
    let freezesPerMonth: Int = 8
    let freezesPerYear: Int = 96
}
