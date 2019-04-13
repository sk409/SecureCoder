import Foundation

class File {
    
    let type: LessonType
    let section: String
    let title: String
    let name: String
    let editable: Bool
    
    private(set) var answer: String?
    
    var absoluteURLString: String {
        guard let absoluteCoderDirectoryURLString = CoderManager.shared.absoluteCoderDirectoryURLString else {
            return ""
        }
        return absoluteCoderDirectoryURLString + type.rawValue + "/" + section + "/" + title + "/" + name
    }
    var relativeURLString: String {
        guard let relativeCoderDirectoryURLString = CoderManager.shared.relativeCoderDirectoryURLString else {
            return ""
        }
        return relativeCoderDirectoryURLString + type.rawValue + "/" + section + "/" + title + "/" + name
    }
    var absolutePreviewFileURLString: String {
        return Application.webServerRootURLString + "PreviewFile/" + type.rawValue + "/" + section + "/" + title + "/" + name
    }
    
    private(set) var text = ""
    
    init(type: LessonType, section: String, title: String, name: String, editable: Bool) {
        self.type = type
        self.section = section
        self.title = title
        self.name = name
        self.editable = editable
        loadAnswer()
    }
    
    func initialize() {
        let path = "DefaultFile/" + type.rawValue + "/" + section + "/" + title + "/" + name
        text = DatabaseSession.sync(with: "ReadFile.php", parameters: ["path": path], method: .get)
    }
    
    func load() {
        let percentEncodedText = DatabaseSession.sync(with: "ReadFile.php", parameters: ["path": relativeURLString], method: .get)
        guard let removedPercentEncodingText = percentEncodedText.removingPercentEncoding else {
            return
        }
        text = removedPercentEncodingText
    }
    
    func save() {
        guard let percentEncodedText = text.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "&").inverted) else {
            return
        }
        let result = DatabaseSession.sync(with: "SaveFile.php", parameters: ["path": relativeURLString, "data": percentEncodedText], method: .post)
        if result != ServerResponse.succeeded {
            Application.shared.writeErrorLog(result)
        }
    }
    
    func setText(_ text: String) {
        self.text = text
    }
    
    func isSameAsAnswer() -> Bool {
        guard let answer = self.answer else {
            return true
        }
        return text == answer
    }
    
    private func loadAnswer() {
        let path = "AnswerFile/" + type.rawValue + "/" + section + "/" + title + "/" + name
        let isExistingAnswerFile = DatabaseSession.sync(with: "CheckExistenceFile", parameters: ["path": path], method: .get)
        guard isExistingAnswerFile == ServerResponse.true else {
            return
        }
        answer = DatabaseSession.sync(with: "ReadFile.php", parameters: ["path": path], method: .get)
    }
    
}

struct Lesson {
    
    static let sections: [LessonType: [String]] = [
        .htmlcss: ["Lesson1", "Lesson2", "Lesson3", "Lesson4", "Lesson5", "Lesson6", "Lesson7", "Lesson8", "Lesson9", "Lesson10"],
        .javaScript: ["Lesson1", "Lesson2", "Lesson3", "Lesson4", "Lesson5", "Lesson6", "Lesson7", "Lesson8", "Lesson9", "Lesson10"],
        .php: ["Lesson1", "Lesson2", "Lesson3", "Lesson4", "Lesson5", "Lesson6", "Lesson7", "Lesson8", "Lesson9", "Lesson10"],
    ]
    
    static let titles: [LessonType: [[String]]] = [
        .htmlcss: [
            ["HTMLの雛形を書いてみよう"],
            ["準備中"],
            ["準備中"],
            ["準備中"],
            ["準備中"],
            ["準備中"],
            ["準備中"],
            ["準備中"],
            ["準備中"],
            ["準備中"],
        ],
        .javaScript: [
            ["準備中"],
            ["準備中"],
            ["準備中"],
            ["準備中"],
            ["準備中"],
            ["準備中"],
            ["準備中"],
            ["準備中"],
            ["準備中"],
            ["準備中"],
        ],
        .php: [
            ["準備中"],
            ["準備中"],
            ["準備中"],
            ["XSS", "XSS対策をしよう", "SQLインジェクション", "SQLインジェクション対策をしよう"],
            ["準備中"],
            ["準備中"],
            ["準備中"],
            ["準備中"],
            ["準備中"],
            ["準備中"],
        ],
    ]
    
