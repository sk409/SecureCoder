//
//
//class AnswerChecker {
//    
//    static func check(lesson: Lesson) -> Bool {
//        for file in lesson.files {
//            let path = lesson.relativeAnswerDirectoryURLString + file.name
//            let answer = DatabaseSession.sync(with: "ReadFile.php", parameters: ["path": path], method: .get)
//            guard answer == file.text else {
//                return false
//            }
//        }
//        return true
//    }
//    
//}
