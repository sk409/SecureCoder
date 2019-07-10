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
    
    let courses: [Course]
    
//    private static func makeCourse(with courseDirectoryURL: URL) -> Course? {
//        let courseTitle = courseDirectoryURL.lastPathComponent
//        guard let contentsInCourseDirectory = try? FileManager.default.contentsOfDirectory(atPath: courseDirectoryURL.path),
//              let language = ProgramingLanguage(rawValue: courseTitle)
//        else {
//            return nil
//        }
//        let sections = contentsInCourseDirectory.compactMap { makeSection(with: courseDirectoryURL.appendingPathComponent($0)) }
//        return Course(language: language, title: courseTitle, sections: sections)
//    }
//
//    private static func makeSection(with sectionDirectoryURL: URL) -> Section? {
//        let courseTitle = sectionDirectoryURL.deletingLastPathComponent().lastPathComponent
//        let sectionTitle = sectionDirectoryURL.lastPathComponent
//        var sectionData: SectionData?
//        var lessons = [Lesson]()
//        guard let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
//              let contentsInSectionDirectory = try? FileManager.default.contentsOfDirectory(atPath: sectionDirectoryURL.path)
//        else {
//            return nil
//        }
//        for contentInSectionDirectory in contentsInSectionDirectory {
//            if contentInSectionDirectory == "data.json", let data = try? Data(contentsOf: sectionDirectoryURL.appendingPathComponent(contentInSectionDirectory)) {
//                sectionData = try? JSONDecoder().decode(SectionData.self, from: data)
//            } else {
//                let userDirectoryURL = documentURL.appendingPathComponent(courseTitle).appendingPathComponent(sectionTitle).appendingPathComponent(contentInSectionDirectory)
////                if courseTitle == "php" {
////                    userDirectoryURL = URLUtils.make(["http://localhost/users", courseTitle, sectionTitle, contentInSectionDirectory])!
////                } else {
////                    userDirectoryURL =
////                }
//                let previewDirectoryURL: URL
//                let answerDirectoryURL: URL
//                if courseTitle == "php" {
//                    previewDirectoryURL = URLUtils.make(["http://localhost", courseTitle, sectionTitle, contentInSectionDirectory, "preview"])!
//                    answerDirectoryURL = URLUtils.make(["http://localhost", courseTitle, sectionTitle, contentInSectionDirectory, "answer"])!
//                } else {
//                    previewDirectoryURL = userDirectoryURL.appendingPathComponent("preview")
//                    answerDirectoryURL = userDirectoryURL.appendingPathComponent("answer")
//                }
//                FileUtils.makeDirectories(urls: [
//                    userDirectoryURL,
//                    previewDirectoryURL,
//                    answerDirectoryURL,
//                    ])
//                guard let lesson = makeLesson(
//                    with: sectionDirectoryURL.appendingPathComponent(contentInSectionDirectory),
//                    userDirectoryURL: userDirectoryURL,
//                    previewDirectoryURL: previewDirectoryURL,
//                    answerDirectoryURL: answerDirectoryURL
//                    ) else {
//                    return nil
//                }
//                lessons.append(lesson)
//            }
//        }
//        guard sectionData != nil else {
//            return nil
//        }
//        return Section(title: sectionData!.title, content: sectionData!.content, skills: sectionData!.skills, lessons: lessons)
//    }
//
//    private static func makeLesson(
//        with lessonDirectoryURL: URL,
//        userDirectoryURL: URL,
//        previewDirectoryURL: URL,
//        answerDirectoryURL: URL
//    ) -> Lesson? {
//        guard let contentsInLessonDirectory = try? FileManager.default.contentsOfDirectory(atPath: lessonDirectoryURL.path) else {
//            return nil
//        }
//        var files = [File]()
//        var slides = [Slide]()
//        var descriptions = [String: [Description]]()
//        for contentInLessonDirectory in contentsInLessonDirectory {
//            let folderURL = lessonDirectoryURL.appendingPathComponent(contentInLessonDirectory)
//            guard let contentTitles = try? FileManager.default.contentsOfDirectory(atPath: folderURL.path) else {
//                return nil
//            }
//            if contentInLessonDirectory == "files" {
//                files = contentTitles.compactMap { fileTitle in
//                    return makeFile(
//                        with: folderURL.appendingPathComponent(fileTitle),
//                        userDirectoryURL: userDirectoryURL,
//                        previewDirectoryURL: previewDirectoryURL,
//                        answerDirectoryURL: answerDirectoryURL)
//                }
//            } else if contentInLessonDirectory == "slides" {
//                slides = contentTitles.compactMap { slideTitle in
//                    return makeSlide(with: folderURL.appendingPathComponent(slideTitle))
//                }
//            } else if contentInLessonDirectory == "descriptions" {
//                contentTitles.forEach { descriptionTitle in
//                    guard let description = makeDescriptions(with: folderURL.appendingPathComponent(descriptionTitle)) else {
//                        return
//                    }
//                    let describedFileName = descriptionTitle.replacingOccurrences(of: ".json", with: "")
//                    descriptions[describedFileName] = description
//                }
//            }
//        }
//        let lessonTitle = lessonDirectoryURL.lastPathComponent
//        return Lesson(
//            title: lessonTitle,
//            files: files,
//            slides: slides,
//            descriptios: descriptions)
//    }
//
//    private static func makeFile(
//        with fileURL: URL,
//        userDirectoryURL: URL,
//        previewDirectoryURL: URL,
//        answerDirectoryURL: URL
//    ) -> File? {
//        guard let text = try? String(contentsOf: fileURL) else {
//            return nil
//        }
//        let fileTitle = fileURL.lastPathComponent
//        let userURL = userDirectoryURL.appendingPathComponent(fileTitle)
//        let previewURL = previewDirectoryURL.appendingPathComponent(fileTitle)
//        let answerURL = answerDirectoryURL.appendingPathComponent(fileTitle)
//        let file = File(
//            title: fileTitle,
//            text: text,
//            url: fileURL,
//            userURL: userURL,
//            previewURL: previewURL,
//            answerURL: answerURL)
//        ///////////////////////////////////////////////////////
//        // TEST
//        FileUtils.deleteFile(url: userURL)
//        FileUtils.deleteFile(url: previewURL)
//        FileUtils.deleteFile(url: answerURL)
//        // TEST
//        ///////////////////////////////////////////////////////
//        if let programingLanguage = file.programingLanguage {
//            var lessonTextParser = LessonTextParser()
//            let userText = lessonTextParser.parse(text, language: programingLanguage)
//            FileUtils.makeFile(url: userURL, text: userText)
//            let previewText = TextUtils.formatUserTextToPreviewText(userText, language: programingLanguage)
//            FileUtils.makeFile(url: previewURL, text: previewText)
//            let answerText = TextUtils.formatLessonTextToAnserText(text)
//            FileUtils.makeFile(url: answerURL, text: answerText)
//        }
//        return file
//    }
//
//    private static func makeSlide(with slideURL: URL) -> Slide? {
//        guard let data = try? Data(contentsOf: slideURL) else {
//            return nil
//        }
//        return try? JSONDecoder().decode(Slide.self, from: data)
//    }
//
//    private static func makeDescriptions(with descriptionURL: URL) -> [Description]? {
//        guard let data = try? Data(contentsOf: descriptionURL) else {
//            return nil
//        }
//        return try? JSONDecoder().decode([Description].self, from: data)
//    }
//
//    private let courses: [Course]
//
//    func course(_ language: ProgramingLanguage) -> Course? {
//        for course in courses {
//            guard course.language == language else {
//                continue
//            }
//            return course
//        }
//        return nil
//    }
    
    private init() {
        guard let coursesDirectoryURL = Bundle.main.url(forResource: "Courses", withExtension: nil),
              let courseTitles = try? FileManager.default.contentsOfDirectory(atPath: coursesDirectoryURL.path)
        else {
            self.courses = []
            return
        }
        var courses = [Course]()
        for courseDirectoryName in courseTitles {
            let courseDirectoryURL = coursesDirectoryURL.appendingPathComponent(courseDirectoryName)
            if let contentsInCourseDirectory = try? FileManager.default.contentsOfDirectory(atPath: courseDirectoryURL.path) {
                var courseInfo: CourseInfo?
                var chapters = [Chapter]()
                for contentInCourseDirectory in contentsInCourseDirectory {
                    if contentInCourseDirectory == "info.json" {
                        let courseInfoURL = courseDirectoryURL.appendingPathComponent(contentInCourseDirectory)
                        if let courseInfoData = try? Data(contentsOf: courseInfoURL) {
                            courseInfo = try? JSONDecoder().decode(CourseInfo.self, from: courseInfoData)
                        }
                    } else {
                        let chapterDirectoryName = contentInCourseDirectory
                        let chapterDirectoryURL = courseDirectoryURL.appendingPathComponent(chapterDirectoryName)
                        var chapterInfo: ChapterInfo?
                        var sections = [Section]()
                        if let contentsInChapterDirectory = try? FileManager.default.contentsOfDirectory(atPath: chapterDirectoryURL.path) {
                            for contentInChapterDirectory in contentsInChapterDirectory {
                                if contentInChapterDirectory == "info.json" {
                                    let chapterInfoURL = chapterDirectoryURL.appendingPathComponent(contentInChapterDirectory)
                                    if let chapterInfoData = try? Data(contentsOf: chapterInfoURL) {
                                        chapterInfo = try? JSONDecoder().decode(ChapterInfo.self, from: chapterInfoData)
                                    }
                                } else {
                                    let sectionDirectoryName = contentInChapterDirectory
                                    let sectionDirectoryURL = chapterDirectoryURL.appendingPathComponent(sectionDirectoryName)
                                    if let contentsInSectionDirectory = try? FileManager.default.contentsOfDirectory(atPath: sectionDirectoryURL.path) {
                                        var sectionInfo: SectionInfo?
                                        var safeLesson: Lesson?
                                        var unsafeLesson: Lesson?
                                        for contentInSectionDirectory in contentsInSectionDirectory {
                                            if contentInSectionDirectory == "info.json" {
                                                let sectionInfoURL = sectionDirectoryURL.appendingPathComponent(contentInSectionDirectory)
                                                if let sectionInfoData = try? Data(contentsOf: sectionInfoURL) {
                                                    sectionInfo = try? JSONDecoder().decode(SectionInfo.self, from: sectionInfoData)
                                                }
                                            } else {
                                                var lessonInfo: LessonInfo?
                                                var domains = [Domain]()
                                                var guides = [Guide]()
                                                var keyboardWords = [KeyboardWords]()
                                                let lessonTitle = contentInSectionDirectory
                                                let lessonDirectoryURL = sectionDirectoryURL.appendingPathComponent(lessonTitle)
                                                if let contentsInLessonDirectory = try? FileManager.default.contentsOfDirectory(atPath: lessonDirectoryURL.path)
                                                {
                                                    for contentInLessonDirectory in contentsInLessonDirectory {
                                                        if contentInLessonDirectory == "files" {
                                                            let fileDirectoryURL = lessonDirectoryURL.appendingPathComponent(contentInLessonDirectory)
                                                            if let domainNames = try? FileManager.default.contentsOfDirectory(atPath: fileDirectoryURL.path)
                                                            {
                                                                for domainName in domainNames {
                                                                    let domainDirectoryURL = fileDirectoryURL.appendingPathComponent(domainName)
                                                                    if let fileNames = try? FileManager.default.contentsOfDirectory(atPath: domainDirectoryURL.path)
                                                                    {
                                                                        var files = [File]()
                                                                        for fileName in fileNames {
                                                                            if let fileText = try? String(contentsOf: domainDirectoryURL.appendingPathComponent(fileName))
                                                                            {
                                                                                files.append(File(name: fileName, text: fileText))
                                                                            }
                                                                        }
                                                                        domains.append(Domain(name: domainName, files: files))
                                                                    }
                                                                }
                                                            }
                                                        } else if contentInLessonDirectory == "guides" {
                                                            let guideDirectoryURL = lessonDirectoryURL.appendingPathComponent(contentInLessonDirectory)
                                                            if let guideJSONNames = try? FileManager.default.contentsOfDirectory(atPath: guideDirectoryURL.path)
                                                            {
                                                                for guideJSONName in guideJSONNames {
                                                                    let guideJSONURL = guideDirectoryURL.appendingPathComponent(guideJSONName)
                                                                    if let guideData = try? Data(contentsOf: guideJSONURL)
                                                                    {
                                                                        if let guide = try? JSONDecoder().decode(Guide.self, from: guideData)
                                                                        {
                                                                            guides.append(guide)
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        } else if contentInLessonDirectory == "keyboard_words" {
                                                            let keyboardWordsDirectoryURL = lessonDirectoryURL.appendingPathComponent(contentInLessonDirectory)
                                                            if let keyboardWordsJSONs = try? FileManager.default.contentsOfDirectory(atPath: keyboardWordsDirectoryURL.path) {
                                                                for keyboardWordsJSON in keyboardWordsJSONs {
                                                                    let keyboardWordsURL = keyboardWordsDirectoryURL.appendingPathComponent(keyboardWordsJSON)
                                                                    if let keyboardWordsData = try? Data(contentsOf: keyboardWordsURL) {
                                                                        if let kw = try? JSONDecoder().decode(KeyboardWords.self, from: keyboardWordsData) {
                                                                            keyboardWords.append(kw)
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        } else if contentInLessonDirectory == "info.json" {
                                                            let infoJSONURL = lessonDirectoryURL.appendingPathComponent(contentInLessonDirectory)
                                                            if let lessonInfoData = try? Data(contentsOf: infoJSONURL) {
                                                                lessonInfo = try? JSONDecoder().decode(LessonInfo.self, from: lessonInfoData)
                                                            }
                                                        }
                                                    }
                                                }
                                                guides.sort { $0.index < $1.index }
                                                if let li = lessonInfo {
                                                    if lessonTitle == "safe" {
                                                        safeLesson = Lesson(title: li.title, domains: domains, guides: guides, keyboardWords: keyboardWords)
                                                    } else {
                                                        unsafeLesson = Lesson(title: li.title, domains: domains, guides: guides, keyboardWords: keyboardWords)
                                                    }
                                                }
                                            }
                                        }
                                        if let si = sectionInfo,
                                           let sl = safeLesson,
                                           let ul = unsafeLesson
                                        {
                                            sections.append(Section(index: si.index, title: si.title, description: si.description, safeLesson: sl, unsafeLesson: ul))
                                        }
                                    }
                                }
                            }
                        }
                        if let ci = chapterInfo {
                            chapters.append(Chapter(index: ci.index, title: ci.title, sections: sections.sorted { $0.index < $1.index }))
                        }
                    }
                }
                if let ci = courseInfo {
                    courses.append(Course(index: ci.index, title: ci.title, threats: ci.threats, chapters: chapters.sorted { $0.index < $1.index }))
                }
            }
        }
        self.courses = courses.sorted() { $0.index < $1.index }
    }
    
}
