import Foundation

final class FillWithColor {
    
    func fillWithColor(_ image: [[Int]], _ row: Int, _ column: Int, _ newColor: Int) -> [[Int]] {
        
        if (newColor == image[row][column]) {
            return image
        }
        
        struct Pixel {
            let y: Int
            let x: Int
        }
        
        let heigth = image.count
        let width = image[row].count
        let heightRange = 0...heigth
        let widthRange = 0...width
        let horizontalRangeBefore = 0..<column
        let horizontalRangeAfter = column..<width
        let verticalRangeBefore = 0..<row
        let verticalRangeAfter = row..<width

        
        let selectedPixelColor = image[row][column]
        var finalImage = image
        
        var arrayHigher:[Int] = []
        var arrayBelow:[Int] = []
        
        var pixelsQueue: [Pixel] = []
        
        
        
        func checkNeighbors(y: Int, x: Int) {
            if (0 < x) {
                if (finalImage[y][x - 1] == selectedPixelColor) {
                    let new = Pixel.init(y: y, x: x - 1)
                    pixelsQueue.append(new)
                }
            }
            if (x < width - 1) {
                if (finalImage[y][x + 1] == selectedPixelColor) {
                    let new = Pixel.init(y: y, x: x + 1)
                    pixelsQueue.append(new)
                }
            }
            if (0 < y) {
                if (finalImage[y - 1][x] == selectedPixelColor) {
                    let new = Pixel.init(y: y - 1, x: x)
                    pixelsQueue.append(new)
                }
            }
            if (y < heigth - 1) {
                if (finalImage[y + 1][x] == selectedPixelColor) {
                    let new = Pixel.init(y: y + 1, x: x)
                    pixelsQueue.append(new)
                }
            }
            
        }
        
        func changeColorsForQueueElements() {
            for pixel in pixelsQueue {
                finalImage[pixel.y][pixel.x] = newColor
            }
        }
        
        finalImage[row][column] = newColor

        checkNeighbors(y: row, x: column)
        changeColorsForQueueElements()
        
        while !pixelsQueue.isEmpty {
            checkNeighbors(y: pixelsQueue[0].y, x: pixelsQueue[0].x)
            changeColorsForQueueElements()
            //TODO: changeColorsForQueueElements performance optimization required
            pixelsQueue.removeFirst()
        }
        
        
        
        
//        for x in horizontalRangeAfter {
//            if (image[row][x] == selectedPixelColor){
//                finalImage[row][x] = newColor
//            } else {
//                break
//            }
//        }
//        for x in horizontalRangeBefore.reversed() {
//            if (image[row][x] == selectedPixelColor){
//                finalImage[row][x] = newColor
//            } else {
//                break
//            }
//        }
//
//        for y in verticalRangeBefore.reversed() {
//
//        }
//
//        for i in column..<width {
//
//
//            if (image[row][i] == image[row - 1][i]) {
//                arrayHigher.append(i)
//            } else {
//                break
//            }
//            if (image[row][i] == image[row + 1][i]) {
//                arrayBelow.append(i)
//            } else {
//                break
//            }
//        }
//
       
        
        
        
        
        return finalImage
    }
}
