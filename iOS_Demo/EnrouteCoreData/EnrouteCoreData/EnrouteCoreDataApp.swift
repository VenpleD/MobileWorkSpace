//
//  EnrouteCoreDataApp.swift
//  EnrouteCoreData
//
//  Created by Venple on 2022/12/4.
//

import SwiftUI

@main
struct EnrouteCoreDataApp: App {
    let persistenceController = PersistenceController.shared
    
    

    var body: some Scene {
        WindowGroup {
            
            FlightsEnrouteView(flightSearch: FlightSearch(destination: airport))
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
    private var airport: Airport {
        let airport = Airport.withICAO("KSFO", context: persistenceController.container.viewContext)
        airport.fetchIncomingFlights()
        return airport
    }
}
