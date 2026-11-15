//
//  LearningHistoryStore.swift
//  Learning_ch2
//
//  Created by Lujain on 03/06/1448 AH.
//

import Foundation
import Observation

// MARK: - Learning History Store

// Input: Dates recorded as Learned or Freezed.
// Description: Manages learning history and persists it using UserDefaults.
// Output: Saved learning and freeze dates that can be retrieved later.

@Observable
class LearningHistoryStore {

    // MARK: - Properties

    private let calendar = Calendar.current

    private let freezeStorageKey = "freezedDates"
    private let storageKey = "learnedDates"

    var learnedDates: Set<Date> = []
    var freezedDates: Set<Date> = []


    // MARK: - Initialization

    // Input: None.
    // Description: Loads previously saved activity dates when the store is created.
    // Output: Initializes learnedDates and freezedDates with stored values.

    init() {
        loadDates()
    }


    // MARK: - Learned Dates

    // Input: A date, defaulting to the current date.
    // Description: Registers a learned day and removes any freeze for that day.
    // Output: Updates learnedDates and saves the activity history.

    func addLearnedDate(_ date: Date = Date()) {

        let day = calendar.startOfDay(for: date)

        freezedDates.remove(day)
        learnedDates.insert(day)

        saveDates()
    }


    // Input: A date to check.
    // Description: Checks whether the date has been registered as Learned.
    // Output: True if the date is learned; otherwise false.

    func isLearned(_ date: Date) -> Bool {

        let day = calendar.startOfDay(for: date)

        return learnedDates.contains(day)
    }


    // Input: A date, defaulting to the current date.
    // Description: Removes a previously registered learned day.
    // Output: Updates learnedDates and saves the activity history.

    func removeLearnedDate(_ date: Date = Date()) {

        let day = calendar.startOfDay(for: date)

        learnedDates.remove(day)

        saveDates()
    }


    // MARK: - Freezed Dates

    // Input: A date, defaulting to the current date.
    // Description: Registers a freeze day and removes any learned record for that day.
    // Output: Updates freezedDates and saves the activity history.

    func addFreezedDate(_ date: Date = Date()) {

        let day = calendar.startOfDay(for: date)

        learnedDates.remove(day)
        freezedDates.insert(day)

        saveDates()
    }


    // Input: A date to check.
    // Description: Checks whether the date has been registered as Freezed.
    // Output: True if the date is frozen; otherwise false.

    func isFreezed(_ date: Date) -> Bool {

        let day = calendar.startOfDay(for: date)

        return freezedDates.contains(day)
    }


    // Input: A date, defaulting to today.
     // Description: Removes the Learned registration
     //              for the specified day.
     // Output: Updates learnedDates and saves the changes.
    func removeFreezedDate(_ date: Date = Date()) {
        let day = calendar.startOfDay(for: date)

        freezedDates.remove(day)

        saveDates()
    }

    // MARK: - Data Persistence

    // Input: The current learnedDates and freezedDates sets.
    // Description: Converts dates to timestamps and stores them in UserDefaults.
    // Output: Saves both date collections for future app sessions.

    private func saveDates() {

        let learned = learnedDates.map {
            $0.timeIntervalSince1970
        }

        let freezed = freezedDates.map {
            $0.timeIntervalSince1970
        }

        UserDefaults.standard.set(
            learned,
            forKey: storageKey
        )

        UserDefaults.standard.set(
            freezed,
            forKey: freezeStorageKey
        )
    }


    // Input: Previously stored timestamps from UserDefaults.
    // Description: Converts saved timestamps back into normalized calendar dates.
    // Output: Restores learnedDates and freezedDates.

    private func loadDates() {

        let learned = UserDefaults.standard.array(
            forKey: storageKey
        ) as? [Double] ?? []

        let freezed = UserDefaults.standard.array(
            forKey: freezeStorageKey
        ) as? [Double] ?? []

        learnedDates = Set(
            learned.map {
                calendar.startOfDay(
                    for: Date(timeIntervalSince1970: $0)
                )
            }
        )

        freezedDates = Set(
            freezed.map {
                calendar.startOfDay(
                    for: Date(timeIntervalSince1970: $0)
                )
            }
        )
    }
}

