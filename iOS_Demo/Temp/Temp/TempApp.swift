//
//  TempApp.swift
//  Temp
//
//  Created by Venple on 2022/12/4.
//

import SwiftUI

@main
struct TempApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
