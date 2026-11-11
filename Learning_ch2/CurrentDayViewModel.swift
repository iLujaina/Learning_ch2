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

   
    var selectedPeriod: LearningPeriod

   
    init(selectedPeriod: LearningPeriod) {
        self.selectedPeriod = selectedPeriod
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
 
    
    func logLearning() {
        activity.learnedDays += 1
        activity.isFreezed = false
    }

   
    func freezeDay() {

        guard activity.freezedDays < maxFreezes else {
            return
        }

        activity.freezedDays += 1

        activity.learnedDays = max(
            0,
            activity.learnedDays - 1
        )

        activity.isFreezed = true
    }

   
    var remainingFreezes: Int {
        max(0, maxFreezes - activity.freezedDays)
    }
}
