import Foundation

extension Character {
    
    func isLowercasedAlpha() -> Bool {
        let pattern = "^[a-z]$"
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return false
        }
        let matches = regex.matches(in: String(self), range: NSRange(location: 0, length: 1))
        return !matches.isEmpty
    }
    
    func isUppercasedAlpha() -> Bool {
        let pattern = "^[A-Z]$"
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return false
        }
        let matches = regex.matches(in: String(self), range: NSRange(location: 0, length: 1))
        return !matches.isEmpty
    }
    
    func isAlpha() -> Bool {
        let pattern = "^[A-Za-z]$"
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return false
        }
        let matches = regex.matches(in: String(self), range: NSRange(location: 0, length: 1))
        return !matches.isEmpty
    }
    
    func isNumberic() -> Bool {
        let pattern = "^[0-9]$"
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return false
        }
        let matches = regex.matches(in: String(self), range: NSRange(location: 0, length: 1))
        return !matches.isEmpty
    }
    
    func isAlphaNumeric() -> Bool {
//        let pattern = "^[A-Za-z0-9]$"
//        guard let regex = try? NSRegularExpression(pattern: pattern) else {
//            return false
//        }
//        let matches = regex.matches(in: String(self), range: NSRange(location: 0, length: 1))
//        return !matches.isEmpty
        return isAlpha() || isNumberic()
    }
    
    func isVariableAllowed() -> Bool {
        return isAlphaNumeric() || self == "_"
    }
    
    func isPHPVariableAllowed() -> Bool {
        return isVariableAllowed() || self == "$"
    }
    
    func isPrintable() -> Bool {
        return !isWhitespace && !isNewline
    }
    
}
