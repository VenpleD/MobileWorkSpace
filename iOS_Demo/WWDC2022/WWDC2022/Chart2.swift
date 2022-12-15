//
//  Chart2.swift
//  WWDC2022
//
//  Created by wenpu.duan on 2022/12/9.
//

import SwiftUI
import Charts



struct chart3: View {
    struct MonthlyHoursOfSunshine: Identifiable {
        let id = UUID()
        
        var city: String
        var date: Date
        var hoursOfSunshine: Double

        init(city: String, month: Int, hoursOfSunshine: Double) {
            let calendar = Calendar.autoupdatingCurrent
            self.city = city
            self.date = calendar.date(from: DateComponents(year: 2020, month: month))!
            self.hoursOfSunshine = hoursOfSunshine
        }
    }

    var data: [MonthlyHoursOfSunshine] = [
        MonthlyHoursOfSunshine(city: "Seattle", month: 1, hoursOfSunshine: 74),
        MonthlyHoursOfSunshine(city: "Cupertino", month: 1, hoursOfSunshine: 196),
        MonthlyHoursOfSunshine(city: "Seattle", month: 5, hoursOfSunshine: 40),
        MonthlyHoursOfSunshine(city: "Cupertino", month: 5, hoursOfSunshine: 80),
        MonthlyHoursOfSunshine(city: "Seattle", month: 12, hoursOfSunshine: 62),
        MonthlyHoursOfSunshine(city: "Cupertino", month: 12, hoursOfSunshine: 199)
    ]
    var body: some View {
        Chart(data) {
            LineMark(
                x: .value("Month", $0.date),
                y: .value("Hours of Sunshine", $0.hoursOfSunshine)
            )
            .foregroundStyle(by: .value("City", $0.city))
        }
    }

}

//struct chart2: View {
//    
//    var body: some View {
//        Chart(partyTasksRemaining) {
//            LineMark(
//                x: .value("Date", $0.date, unit: .day),
//                y: .value("Tasks Remaining", $0.remainingCount)
//            )
//            .foregroundStyle(by: .value("Category", $0.category))
//        }
//        .padding()
//    }
//
//}
