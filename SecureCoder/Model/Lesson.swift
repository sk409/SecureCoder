import Foundation

struct Slide: Codable {
    let title: String
    let content: String
    let imageName: String?
}

struct Description: Codable {
    let title: String
    let content: String
    let index: Int
}

struct Lesson {
    
    let title: String
    let files: [File]
    let slides: [Slide]
    let descriptios: [String: [Description]]
    private(set) var index: File?
    
    init(title: String, files: [File], slides: [Slide], descriptios: [String: [Description]]) {
        self.title = title
        self.files = files
        self.slides = slides
        self.descriptios = descriptios
        for file in files {
            guard file.title.contains("index") else {
                return
            }
            index = file
            break
        }
    }
    
}

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
