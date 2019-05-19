
extension String {
    
    func isWhiteSpace() -> Bool {
        guard !isEmpty else {
            return false
        }
        for index in 0...(count - 1) {
            if !self[index].isWhitespace {
                return false
            }
        }
        return true
    }
    
    func isVariableAllowed() -> Bool {
        guard !isEmpty else {
            return false
        }
        for index in 0...(count - 1) {
            if !self[index].isVariableAllowed() {
                return false
            }
        }
        return true
    }
    
    func isPHPVariableAllowed() -> Bool {
        guard !isEmpty else {
            return false
        }
        guard self[0] == "$" else {
            return false
        }
        if 2 <= count {
            for index in 1...(count - 1) {
                if !self[index].isVariableAllowed() {
                    return false
                }
            }
        }
        return true
    }
    
}
