//
//  LearningGoalViewModel.swift
//  Learning_ch2
//
//  Created by Lujain on 05/06/1448 AH.
//

import Foundation
import Observation

@Observable
class LearningGoalViewModel {

    var goalName = ""

    var selectedPeriod: LearningPeriod = .week

    var canSaveGoal: Bool {
        !goalName.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty
    }

    func saveGoal() {
        guard canSaveGoal else { return }

        UserDefaults.standard.set(
            goalName,
            forKey: "goalName"
        )

        UserDefaults.standard.set(
            selectedPeriod.rawValue,
            forKey: "goalPeriod"
        )

        UserDefaults.standard.set(
            true,
            forKey: "hasSavedGoal"
        )
    }

    func deleteGoal() {
        UserDefaults.standard.removeObject(forKey: "goalName")
        UserDefaults.standard.removeObject(forKey: "goalPeriod")

        UserDefaults.standard.set(
            false,
            forKey: "hasSavedGoal"
        )
    }
}

