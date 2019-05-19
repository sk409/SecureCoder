import Foundation

struct Lesson {
    
    static var active: Lesson?
    
    static let relativeRootDirectoryURLString = "Lessons/"
    static let absoluteRootDirectoryURLString = Application.webServerRootURLString + relativeRootDirectoryURLString
    
    static func sections(type: LessonType) -> [String]? {
        let urlString = relativeRootDirectoryURLString + type.rawValue
        let sectionsString = DatabaseSession.sync(with: "LoadFileNames.php", parameters: ["directory_path": urlString], method: .get)
        guard let sectionsArray = sectionsString.toArray() else {
            return nil
        }
        return sectionsArray.numberingSorted()
    }
    
    static func titles(type: LessonType, section: String) -> [String]? {
        let urlString = relativeRootDirectoryURLString + type.rawValue + "/" + section
        let titlesString = DatabaseSession.sync(with: "LoadFileNames.php", parameters: ["directory_path": urlString], method: .get)
        return titlesString.toArray()?.numberingSorted()
    }
    
    static func titles(type: LessonType, section: Int) -> [String]? {
        guard let sections = Lesson.sections(type: type) else {
            return nil
        }
        let section = sections[section]
        return Lesson.titles(type: type, section: section)
    }
    
    static func relativeDirectoryURLString(type: LessonType, section: String, title: String) -> String {
        return relativeRootDirectoryURLString + type.rawValue + "/" + section + "/" + title + "/"
    }
    
    static func relativeCoderDirectoryURLString(type: LessonType, section: String, title: String) -> String {
        return relativeRootDirectoryURLString + type.rawValue + "/" + section + "/" + title + "/" + "Coder/"
    }
    
    static func relativeCurrentCoderDirectoryURLString(type: LessonType, section: String, title: String) -> String? {
        guard let coderName = CoderManager.shared.coderName else {
            return nil
        }
        return relativeCoderDirectoryURLString(type: type, section: section, title: title) + coderName + "/"
    }
    
    static func relativeDefaultDirectoryURLString(type: LessonType, section: String, title: String) -> String {
        return relativeRootDirectoryURLString + type.rawValue + "/" + section + "/" + title + "/" + "Default/"
    }
    
    static func relativeAnswerDirectoryURLString(type: LessonType, section: String, title: String) -> String {
        return relativeRootDirectoryURLString + type.rawValue + "/" + section + "/" + title + "/" + "Answer/"
    }
    
    static func relativeDescriptionImageDirectoryURLString(type: LessonType, section: String, title: String) -> String {
        return relativeRootDirectoryURLString + type.rawValue + "/" + section + "/" + title + "/" + "DescriptionImage/"
    }
    
    static func absoluteDirectoryURLString(type: LessonType, section: String, title: String) -> String {
        return Application.webServerRootURLString + relativeDirectoryURLString(type: type, section: section, title: title)
    }
    
    static func absolutePreviewDirectoryURLString(type: LessonType, section: String, title: String) -> String {
        return absoluteDirectoryURLString(type: type, section: section, title: title) + "Preview/"
    }
    
    var relativeDirectoryURLString: String {
        return Lesson.relativeDirectoryURLString(type: type, section: section, title: title)
    }
    var relativeDefaultDirectoryURLString: String {
        return Lesson.relativeDefaultDirectoryURLString(type: type, section: section, title: title)
    }
    var relativeCurrentCoderDirectoryURLString: String? {
        return Lesson.relativeCurrentCoderDirectoryURLString(type: type, section: section, title: title)
    }
    var relativeAnswerDirectoryURLString: String {
        return Lesson.relativeAnswerDirectoryURLString(type: type, section: section, title: title)
    }
    var relativeDescriptionImageDirectoryURLString: String {
        return Lesson.relativeDescriptionImageDirectoryURLString(type: type, section: section, title: title)
    }
    var absoluteDirectoryURLString: String {
        return Lesson.absoluteDirectoryURLString(type: type, section: section, title: title)
    }
    var absolutePreviewDirectoryURLString: String {
        return Lesson.absolutePreviewDirectoryURLString(type: type, section: section, title: title)
    }
    
    private(set) var type: LessonType
    private(set) var section: String
    private(set) var title: String
    private(set) var indexFile: File?
    private(set) var files = [File]()
    
    init(type: LessonType, section: String, title: String) {
        self.type = type
        self.section = section
        self.title = title
        guard let relativeCurrentCoderDirectoryURLString = self.relativeCurrentCoderDirectoryURLString else {
            return
        }
        let fileNamesString = DatabaseSession.sync(with: "LoadFileNames.php", parameters: ["directory_path": relativeCurrentCoderDirectoryURLString], method: .get)
        guard var fileNamesArray = fileNamesString.toArray() else {
            return
        }
        let editableFileNamesString = DatabaseSession.sync(with: "ReadFile.php", parameters: ["path": relativeDirectoryURLString + "editable.json"], method: .get)
        guard let editableFileNamesArray = editableFileNamesString.toArray() else {
            return
        }
        files.reserveCapacity(fileNamesArray.count)
        for fileIndex in 0..<fileNamesArray.count {
            let fileName = fileNamesArray[fileIndex]
            let relativeFileURLString = relativeCurrentCoderDirectoryURLString + fileName
            let text = DatabaseSession.sync(with: "ReadFile.php", parameters: ["path": relativeFileURLString], method: .get)
            let isEditable = editableFileNamesArray.contains(fileName)
            let file = File(
                name: fileName,
                text: text,
                index: fileIndex,
                isEditable: isEditable
            )
            files.append(file)
            let indexFileNames = ["index.html", "index.php"]
            if indexFileNames.contains(file.name) {
                indexFile = file
            }
        }
        Lesson.active = self
    }
    
    func relativeFilURLString(fileIndex: Int) -> String? {
        guard 0 <= fileIndex && fileIndex <= (files.count - 1) else {
            return nil
        }
        guard let relativeCurrentCoderDirectoryURLString = self.relativeCurrentCoderDirectoryURLString else {
            return nil
        }
        let file = files[fileIndex]
        return relativeCurrentCoderDirectoryURLString + file.name
    }
    
    func absolutePreviewIndexFileURLString() -> String? {
        guard let indexFile = self.indexFile else {
            return nil
        }
        return absolutePreviewDirectoryURLString + indexFile.name
    }
    
    func initialize(fileIndex: Int) {
        guard 0 <= fileIndex && fileIndex <= (files.count - 1) else {
            return
        }
        let file = files[fileIndex]
        let text = DatabaseSession.sync(with: "ReadFile.php", parameters: ["path": relativeDefaultDirectoryURLString + file.name], method: .get)
        file.text = text
    }
    
    func save(_ file: File, with text: String) {
        save(fileIndex: file.index, with: text)
    }
    
    func save(fileIndex: Int, with text: String) {
        guard 0 <= fileIndex && fileIndex <= (files.count - 1) else {
            return
        }
        let file = files[fileIndex]
        file.text = text
        guard let percentEncodedText = file.text.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "&").inverted) else {
            return
        }
        guard let relativeFileURLString = self.relativeFilURLString(fileIndex: fileIndex) else {
            return
        }
        let result = DatabaseSession.sync(with: "SaveFile.php", parameters: ["path": relativeFileURLString, "data": percentEncodedText], method: .post)
        if result != ServerResponse.succeeded {
            Application.shared.writeErrorLog(result)
        }
    }
    
    func find(by fileName: String) -> File? {
        for file in files {
            guard file.name == fileName else {
                continue
            }
            return file
        }
        return nil
    }
    
}
