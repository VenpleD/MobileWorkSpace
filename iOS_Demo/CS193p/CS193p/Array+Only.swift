//
//  Array+Only.swift
//  CS193p
//
//  Created by Venple on 2022/11/20.
//

import Foundation


extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
