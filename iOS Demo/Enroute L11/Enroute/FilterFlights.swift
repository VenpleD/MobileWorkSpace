//
//  FilterFlights.swift
//  Enroute
//
//  Created by CS193p Instructor on 5/12/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import SwiftUI

struct FilterFlights: View {
    @ObservedObject var allAirports = Airports.all
    @ObservedObject var allAirlines = Airlines.all

    
    @Binding var flightSearch: FlightSearch
    @Binding var isPresented: Bool
    
    @State private var draft: FlightSearch
    
    init(flightSearch: Binding<FlightSearch>, isPresented: Binding<Bool>) {
        _flightSearch = flightSearch
        _isPresented = isPresented
        _draft = State(wrappedValue: flightSearch.wrappedValue)
    }
    
    
    var body: some View {
        NavigationStack {
            Form {
                Picker("Destination", selection: $draft.destination) {
                    ForEach(allAirports.codes, id: \.self) { airport in
                        Text("\(self.allAirports[airport]?.friendlyName ?? "Any")").tag(airport)
                    }
                }.pickerStyle(.navigationLink)
                Picker("Origin", selection: $draft.origin) {
                    /// 这里picker的tag必须要与selection的值是同一类型，特别注意可选类型，如果是可选，那么就得转换
                    /// 下面的foreach，后面的参数就是一个转换，(airport: String?) 这样子，swift会自动个推断类型会void，类似这样：(airport: String?)  -> Void
                    ForEach(allAirports.codes, id: \.self) { (airport: String?) in
                        Text("\(self.allAirports[airport]?.friendlyName ?? "Any")").tag(airport)
                    }
                }
                Picker("Airline", selection: $draft.airline) {
                    ForEach(allAirlines.codes, id: \.self) { (airline: String?) in
                        Text("\(self.allAirlines[airline]?.friendlyName ?? "Any")").tag(airline)
                    }
                }
                Toggle(isOn: $draft.inTheAir, label: { Text("Enroute Only") })
            }
            
            Text("Filter flights to \(flightSearch.destination)")
                .navigationTitle("Filter Flights")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) { cancel }
                    ToolbarItem(placement: .navigationBarTrailing) { done }
                }
        }
    }
    
    var cancel: some View {
        Button("Cancel") {
            self.isPresented = false
        }
    }
    
    var done: some View {
        Button("Done") {
            self.flightSearch = self.draft
            self.isPresented = true
        }
    }
    
}

//struct FilterFlights_Previews: PreviewProvider {
//    static var previews: some View {
//        FilterFlights()
//    }
//}
