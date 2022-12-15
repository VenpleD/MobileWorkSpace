//
//  Chart1.swift
//  WWDC2022
//
//  Created by wenpu.duan on 2022/12/9.
//

import SwiftUI
import Charts

struct chart1: View {
    var body: some View {
        Chart(partyTasksRemaining) {
            BarMark(
                x: .value("Date", $0.date, unit: .day),
                y: .value("Tasks Remaining", $0.remainingCount)
            )
        }
        .padding()
    }
}

