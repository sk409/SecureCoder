import Foundation

struct File {
    
    let title: String
    let text: String
    let url: URL
    let userURL: URL
    let previewURL: URL
    let answerURL: URL
    var programingLanguage: ProgramingLanguage?
    
    init(title: String, text: String, url: URL, userURL: URL, previewURL: URL, answerURL: URL) {
        self.title = title
        self.text = text
        self.url = url
        self.userURL = userURL
        self.previewURL = previewURL
        self.answerURL = answerURL
        if let extensionString = title.split(separator: ".").last,
            let `extension` = Extension(rawValue: String(extensionString))
        {
            programingLanguage = ProgramingLanguage(extension: `extension`)
        }
    }
    
    
}
