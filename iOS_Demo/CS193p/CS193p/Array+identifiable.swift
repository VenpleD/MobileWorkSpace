//
//  Array+identifiable.swift
//  CS193p
//
//  Created by Venple on 2022/11/20.
//

import Foundation

extension Array where Element: Identifiable {
    func firstIndex(matching: Element) -> Int? {
        for index in 0..<self.count {
            if matching.id == self[index].id {
                return index
            }
        }
        return nil
    }
}
