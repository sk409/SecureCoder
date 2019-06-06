import Foundation
import UIKit

struct Application {
    
    static let shared = Application()
    
    //static let webServerRootURLString = "http://localhost:80/"

//    static let baseColor = UIColor.white
//    static let mainColor = UIColor.orange
//    static let accentColor = UIColor.yellow
    
//    struct HTML11: Lesson {
//    
//        let title = "HTML,CSSの世界へようこそ"
//    
//        let text = """
//    @[@html@]@#[#<!-- HTML5のDOCTYPE宣言をしてください -->#]#
//    ?[?<!DOCTYPE html>?]?
//    
//    #[#<!-- 見出しレベル１でマークアップしてください -->#]#
//    ?[?<h1>?]?#[#Hello World#]#?[?</h1>?]?
//    """
//    
//        let slides = [
//            Slide(
//                title: "HTML,CSSの世界へようこそ",
//                content: "HTML,CSSはWebサイトを作るための言語です。\n以下のようなサイトもHTML,CSSのみで作成することができます。",
//                imageName: nil
//            ),
//            Slide(title: "DOCTYPE宣言",
//                  content: "DOCTYPE宣言はサイト内で使われるHTMLのバージョンを指定します。\n現在最もよく使われているのは「HTML5」です。",
//                  imageName: nil
//            ),
//            Slide(title: "HTML5",
//                  content: "HTML5を用いてWebサイトを作成するには最初に、「<!DOCTYPE html>」と記述します。",
//                  imageName: nil
//            ),
//        ]
//    
//        let descriptios = [
//            Description(title: "演習1-1", content: "DOCTYPE宣言をしてみよう。")
//        ]
//    
//    }

    
    
//    private static let courses = [
//        Course(
//            language: .html,
//            title: "HTML",
//            sections: [
//                Section(title: "HTMLの基礎を学ぼう", lessons: [
//                    Lesson(
//                        title: "HTMLの世界へようこそ",
//                        text: """
//    @[@html@]@#[#<!-- HTML5のDOCTYPE宣言をしてください -->#]#
//    ?[?<!DOCTYPE html>?]?
//
//    #[#<!-- 見出しレベル１でマークアップしてください -->#]#
//    ?[?<h1>?]?#[#Hello World#]#?[?</h1>?]?
//    """,
//                        url: makeURL(for: .documentDirectory, components: "HTML", "HTMLの基礎を学ぼう", "HTMLの世界へようこそ")!,
//                        slides: [
//                            Slide(
//                                title: "HTML,CSSの世界へようこそ",
//                                content: "HTML,CSSはWebサイトを作るための言語です。\n以下のようなサイトもHTML,CSSのみで作成することができます。",
//                                imageName: nil),
//                            Slide(
//                                title: "DOCTYPE宣言",
//                                content: "DOCTYPE宣言はサイト内で使われるHTMLのバージョンを指定します。\n現在最もよく使われているのは「HTML5」です。",
//                                imageName: nil),
//                            Slide(title: "HTML5",
//                                content: "HTML5を用いてWebサイトを作成するには最初に、「<!DOCTYPE html>」と記述します。",
//                                imageName: nil),
//                        ],
//                        descriptios: [])
//                    ])
//            ]),
//        Course(
//            language: .javaScript,
//            title: "JavaScript",
//            sections: [
//                Section(title: "JavaScriptの基礎を学ぼう", lessons: [])
//            ]),
//        Course(
//            language: .php,
//            title: "PHP",
//            sections: [
//                Section(title: "セキュアなアプリケーションを作ってみよう", lessons: [
//
//                    ])
//            ]),
//    ]
    
    let courses: [Course]
    
//    func initialize() {
//        guard let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            return
//        }
//        
//        //let appDirectoryURL = documentURL.appendingPathComponent("SecureCoder")
////        createDirectory(at: appDirectoryURL, withIntermediateDirectories: false)
////        for course in courses {
////            let languageURL = appDirectoryURL.appendingPathComponent(course.title)
////            createDirectory(at: languageURL, withIntermediateDirectories: false)
////            for section in course.sections {
////                let sectionURL = languageURL.appendingPathComponent(section.title)
////                createDirectory(at: sectionURL, withIntermediateDirectories: false)
////                for lesson in section.lessons {
////                    let lessonURL = sectionURL.appendingPathComponent(lesson.title)
////                    createDirectory(at: lessonURL, withIntermediateDirectories: false)
////                }
////            }
////        }
//        //printFileHierarchy(root: appDirectoryURL)
//    }
    
//    static func course(_ language: ProgramingLanguage) -> Course {
//        switch language {
//        case .html:
//            return courses[0]
//        case .javaScript:
//            return courses[1]
//        case .php:
//            return courses[2]
//        }
//    }
    
//    func makeURL(for directory: FileManager.SearchPathDirectory, components: String...) -> URL? {
//        guard var url = FileManager.default.urls(for: directory, in: .userDomainMask).first else {
//            return nil
//        }
//        components.forEach { url.appendPathComponent($0) }
//        return url
//    }
    
//    static func isDirectory(path: String) -> Bool {
//        var isDirectory: ObjCBool = false
//        guard FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) else {
//            return false
//        }
//        return isDirectory.boolValue
//    }
//
//    static func contentsOfDirectory(at path: String) -> [String]? {
//        var contents: [String]?
//        do {
//            contents = try FileManager.default.contentsOfDirectory(atPath: path)
//        } catch {
//            writeErrorLog(error.localizedDescription)
//        }
//        return contents
//    }
//
//    static func createFile(at url: URL, text: String, file: String = #file, function: String = #function, line: Int = #line) {
//        let succeeded = FileManager.default.createFile(atPath: url.path, contents: text.data(using: .utf8), attributes: nil)
//        if !succeeded {
//            writeErrorLog("Failed to create file.", file: file, function: function, line: line)
//        }
//    }
//
//    static func createDirectory(at url: URL, withIntermediateDirectories: Bool, file: String = #file, function: String = #function, line: Int = #line) {
//        do {
//            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: withIntermediateDirectories, attributes: nil)
//        } catch {
//            writeErrorLog(error.localizedDescription, file: file, function: function, line: line)
//        }
//    }
    
