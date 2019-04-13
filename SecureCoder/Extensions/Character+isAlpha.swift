import Foundation

extension Character {
    
    func isAlphaNumeric() -> Bool {
        let pattern = "^[A-Za-z0-9]$"
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return false
        }
        let matches = regex.matches(in: String(self), range: NSRange(location: 0, length: 1))
        return !matches.isEmpty
    }
    
}
