//
//  Pie.swift
//  CS193p
//
//  Created by wenpu.duan on 2022/11/21.
//

import SwiftUI

struct pie: Shape {
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let start = CGPoint(
            x: ,
            y:
        )
        let path = Path()
        path.move(to: center)
        path.addLine(to: start)
        return path
    }
}
