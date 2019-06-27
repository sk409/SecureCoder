import Foundation

extension String {
    
    func appendingRegularExpressionEscaping() -> String {
        var result = ""
        for character in self {
            if character == "*" {
                result += "\\" + String(character)
            } else {
                result += String(character)
            }
        }
        return result
    }
    
}