    static private(set) var active: Lesson?
    
    var relativeDirectoryURLString: String? {
        guard let relativeCoderDirecotryURLString = CoderManager.shared.relativeCoderDirectoryURLString else {
            return nil
        }
        return relativeCoderDirecotryURLString + type.rawValue + "/" + section + "/" + title + "/"
    }
    
    private(set) var type: LessonType
    private(set) var section: String
    private(set) var title: String
    private(set) var indexFile: File
    private(set) var files: [File]
    
    private(set) var isAlternativePreview = false
    
    init(type: LessonType, sectionNumber: Int, titleNumber: Int) {
        self.type = type
        section = Lesson.sections[type]?[sectionNumber] ?? ""
        title = Lesson.titles[type]?[sectionNumber][titleNumber] ?? ""
        switch type {
        case .htmlcss:
            switch sectionNumber {
            case 0:
                switch titleNumber {
                case 0:
                    indexFile = File(type: type, section: section, title: title, name: "index.html", editable: true)
                    files = [indexFile]
                default:
                    indexFile = File(type: type, section: section, title: title, name: "index.html", editable: true)
                    files = [indexFile]
                }
            default:
                indexFile = File(type: type, section: section, title: title, name: "index.html", editable: true)
                files = [indexFile]
            }
        case .javaScript:
            indexFile = File(type: type, section: section, title: title, name: "index.html", editable: true)
            files = [indexFile]
        case .php:
            switch sectionNumber {
            case 3:
                switch titleNumber {
                case 0:
                    indexFile = File(type: type, section: section, title: title, name: "index.php", editable: true)
                    files = [
                        indexFile,
                        File(type: type, section: section, title: title, name: "xss.php", editable: true),
                    ]
                case 1:
                    indexFile = File(type: type, section: section, title: title, name: "index.php", editable: false)
                    files = [
                        indexFile,
                        File(type: type, section: section, title: title, name: "notxss.php", editable: true),
                    ]
                case 2:
                    indexFile = File(type: type, section: section, title: title, name: "index.php", editable: false)
                    files = [
                        indexFile,
                        File(type: type, section: section, title: title, name: "send_sql.php", editable: false),
                        File(type: type, section: section, title: title, name: "sql_injection.php", editable: true),
                    ]
                case 3:
                    indexFile = File(type: type, section: section, title: title, name: "index.php", editable: false)
                    files = [
                        indexFile,
                        File(type: type, section: section, title: title, name: "send_sql.php", editable: false),
                        File(type: type, section: section, title: title, name: "not_sql_injection.php", editable: true),
                    ]
                default:
                    indexFile = File(type: type, section: section, title: title, name: "index.php", editable: true)
                    files = [
                        indexFile,
                        File(type: type, section: section, title: title, name: "xss.php", editable: true),
                    ]
                }
            default:
                indexFile = File(type: type, section: section, title: title, name: "index.php", editable: true)
                files = [
                    indexFile,
                    File(type: type, section: section, title: title, name: "xss.php", editable: true),
                ]
            }
        }
        if let relativeDirectoryURLString = self.relativeDirectoryURLString {
            let isExistingDirectory = DatabaseSession.sync(with: "CheckExistenceFile.php", parameters: ["path": relativeDirectoryURLString], method: .get)
            if isExistingDirectory == ServerResponse.true {
                for index in 0..<files.count {
                    files[index].load()
                }
            } else {
                for index in 0..<files.count {
                    files[index].initialize()
                    files[index].save()
                }
            }
        }
        Lesson.active = self
    }
    
    func save() {
        files.forEach { $0.save() }
    }
    
}
