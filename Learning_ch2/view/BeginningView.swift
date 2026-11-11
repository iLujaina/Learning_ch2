//
//  Activities - Beginning.swift
//  MyApp
//
//  Created by Lujain on 30/05/1448 AH.
//

import SwiftUI
import Playgrounds
import HorizonCalendar

struct BeginningView: View {
    @State private var isLearned = false
    private var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 1
        return calendar
    }
    
    private var startDate: Date {
        calendar.date(
            from: DateComponents(
                year: 2026,
                month: 1,
                day: 1
            )
        )!
    }
    
    private var endDate: Date {
        calendar.date(
            from: DateComponents(
                year: 2026,
                month: 12,
                day: 31
            )
        )!
    }
    
    var body: some View {
        
        CalendarViewRepresentable(
            calendar: calendar,
            visibleDateRange: startDate...endDate,
            monthsLayout: .vertical(
                options: VerticalMonthsLayoutOptions()
            ),
            dataDependency: nil
        )
        .monthHeaders { month in

            let date = calendar.date(
                from: DateComponents(
                    year: month.year,
                    month: month.month,
                    day: 1
                )
            )!

            Text(date, format: .dateTime
                .month(.wide)
                .year()
            )
            .font(.system(size: 20, weight: .bold))
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .days { day in
            let date = calendar.date(
                from: DateComponents(
                    year: day.month.year,
                    month: day.month.month,
                    day: day.day
                )
            )!

            Text("\(day.day)")
                .font(.system(size: 16))
                .frame(width: 36, height: 36)
                .background {
                    if calendar.isDate(date, inSameDayAs: Date()) {
                        Circle()
                            .fill(Color.orange)
                    }
                }
        }
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
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        
        .navigationTitle("Activities")
    }
}

#Preview {
    NavigationStack {
        BeginningView()
            .preferredColorScheme(.dark)
    }
}
#Playground {
    _ = 1 + 2
}
