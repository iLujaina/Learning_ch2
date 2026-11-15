//
//  LearningGoalViewModel.swift
//  Learning_ch2
//
//  Created by Lujain on 05/06/1448 AH.
//

import Foundation
import Observation

// MARK: - Learning Goal ViewModel

// Input: The user's goal name and selected learning period.
// Description: Manages loading, validation, saving,
//              and deleting a learning goal.
// Output: Updated and persisted learning goal information.

@Observable
class LearningGoalViewModel {

    // MARK: - Properties

    var goalName = ""
    var selectedPeriod: LearningPeriod = .week

    private let defaults = UserDefaults.standard


    // MARK: - Initialization

    // Input: Previously saved learning goal information.
    // Description: Loads the goal name and selected period.
    // Output: Restored goal values for the editing screen.

    init() {
        loadGoal()
    }


    // MARK: - Load Goal

    // Input: Saved goal name and period from UserDefaults.
    // Description: Restores the user's current learning goal.
    // Output: Updates goalName and selectedPeriod.

    func loadGoal() {

        goalName = defaults.string(
            forKey: "goalName"
        ) ?? ""

        let savedPeriod = defaults.string(
            forKey: "goalPeriod"
        ) ?? "Week"

        selectedPeriod = LearningPeriod(
            rawValue: savedPeriod
        ) ?? .week
    }


    // MARK: - Goal Validation

    // Input: The goal name entered by the user.
    // Description: Checks that the name contains
    //              at least one non-whitespace character.
    // Output: True if the goal is valid; otherwise false.

    var canSaveGoal: Bool {

        !goalName.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty
    }


    // MARK: - Save Goal

    // Input: A valid goal name and selected learning period.
    // Description: Saves the updated goal, starts a new goal
    //              period, and resets the current streak.
    // Output: True if the goal was saved successfully.

    @discardableResult
    func saveGoal() -> Bool {

        guard canSaveGoal else {
            return false
        }

        let newStartDate = Date()

        defaults.set(
            goalName.trimmingCharacters(
                in: .whitespacesAndNewlines
            ),
            forKey: "goalName"
        )

        defaults.set(
            selectedPeriod.rawValue,
            forKey: "goalPeriod"
        )

        defaults.set(
            newStartDate,
            forKey: "goalStartDate"
        )

        defaults.set(
            0,
            forKey: "currentStreak"
        )

        defaults.removeObject(
            forKey: "lastActivityDate"
        )

        defaults.set(
            newStartDate,
            forKey: "streakGoalStartDate"
        )

        defaults.set(
            true,
            forKey: "hasSavedGoal"
        )

        return true
    }


    // MARK: - Delete Goal

    // Input: A request to delete the current learning goal.
    // Description: Removes the saved goal information
    //              and resets the current streak.
    // Output: Clears the active goal and streak state.

    func deleteGoal() {

        defaults.removeObject(
            forKey: "goalName"
        )

        defaults.removeObject(
            forKey: "goalPeriod"
        )

        defaults.removeObject(
            forKey: "goalStartDate"
        )

        defaults.removeObject(
            forKey: "currentStreak"
        )

        defaults.removeObject(
            forKey: "lastActivityDate"
        )

        defaults.removeObject(
            forKey: "streakGoalStartDate"
        )

        defaults.set(
            false,
            forKey: "hasSavedGoal"
        )
    }
}
