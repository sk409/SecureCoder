//import Foundation
//
//extension Array where Iterator.Element == String {
//
//    mutating func numberingSort() {
//        sort { str1, str2 in
//            let num1 = Int(str1.filter { $0.isNumberic() })!
//            let num2 = Int(str2.filter { $0.isNumberic() })!
//            return num1 < num2
//        }
//    }
//
//    func numberingSorted() -> Array {
//        return sorted { str1, str2 in
//            let num1 = Int(str1.filter { $0.isNumberic() })!
//            let num2 = Int(str2.filter { $0.isNumberic() })!
//            return num1 < num2
//        }
//    }
//
//}
