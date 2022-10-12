//
//  ContentView.swift
//  CS193p
//
//  Created by wenpu.duan on 2022/10/11.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        return ZStack(content:{
            RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
            RoundedRectangle(cornerRadius: 10.0).stroke()
            Text("👻")
        })
            .foregroundColor(Color.orange)
            .font(Font.largeTitle)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
