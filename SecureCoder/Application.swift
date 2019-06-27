import Foundation
import UIKit

struct Application {
    
    //static let webServerRootURLString = "http://localhost:80/"
    static let shared = Application()
    
    static func print<T: CustomStringConvertible>(_ text: T, file: String = #file, function: String = #function, line: Int = #line) {
        Swift.print(file, ": ", function, "(", line, ")")
        Swift.print(text)
    }
    
    static func printErrorLog(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        Swift.print("|----ERROR----|")
        print(message, file: file, function: function, line: line)
        Swift.print("|----ERROR----|")
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
//                if courseTitle == "php" {
//                    userDirectoryURL = URLUtils.make(["http://localhost/users", courseTitle, sectionTitle, contentInSectionDirectory])!
//                } else {
//                    userDirectoryURL =
//                }
                let previewDirectoryURL: URL
                let answerDirectoryURL: URL
                if courseTitle == "php" {
                    previewDirectoryURL = URLUtils.make(["http://localhost", courseTitle, sectionTitle, contentInSectionDirectory, "preview"])!
                    answerDirectoryURL = URLUtils.make(["http://localhost", courseTitle, sectionTitle, contentInSectionDirectory, "answer"])!
                } else {
                    previewDirectoryURL = userDirectoryURL.appendingPathComponent("preview")
                    answerDirectoryURL = userDirectoryURL.appendingPathComponent("answer")
                }
                FileUtils.makeDirectories(urls: [
                    userDirectoryURL,
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
        var descriptions = [String: [Description]]()
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
                contentTitles.forEach { descriptionTitle in
                    guard let description = makeDescriptions(with: folderURL.appendingPathComponent(descriptionTitle)) else {
                        return
                    }
                    let describedFileName = descriptionTitle.replacingOccurrences(of: ".json", with: "")
                    descriptions[describedFileName] = description
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
        let file = File(
            title: fileTitle,
            text: text,
            url: fileURL,
            userURL: userURL,
            previewURL: previewURL,
            answerURL: answerURL)
        ///////////////////////////////////////////////////////
        // TEST
        FileUtils.deleteFile(url: userURL)
        FileUtils.deleteFile(url: previewURL)
        FileUtils.deleteFile(url: answerURL)
        // TEST
        ///////////////////////////////////////////////////////
        if let programingLanguage = file.programingLanguage {
            var lessonTextParser = LessonTextParser()
            let userText = lessonTextParser.parse(text, language: programingLanguage)
            FileUtils.makeFile(url: userURL, text: userText)
            let previewText = TextUtils.formatUserTextToPreviewText(userText, language: programingLanguage)
            FileUtils.makeFile(url: previewURL, text: previewText)
            let answerText = TextUtils.formatLessonTextToAnserText(text)
            FileUtils.makeFile(url: answerURL, text: answerText)
        }
        return file
    }
    
    private static func makeSlide(with slideURL: URL) -> Slide? {
        guard let data = try? Data(contentsOf: slideURL) else {
            return nil
        }
        return try? JSONDecoder().decode(Slide.self, from: data)
    }
    
    private static func makeDescriptions(with descriptionURL: URL) -> [Description]? {
        guard let data = try? Data(contentsOf: descriptionURL) else {
            return nil
        }
        return try? JSONDecoder().decode([Description].self, from: data)
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
