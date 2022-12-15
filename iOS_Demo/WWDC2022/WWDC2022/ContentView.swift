//
//  ContentView.swift
//  WWDC2022
//
//  Created by wenpu.duan on 2022/12/9.
//

import SwiftUI


//
struct ContentView: View {
    var body: some View {
        chart3()
    }

    func calculate() {
        let possibleNumber: Int? = Int("42")
        let nonOverflowingSquare = possibleNumber.flatMap { x -> Int? in
            let (result, overflowed) = x.multipliedReportingOverflow(by: x)
            return overflowed ? nil : result
        }
        print(nonOverflowingSquare)
    }
}

