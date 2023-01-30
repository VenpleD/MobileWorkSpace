//
//  Pet.swift
//  WWDC2022CustomLayout
//
//  Created by wenpu.duan on 2022/12/15.
//

import Foundation


struct Pet: Identifiable, Equatable {
    let type: String
    var votes: Int = 0
    var id: String { type }

    static var exampleData: [Pet] = [
        Pet(type: "Cat", votes: 25),
        Pet(type: "Goldfish", votes: 9),
        Pet(type: "Dog", votes: 16)
    ]
}
