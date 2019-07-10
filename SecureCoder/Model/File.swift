import Foundation

struct File {
    
    let name: String
    let text: String
    let programingLanguage: ProgramingLanguage!
    
    init(name: String, text: String) {
        self.name = name
        self.text = text
        programingLanguage = ProgramingLanguage(extension: Extension(rawValue: String(name.split(separator: ".").last!))!)
    }
    
//    let url: URL
//    let userURL: URL
//    let previewURL: URL
//    let answerURL: URL
//    var `extension`: Extension?
//    var programingLanguage: ProgramingLanguage?
//    
//    init(title: String, text: String, url: URL, userURL: URL, previewURL: URL, answerURL: URL) {
//        self.title = title
//        self.text = text
//        self.url = url
//        self.userURL = userURL
//        self.previewURL = previewURL
//        self.answerURL = answerURL
//        if let extensionString = title.split(separator: ".").last,
//            let `extension` = Extension(rawValue: String(extensionString))
//        {
//            self.extension = `extension`
//            programingLanguage = ProgramingLanguage(extension: `extension`)
//        }
//    }
    
    
}
