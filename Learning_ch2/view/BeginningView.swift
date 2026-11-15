//
//  Activities - Beginning.swift
//  MyApp
//
//  Created by Lujain on 30/05/1448 AH.
//

import SwiftUI
import HorizonCalendar

// MARK: - Beginning View

// Input: The current date and saved learning activity history.
// Description: Displays a scrollable calendar with learning
//              and freeze records using HorizonCalendar.
// Output: A calendar with colored activity indicators.

struct BeginningView: View {

    // MARK: - Properties

    @State private var history = LearningHistoryStore()

    @StateObject private var calendarProxy = CalendarViewProxy()

    // MARK: - Activity Colors

    // Input: The learning and freeze color values.
    // Description: Defines consistent colors for activity records.
    // Output: Orange and blue colors for calendar days.

    private let learnedColor = Color(
        red: 255/255,
        green: 146/255,
        blue: 48/255
    )

    private let freezeColor = Color(
        red: 60/255,
        green: 211/255,
        blue: 254/255
    )


    // MARK: - Calendar Configuration

    // Input: Gregorian calendar settings.
    // Description: Configures the calendar to start
    //              each week on Sunday.
    // Output: A Gregorian calendar.

    private var calendar: Calendar {

        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 1

        return calendar
    }


    // MARK: - Calendar Start Date

    // Input: The application's initial calendar year.
    // Description: Keeps previous activity history
    //              accessible starting from 2026.
    // Output: January 1, 2026.

    private var startDate: Date {

        calendar.date(
            from: DateComponents(
                year: 2026,
                month: 1,
                day: 1
            )
        )!
    }


    // MARK: - Calendar End Date

    // Input: The current calendar year.
    // Description: Extends the calendar range automatically
    //              to include the following year.
    // Output: December 31 of the following year.

    private var endDate: Date {

        let currentYear = calendar.component(
            .year,
            from: Date()
        )

        return calendar.date(
            from: DateComponents(
                year: max(2026, currentYear + 1),
                month: 12,
                day: 31
            )
        )!
    }


    // MARK: - View Body

    // Input: Calendar configuration and saved activity dates.
    // Description: Builds the yearly calendar with
    //              custom headers and day indicators.
    // Output: A vertically scrollable activity calendar.

    var body: some View {

        CalendarViewRepresentable(
            calendar: calendar,
            visibleDateRange: startDate...endDate,
            monthsLayout: .vertical(
                options: VerticalMonthsLayoutOptions()
            ),
            dataDependency: [
                history.learnedDates,
                history.freezedDates
            ],
            proxy: calendarProxy
        )

        // MARK: - Month Headers

        // Input: The month and year from HorizonCalendar.
        // Description: Displays the full month name
        //              and year above each calendar month.
        // Output: A header such as November 2026.

        .monthHeaders { month in

            let date = calendar.date(
                from: DateComponents(
                    year: month.year,
                    month: month.month,
                    day: 1
                )
            )!

            Text(
                date,
                format: .dateTime
                    .month(.wide)
                    .year()
            )
            .font(.system(size: 20, weight: .bold))
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
        }


        // MARK: - Calendar Days

        // Input: Each date and saved activity records.
        // Description: Displays each day with a circle
        //              representing its activity state.
        // Output: A calendar day with the correct color.

        .days {
            [learnedDates = history.learnedDates,
             freezedDates = history.freezedDates] day in

            let date = calendar.date(
                from: DateComponents(
                    year: day.month.year,
                    month: day.month.month,
                    day: day.day
                )
            )!

            let normalizedDate = calendar.startOfDay(
                for: date
            )

            Text("\(day.day)")
                .font(.system(size: 16))
                .frame(width: 36, height: 36)

                // MARK: - Activity Day Colors

                // Input: The date's Learned or Freeze status.
                // Description: Displays translucent orange for Learned,
                //              translucent blue for Freeze, and solid
                //              orange for an unregistered current day.
                // Output: A colored circle behind the day number.

                .background {

                    if learnedDates.contains(normalizedDate) {

                        Circle()
                            .fill(
                                learnedColor.opacity(0.45)
                            )

                    } else if freezedDates.contains(normalizedDate) {

                        Circle()
                            .fill(
                                freezeColor.opacity(0.45)
                            )

                    } else if calendar.isDate(
                        date,
                        inSameDayAs: Date()
                    ) {

                        Circle()
                            .fill(learnedColor)
                    }
                }
        }


        // MARK: - Calendar Layout

        // Input: Calendar spacing and margin values.
        // Description: Controls the spacing between months,
        //              calendar days, and screen edges.
        // Output: A calendar with the original layout.

        .interMonthSpacing(25)
        .verticalDayMargin(10)
        .horizontalDayMargin(5)
        .layoutMargins(
            .init(
                top: 16,
                leading: 16,
                bottom: 16,
                trailing: 16
            )
        )


        // MARK: - Initial Calendar Position

        // Input: The current system date.
        // Description: Scrolls directly to the current month
        //              when the calendar opens.
        // Output: The current month displayed without animation.

        .onAppear {

            calendarProxy.scrollToMonth(
                containing: Date(),
                scrollPosition: .firstFullyVisiblePosition,
                animated: false
            )
        }


        // MARK: - View Configuration

        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .navigationTitle("Activities")
    }
}


// MARK: - Preview

#Preview {

    NavigationStack {

        BeginningView()
            .preferredColorScheme(.dark)
    }
}
