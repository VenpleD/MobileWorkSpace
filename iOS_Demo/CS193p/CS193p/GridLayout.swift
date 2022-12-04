//
//  GridLayout.swift
//  CS193p
//
//  Created by Venple on 2022/11/20.
//

import SwiftUI



struct GridLayout {
    private var size: CGSize
    private var rowCount: Int = 0
    private var columnCount: Int = 0
    
    init(itemCount: Int, nearAspectRatio desiredAspectRatio: Double = 1, in size: CGSize) {
//        self.size = size
//        if size.width < size.height {
//            self.columnCount = 2;
//            self.rowCount = itemCount / self.self.columnCount
//
//        } else {
//            self.rowCount = 2
//            self.columnCount = itemCount  / self.rowCount
//        }
        
        self.size = size
        // if our size is zero width or height or the itemCount is not > 0
        // then we have no work to do (because our rowCount & columnCount will be zero)
        guard size.width != 0, size.height != 0, itemCount > 0 else { return }
        // find the bestLayout
        // i.e., one which results in cells whose aspectRatio
        // has the smallestVariance from desiredAspectRatio
        // not necessarily most optimal code to do this, but easy to follow (hopefully)
        var bestLayout: (rowCount: Int, columnCount: Int) = (1, itemCount)
        var smallestVariance: Double?
        let sizeAspectRatio = abs(Double(size.width/size.height))
        for rows in 1...itemCount {
            let columns = (itemCount / rows) + (itemCount % rows > 0 ? 1 : 0)
            if (rows - 1) * columns < itemCount {
                let itemAspectRatio = sizeAspectRatio * (Double(rows)/Double(columns))
                let variance = abs(itemAspectRatio - desiredAspectRatio)
                if smallestVariance == nil || variance < smallestVariance! {
                    smallestVariance = variance
                    bestLayout = (rowCount: rows, columnCount: columns)
                }
            }
        }
        rowCount = bestLayout.rowCount
        columnCount = bestLayout.columnCount
    }
    
    var itemSize: CGSize {
        let width: CGFloat = self.size.width / CGFloat(self.columnCount)
        let height: CGFloat = self.size.height / CGFloat(self.rowCount)
        return CGSize(width: width, height: height)
    }
    
    func location(ofItemAt index: Int) -> CGPoint {
        let pointX = self.itemSize.width * CGFloat(index % self.columnCount) + self.itemSize.width / 2.0
        let pointY = self.itemSize.height * CGFloat(index / self.columnCount) + self.itemSize.height / 2.0
        return CGPoint(x: pointX, y: pointY)
    }
}
