import Foundation

extension String {
    
    subscript(_ i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript(_ range: Range<Int>) -> Substring {
        return self[index(startIndex, offsetBy: range.lowerBound)..<index(startIndex, offsetBy: range.upperBound)]
    }
    
    subscript(_ range: ClosedRange<Int>) -> Substring {
        return self[index(startIndex, offsetBy: range.lowerBound)...index(startIndex, offsetBy: range.upperBound)]
    }
    
    subscript(_ range: PartialRangeFrom<Int>) -> Substring {
        return self[index(startIndex, offsetBy: range.lowerBound)..<endIndex]
    }
    
    subscript(_ range: PartialRangeUpTo<Int>) -> Substring {
        return self[startIndex..<index(startIndex, offsetBy: range.upperBound)]
    }
    
    subscript(_ range: PartialRangeThrough<Int>) -> Substring {
        return self[startIndex...index(startIndex, offsetBy: range.upperBound)]
    }
    
}
