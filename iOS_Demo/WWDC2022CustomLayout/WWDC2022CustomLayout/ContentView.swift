//
//  ContentView.swift
//  WWDC2022CustomLayout
//
//  Created by wenpu.duan on 2022/12/15.
//

import SwiftUI

struct ContentView: View {
    @State var pets: [Pet] = Pet.exampleData
    var body: some View {
        MyEqualWidthHStack {
            ForEach($pets) { $pet in
                Button {
                    pet.votes += 1
                } label: {
                    Text(pet.type)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
        }
//        Leaderboard(pets: Pet.exampleData, totalVotes: 50)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