    static func writeErrorLog(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        print("|----ERROR----|")
        print("|", file, ": ", function, "(", line, ")")
        print("|", message)
        print("|----ERROR----|")
    }
    
//    static func printFileHierarchy(root: URL) {
//        printFileHierarchy(root, indent: 0)
//    }
//
//    private static func printFileHierarchy(_ current: URL, indent: Int) {
//        let printIndent: (Int) -> Void = { indent in
//            [String](repeating: " ", count: indent).forEach { print($0, terminator: "") }
//        }
//        printIndent(indent)
//        print(current.lastPathComponent)
//        guard let contents = contentsOfDirectory(at: current.path) else {
//            return
//        }
//        for content in contents {
//            let contentURL = current.appendingPathComponent(content)
//            if isDirectory(path: contentURL.path) {
//                printFileHierarchy(contentURL, indent: indent + 2)
//            } else {
//                printIndent(indent + 2)
//                print(content)
//            }
//        }
//    }
    
    private init() {
        var courses = [Course]()
        guard let appURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("SecureCoder") else {
            self.courses = []
            return
        }
        guard let courseURL = Bundle.main.url(forResource: "Course", withExtension: nil) else {
            self.courses = []
            return
        }
        guard let courseTitles = try? FileManager.default.contentsOfDirectory(atPath: courseURL.path) else {
            self.courses = []
            return
        }
        for courseTitle in courseTitles {
            let sectionURL = courseURL.appendingPathComponent(courseTitle)
            guard let sectionTitles = try? FileManager.default.contentsOfDirectory(atPath: sectionURL.path) else {
                self.courses = []
                return
            }
            var sections = [Section]()
            for sectionTitle in sectionTitles {
                let lessonURL = sectionURL.appendingPathComponent(sectionTitle)
                guard let lessonTitles = try? FileManager.default.contentsOfDirectory(atPath: lessonURL.path) else {
                    self.courses = []
                    return
                }
                var lessons = [Lesson]()
                for lessonTitle in lessonTitles {
                    let contentURL = lessonURL.appendingPathComponent(lessonTitle)
                    guard let contents = try? FileManager.default.contentsOfDirectory(atPath: contentURL.path) else {
                        self.courses = []
                        return
                    }
                    var files = [File]()
                    var slides = [Slide]()
                    var descriptions = [Description]()
                    for content in contents {
                        let folderURL = contentURL.appendingPathComponent(content)
                        guard let contentTitles = try? FileManager.default.contentsOfDirectory(atPath: folderURL.path) else {
                            self.courses = []
                            return
                        }
                        if content == "files" {
                            for fileTitle in contentTitles {
                                let fileURL = folderURL.appendingPathComponent(fileTitle)
                                guard let text = try? String(contentsOf: fileURL) else {
                                    self.courses = []
                                    return
                                }
                                files.append(File(title: fileTitle, text: text))
                            }
                        } else if content == "slides" {
                            for slideTitle in contentTitles {
                                let slideURL = folderURL.appendingPathComponent(slideTitle)
                                guard let data = try? Data(contentsOf: slideURL) else {
                                    self.courses = []
                                    return
                                }
                                guard let slide = try? JSONDecoder().decode(Slide.self, from: data) else {
                                    self.courses = []
                                    return
                                }
                                slides.append(slide)
                            }
                        } else if content == "descriptions" {
                            for descriptionTitle in contentTitles {
                                let descriptionURL = folderURL.appendingPathComponent(descriptionTitle)
                                guard let data = try? Data(contentsOf: descriptionURL) else {
                                    self.courses = []
                                    return
                                }
                                guard let description = try? JSONDecoder().decode(Description.self, from: data) else {
                                    self.courses = []
                                    return
                                }
                                descriptions.append(description)
                            }
                        }
                    }
                    lessons.append(Lesson(
                        title: lessonTitle,
                        files: files,
                        url: appURL.appendingPathComponent(courseTitle).appendingPathComponent(sectionTitle).appendingPathComponent(lessonTitle),
                        slides: slides,
                        descriptios: descriptions
                    ))
                }
                sections.append(Section(title: sectionTitle, lessons: lessons))
            }
            courses.append(Course(language: .html, title: courseTitle, sections: sections))
        }
        self.courses = courses
    }
    
}
