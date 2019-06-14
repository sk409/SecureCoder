import Foundation
import UIKit

struct Application {
    
    //static let webServerRootURLString = "http://localhost:80/"
    static let shared = Application()
    
    static func print(_ text: String, file: String = #file, function: String = #function, line: Int = #line) {
        Swift.print(file, ": ", function, "(", line, ")")
        Swift.print(text)
    }
    
    static func printErrorLog(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        Swift.print("|----ERROR----|")
        print(message, file: file, function: function, line: line)
        Swift.print("|----ERROR----|")
    }
    
    static func makeDirectoryIfNotExists(url: URL) {
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                Application.printErrorLog(error.localizedDescription)
            }
        }
    }
    
    static func makeDirectoriesIfNotExists(urls: [URL]) {
        urls.forEach { makeDirectoryIfNotExists(url: $0) }
    }
    
    private static func makeCourse(with courseDirectoryURL: URL) -> Course? {
        let courseTitle = courseDirectoryURL.lastPathComponent
        guard let contentsInCourseDirectory = try? FileManager.default.contentsOfDirectory(atPath: courseDirectoryURL.path),
              let language = ProgramingLanguage(rawValue: courseTitle)
        else {
            return nil
        }
        let sections = contentsInCourseDirectory.compactMap { makeSection(with: courseDirectoryURL.appendingPathComponent($0)) }
        return Course(language: language, title: courseTitle, sections: sections)
    }
    
    private static func makeSection(with sectionDirectoryURL: URL) -> Section? {
        let courseTitle = sectionDirectoryURL.deletingLastPathComponent().lastPathComponent
        let sectionTitle = sectionDirectoryURL.lastPathComponent
        var sectionData: SectionData?
        var lessons = [Lesson]()
        guard let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
              let contentsInSectionDirectory = try? FileManager.default.contentsOfDirectory(atPath: sectionDirectoryURL.path)
        else {
            return nil
        }
        for contentInSectionDirectory in contentsInSectionDirectory {
            if contentInSectionDirectory == "data.json", let data = try? Data(contentsOf: sectionDirectoryURL.appendingPathComponent(contentInSectionDirectory)) {
                sectionData = try? JSONDecoder().decode(SectionData.self, from: data)
            } else {
                let userDirectoryURL = documentURL.appendingPathComponent(courseTitle).appendingPathComponent(sectionTitle).appendingPathComponent(contentInSectionDirectory)
                let previewDirectoryURL = userDirectoryURL.appendingPathComponent("preview")
                let answerDirectoryURL = userDirectoryURL.appendingPathComponent("answer")
                makeDirectoriesIfNotExists(urls: [
                    previewDirectoryURL,
                    answerDirectoryURL,
                    ])
                guard let lesson = makeLesson(
                    with: sectionDirectoryURL.appendingPathComponent(contentInSectionDirectory),
                    userDirectoryURL: userDirectoryURL,
                    previewDirectoryURL: previewDirectoryURL,
                    answerDirectoryURL: answerDirectoryURL
                    ) else {
                    return nil
                }
                lessons.append(lesson)
            }
        }
        guard sectionData != nil else {
            return nil
        }
        return Section(title: sectionData!.title, content: sectionData!.content, skills: sectionData!.skills, lessons: lessons)
    }
    
    private static func makeLesson(
        with lessonDirectoryURL: URL,
        userDirectoryURL: URL,
        previewDirectoryURL: URL,
        answerDirectoryURL: URL
    ) -> Lesson? {
        guard let contentsInLessonDirectory = try? FileManager.default.contentsOfDirectory(atPath: lessonDirectoryURL.path) else {
            return nil
        }
        var files = [File]()
        var slides = [Slide]()
        var descriptions = [Description]()
        for contentInLessonDirectory in contentsInLessonDirectory {
            let folderURL = lessonDirectoryURL.appendingPathComponent(contentInLessonDirectory)
            guard let contentTitles = try? FileManager.default.contentsOfDirectory(atPath: folderURL.path) else {
                return nil
            }
            if contentInLessonDirectory == "files" {
                files = contentTitles.compactMap { fileTitle in
                    return makeFile(
                        with: folderURL.appendingPathComponent(fileTitle),
                        userDirectoryURL: userDirectoryURL,
                        previewDirectoryURL: previewDirectoryURL,
                        answerDirectoryURL: answerDirectoryURL)
                }
            } else if contentInLessonDirectory == "slides" {
                slides = contentTitles.compactMap { slideTitle in
                    return makeSlide(with: folderURL.appendingPathComponent(slideTitle))
                }
            } else if contentInLessonDirectory == "descriptions" {
                descriptions = contentTitles.compactMap { descriptionTitle in
                    return makeDescription(with: folderURL.appendingPathComponent(descriptionTitle))
                }
            }
        }
        let lessonTitle = lessonDirectoryURL.lastPathComponent
        return Lesson(
            title: lessonTitle,
            files: files,
            slides: slides,
            descriptios: descriptions)
    }
    
    private static func makeFile(
        with fileURL: URL,
        userDirectoryURL: URL,
        previewDirectoryURL: URL,
        answerDirectoryURL: URL
    ) -> File? {
        guard let text = try? String(contentsOf: fileURL) else {
            return nil
        }
        let fileTitle = fileURL.lastPathComponent
        let userURL = userDirectoryURL.appendingPathComponent(fileTitle)
        let previewURL = previewDirectoryURL.appendingPathComponent(fileTitle)
        let answerURL = answerDirectoryURL.appendingPathComponent(fileTitle)
        ///////////////////////////////////////////////////////
        // TEST
        if FileManager.default.fileExists(atPath: userURL.path) {
            try! FileManager.default.removeItem(at: userURL)
        }
        if FileManager.default.fileExists(atPath: previewURL.path) {
            try! FileManager.default.removeItem(at: previewURL)
        }
        // TEST
        ///////////////////////////////////////////////////////
        if !FileManager.default.fileExists(atPath: userURL.path) {
            let userText = LessonTextParser().parse(text)
            let succeeded = FileManager.default.createFile(
                atPath: userURL.path,
                contents: userText.data(using: .utf8),
                attributes: nil)
            if !succeeded {
                Application.printErrorLog("Failed to create user file.")
            }
        }
        if !FileManager.default.fileExists(atPath: previewURL.path) {
            let userText = LessonTextParser().parse(text)
            let previewText = UserFileManager.formatUserTextToPreviewText(userText)
            let succeeded = FileManager.default.createFile(
                atPath: previewURL.path,
                contents: previewText.data(using: .utf8),
                attributes: nil)
            if !succeeded {
                Application.printErrorLog("Failed to create preview file.")
            }
        }
        if !FileManager.default.fileExists(atPath: answerURL.path) {
            let answerText = UserFileManager.formatLessonTextToAnserText(text)
            let succeeded = FileManager.default.createFile(
                atPath: answerURL.path,
                contents: answerText.data(using: .utf8),
                attributes: nil)
            if !succeeded {
                Application.printErrorLog("Failed to create answer file.")
            }
        }
        return File(
            title: fileTitle,
            text: text,
            url: fileURL,
            userURL: userURL,
            previewURL: previewURL,
            answerURL: answerURL)
    }
    
    private static func makeSlide(with slideURL: URL) -> Slide? {
        guard let data = try? Data(contentsOf: slideURL) else {
            return nil
        }
        return try? JSONDecoder().decode(Slide.self, from: data)
    }
    
    private static func makeDescription(with descriptionURL: URL) -> Description? {
        guard let data = try? Data(contentsOf: descriptionURL) else {
            return nil
        }
        return try? JSONDecoder().decode(Description.self, from: data)
    }
    
    private let courses: [Course]
    
    func course(_ language: ProgramingLanguage) -> Course? {
        for course in courses {
            guard course.language == language else {
                continue
            }
            return course
        }
        return nil
    }
    
    private init() {
        guard let coursesDirectoryURL = Bundle.main.url(forResource: "Courses", withExtension: nil),
              let contentsInCoursesDirectory = try? FileManager.default.contentsOfDirectory(atPath: coursesDirectoryURL.path)
        else {
            self.courses = []
            return
        }
        self.courses = contentsInCoursesDirectory.compactMap { courseTitle -> Course? in
            let courseDirectoryURL = coursesDirectoryURL.appendingPathComponent(courseTitle)
            return Application.makeCourse(with: courseDirectoryURL)
        }
    }
    
}
