//
//  PartyNavSplitView.swift
//  WWDC2022
//
//  Created by wenpu.duan on 2022/12/9.
//

// MARK: NavigationSplitView Demo
import SwiftUI

struct PartyPlannerHome: View {
    @State private var selectedTask: PartyTask?

    var body: some View {
        NavigationSplitView {
            List(PartyTask.allCases, selection: $selectedTask) { task in
                NavigationLink(value: task) {
                    TaskLabel(task: task)
                }
                            .listItemTint(task.color)
            }
        } detail: {

            selectedTask.flatMap { $0.color } ?? .white
        }
    }
}

struct TaskLabel: View {
    let task: PartyTask

    var body: some View {
        Label {
            VStack(alignment: .leading) {
                Text(task.name)
                Text(task.subtitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        } icon: {
            Image(systemName: task.imageName)
                .symbolVariant(.circle.fill)
        }
    }
}
