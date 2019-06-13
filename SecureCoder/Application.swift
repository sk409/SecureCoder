import Foundation
import UIKit

struct Application {
    
    static let shared = Application()
    
    //static let webServerRootURLString = "http://localhost:80/"
    
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
    
    static func print(_ text: String, file: String = #file, function: String = #function, line: Int = #line) {
        Swift.print(file, ": ", function, "(", line, ")")
        Swift.print(text)
    }
    
    static func printErrorLog(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        Swift.print("|----ERROR----|")
        print(message, file: file, function: function, line: line)
        Swift.print("|----ERROR----|")
    }
    
    private init() {
        var courses = [Course]()
        guard let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            self.courses = []
            return
        }
        guard let coursesDirectoryURL = Bundle.main.url(forResource: "Courses", withExtension: nil) else {
            self.courses = []
            return
        }
        guard let contentsInCoursesDirectory = try? FileManager.default.contentsOfDirectory(atPath: coursesDirectoryURL.path) else {
            self.courses = []
            return
        }
        for courseTitle in contentsInCoursesDirectory {
            let courseDirectoryURL = coursesDirectoryURL.appendingPathComponent(courseTitle)
            guard let contentsInCourseDirectory = try? FileManager.default.contentsOfDirectory(atPath: courseDirectoryURL.path) else {
                self.courses = []
                return
            }
            var sections = [Section]()
            for contentInCourseDirectory in contentsInCourseDirectory {
                var sectionData: SectionData?
                var lessons = [Lesson]()
                let sectionDirectoryURL = courseDirectoryURL.appendingPathComponent(contentInCourseDirectory)
                guard let contentsInSectionDirectory = try? FileManager.default.contentsOfDirectory(atPath: sectionDirectoryURL.path) else {
                    self.courses = []
                    return
                }
                for contentInSectionDirectory in contentsInSectionDirectory {
                    if contentInSectionDirectory == "data.json", let data = try? Data(contentsOf: sectionDirectoryURL.appendingPathComponent(contentInSectionDirectory)) {
                        sectionData = try? JSONDecoder().decode(SectionData.self, from: data)
                    } else {
                        let userDirectoryURL = documentURL.appendingPathComponent(courseTitle).appendingPathComponent(contentInCourseDirectory).appendingPathComponent(contentInSectionDirectory)
                        if !FileManager.default.fileExists(atPath: userDirectoryURL.path) {
                            do {
                                try FileManager.default.createDirectory(at: userDirectoryURL, withIntermediateDirectories: true, attributes: nil)
                            } catch {
                                Application.printErrorLog(error.localizedDescription)
                            }
                        }
                        let previewDirectoryURL = userDirectoryURL.appendingPathComponent("preview")
                        if !FileManager.default.fileExists(atPath: previewDirectoryURL.path) {
                            do {
                                try FileManager.default.createDirectory(at: previewDirectoryURL, withIntermediateDirectories: true, attributes: nil)
                            } catch {
                                Application.printErrorLog(error.localizedDescription)
                            }
                        }
                        let answerDirectoryURL = userDirectoryURL.appendingPathComponent("answer")
                        if !FileManager.default.fileExists(atPath: answerDirectoryURL.path) {
                            do {
                                try FileManager.default.createDirectory(at: answerDirectoryURL, withIntermediateDirectories: true, attributes: nil)
                            } catch {
                                Application.printErrorLog(error.localizedDescription)
                            }
                        }
                        let lessonDirectoryURL = sectionDirectoryURL.appendingPathComponent(contentInSectionDirectory)
                        guard let contentsInLessonDirectory = try? FileManager.default.contentsOfDirectory(atPath: lessonDirectoryURL.path) else {
                            self.courses = []
                            return
                        }
                        var files = [File]()
                        var slides = [Slide]()
                        var descriptions = [Description]()
                        for contentInLessonDirectory in contentsInLessonDirectory {
                            let folderURL = lessonDirectoryURL.appendingPathComponent(contentInLessonDirectory)
                            guard let contentTitles = try? FileManager.default.contentsOfDirectory(atPath: folderURL.path) else {
                                self.courses = []
                                return
                            }
                            if contentInLessonDirectory == "files" {
                                for fileTitle in contentTitles {
                                    let fileURL = folderURL.appendingPathComponent(fileTitle)
                                    guard let text = try? String(contentsOf: fileURL) else {
                                        self.courses = []
                                        return
                                    }
                                    let answerFileURL = answerDirectoryURL.appendingPathComponent(fileTitle)
                                    files.append(File(title: fileTitle, text: text, url: fileURL, userURL: userDirectoryURL.appendingPathComponent(fileTitle), previewURL: previewDirectoryURL.appendingPathComponent(fileTitle), answerURL: answerFileURL))
                                }
                            } else if contentInLessonDirectory == "slides" {
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
                            } else if contentInLessonDirectory == "descriptions" {
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
                            title: contentInSectionDirectory,
                            files: files,
                            slides: slides,
                            descriptios: descriptions
                        ))
                    }
                    
                }
                guard sectionData != nil else {
                    continue
                }
                sections.append(Section(title: sectionData!.title, content: sectionData!.content, skills: sectionData!.skills, lessons: lessons))
            }
            guard let language = ProgramingLanguage(rawValue: courseTitle) else {
                self.courses = []
                return
            }
            courses.append(Course(language: language, title: courseTitle, sections: sections))
        }
        self.courses = courses
    }
    
}
