//
//  LearningHistoryStore.swift
//  Learning_ch2
//
//  Created by Lujain on 03/06/1448 AH.
//


import Foundation
import Observation

@Observable
class LearningHistoryStore {

    private let calendar = Calendar.current
    private let freezeStorageKey = "freezedDates"
    private let storageKey = "learnedDates"

    var learnedDates: Set<Date> = []
    var freezedDates: Set<Date> = []
    init() {
        loadDates()
    }

    func addLearnedDate(_ date: Date = Date()) {
        let day = calendar.startOfDay(for: date)

        freezedDates.remove(day)
        learnedDates.insert(day)
        saveDates()
    }

    func isLearned(_ date: Date) -> Bool {
        let day = calendar.startOfDay(for: date)
        return learnedDates.contains(day)
    }

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
    func removeLearnedDate(_ date: Date = Date()) {
        let day = calendar.startOfDay(for: date)

        learnedDates.remove(day)
        saveDates()
    }
    
    func addFreezedDate(_ date: Date = Date()) {
        let day = calendar.startOfDay(for: date)

        learnedDates.remove(day)
        freezedDates.insert(day)

        saveDates()
    }
    func isFreezed(_ date: Date) -> Bool {
        let day = calendar.startOfDay(for: date)
        return freezedDates.contains(day)
    }
    
    
    func removeFreezedDate() {
        let today = Calendar.current.startOfDay(for: Date())

        freezedDates.remove(today)
        saveDates()
    }
    

}
