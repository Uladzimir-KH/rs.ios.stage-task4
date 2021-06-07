import Foundation

public extension Int {
    
    var roman: String? {
        if (1 <= self && self <= 3999) {
            var recievedInt = self
            var romanString = ""
            let numberMap: [(Int, String)] = [(1000, "M"), (900, "CM"), (500, "D"), (400, "CD"), (100, "C"), (90, "XC"), (50, "L"), (40, "XL"), (10, "X"), (9, "IX"), (5, "V"), (4, "IV"), (1, "I")]
                    for i in numberMap {
                        while (recievedInt >= i.0) {
                            recievedInt -= i.0
                            romanString += i.1
                        }
                    }
            return romanString
        } else {
            return nil
        }
    }
}
