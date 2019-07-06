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
    
    //let title: String
    let domains: [Domain]
    let guides: [Guide]
    let keyboardWords: [KeyboardWords]
//    let slides: [Slide]
//    let descriptios: [String: [Description]]
//    private(set) var index: File?
//    
//    init(title: String, files: [File], slides: [Slide], descriptios: [String: [Description]]) {
//        self.title = title
//        self.files = files
//        self.slides = slides
//        self.descriptios = descriptios
//        for file in files {
//            guard file.title.contains("index") else {
//                return
//            }
//            index = file
//            break
//        }
//    }
    
}
