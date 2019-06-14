import Foundation

struct UserFileManager {
    
    static func formatUserTextToPreviewText(_ userText: String) -> String {
        return userText.replacingOccurrences(of: "<!--[0-9]+-->", with: "", options: .regularExpression)
    }
    
    static func formatLessonTextToAnserText(_ lessonText: String) -> String {
        let answerText = lessonText.replacingOccurrences(of: "[#?]\\[[#?]|[#?]\\][#?]|@\\[@[a-z]+@\\]@", with: "", options: .regularExpression)
        return answerText
    }
    
//    static func createUserFileIfNotExists(lessonFile: File) {
////        try! FileManager.default.removeItem(at: lessonFile.userURL)
////        try! FileManager.default.removeItem(at: lessonFile.previewURL)
////        try! FileManager.default.removeItem(at: lessonFile.answerURL)
//        if !FileManager.default.fileExists(atPath: lessonFile.userURL.path) {
//            let userText = LessonTextParser().parse(lessonFile.text)
//            let succeeded = FileManager.default.createFile(atPath: lessonFile.userURL.path, contents: userText.data(using: .utf8), attributes: nil)
//            if !succeeded {
//                Application.printErrorLog("Failed to create user file.")
//            }
//        }
//        if !FileManager.default.fileExists(atPath: lessonFile.previewURL.path) {
//            let userText = LessonTextParser().parse(lessonFile.text)
//            let previewText = formatUserTextToPreviewText(userText)
//            let succeeded = FileManager.default.createFile(atPath: lessonFile.previewURL.path, contents: previewText.data(using: .utf8), attributes: nil)
//            if !succeeded {
//                Application.printErrorLog("Failed to create preview file.")
//            }
//        }
//        if !FileManager.default.fileExists(atPath: lessonFile.answerURL.path) {
//            let answerText = formatLessonTextToAnserText(lessonFile.text)
//            let succeeded = FileManager.default.createFile(atPath: lessonFile.answerURL.path, contents: answerText.data(using: .utf8), attributes: nil)
//            if !succeeded {
//                Application.printErrorLog("Failed to create answer file.")
//            }
//        }
//    }
    
    static func extractUserAnswers(userText: String) -> [String] {
        var answerIndex = 0
        var cache = ""
        var userAnswers = [String]()
        for character in userText {
            cache.append(character)
            let pattern = "<!--" + String(answerIndex) + "-->"
            guard let regex = try? NSRegularExpression(pattern: pattern) else {
                continue
            }
            let matches = regex.matches(in: cache, range: NSRange(location: 0, length: cache.count))
            guard matches.count == 2 else {
                continue
            }
            let startIndex = cache.index(cache.startIndex, offsetBy: matches[0].range.location + matches[0].range.length)
            let endIndex = cache.index(cache.startIndex, offsetBy: matches[1].range.location)
            let userAnswer = String(cache[startIndex..<endIndex])
            userAnswers.append(userAnswer)
            cache.removeAll(keepingCapacity: true)
            answerIndex += 1
        }
        return userAnswers
    }
    
}
