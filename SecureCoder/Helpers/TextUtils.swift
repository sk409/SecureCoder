import Foundation

struct TextUtils {
    
    static func formatUserTextToPreviewText(_ userText: String) -> String {
        return userText.replacingOccurrences(of: "<!--[0-9]+-->", with: "", options: .regularExpression)
    }
    
    static func formatLessonTextToAnserText(_ lessonText: String) -> String {
        let answerText = lessonText.replacingOccurrences(of: "[#?]\\[[#?]|[#?]\\][#?]|@\\[@[a-z]+@\\]@", with: "", options: .regularExpression)
        return answerText
    }
    
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
