import Foundation

struct CoderManager {
    
    static var shared = CoderManager()
    
    static private let isUserLogedInKey = "SecureCoder.IsUserLogedIn"
    static private let coderNameKey = "SecureCoder.CoderName"
    static private let coderPasswordKey = "SecureCoder.CoderPassword"
    
    private(set) var coderName: String?
    private(set) var coderPassword: String?
    
    
    func isLogedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: CoderManager.isUserLogedInKey)
    }
    
    func isExisting(coderName: String, coderPassword: String) -> Bool {
        let result = DatabaseSession.sync(with: "CheckExistenceCoder.php", parameters: ["coder_name": coderName, "coder_password": coderPassword], method: .get)
        return (result == ServerResponse.true)
    }
    
    func signUp(coderName: String, coderPassword: String) {
        let result = DatabaseSession.sync(with: "SignUp.php", parameters: ["coder_name": coderName, "coder_password": coderPassword], method: .post)
        guard result == ServerResponse.succeeded else {
            return
        }
        makeCorderDirecotries()
    }
    
    mutating func logIn(coderName: String, coderPassword: String) {
        guard isExisting(coderName: coderName, coderPassword: coderPassword) else {
            return
        }
        guard !isLogedIn() else {
            return
        }
        self.coderName = coderName
        self.coderPassword = coderPassword
        UserDefaults.standard.set(true, forKey: CoderManager.isUserLogedInKey)
        UserDefaults.standard.set(coderName, forKey: CoderManager.coderNameKey)
        UserDefaults.standard.set(coderPassword, forKey: CoderManager.coderPasswordKey)
    }
    
    mutating func logOut(coderName: String, coderPassword: String) {
        guard isExisting(coderName: coderName, coderPassword: coderPassword) else {
            return
        }
        guard isLogedIn() else {
            return
        }
        self.coderName = nil
        self.coderPassword = nil
        UserDefaults.standard.set(false, forKey: CoderManager.isUserLogedInKey)
        UserDefaults.standard.set("", forKey: CoderManager.coderNameKey)
        UserDefaults.standard.set("", forKey: CoderManager.coderPasswordKey)
    }
    
    private init() {
        guard isLogedIn() else {
            return
        }
        coderName = UserDefaults.standard.string(forKey: CoderManager.coderNameKey)
        coderPassword = UserDefaults.standard.string(forKey: CoderManager.coderPasswordKey)
    }
    
    private func makeCorderDirecotries() {
        guard let coderName = self.coderName else {
            return
        }
        for lessonType in LessonType.allCases {
            guard let sections = Lesson.sections(type: lessonType) else {
                return
            }
            for section in sections {
                guard let titles = Lesson.titles(type: lessonType, section: section) else {
                    return
                }
                for title in titles {
                    let relativeCoderDirectoryURLString = Lesson.relativeCoderDirectoryURLString(type: lessonType, section: section, title: title) + coderName
                    let makingDirectoryResult = DatabaseSession.sync(with: "MakeDirectory.php", parameters: ["path": relativeCoderDirectoryURLString], method: .post)
                    guard makingDirectoryResult == ServerResponse.succeeded else {
                        Application.shared.writeErrorLog(makingDirectoryResult)
                        return
                    }
                    let srcDirectoryURLString = Lesson.relativeDefaultDirectoryURLString(type: lessonType, section: section, title: title)
                    let dstDirectoryURLString = Lesson.relativeCoderDirectoryURLString(type: lessonType, section: section, title: title) + coderName + "/"
                    let fileNamesString = DatabaseSession.sync(with: "LoadFileNames.php", parameters: ["directory_path": srcDirectoryURLString], method: .get)
                    guard let fileNamesArray = fileNamesString.toArray() else {
                        return
                    }
                    for fileName in fileNamesArray {
                        let text = DatabaseSession.sync(with: "ReadFile.php", parameters: ["path": srcDirectoryURLString + fileName], method: .get)
                        let savingFileResult = DatabaseSession.sync(with: "SaveFile.php", parameters: ["path": dstDirectoryURLString + fileName, "data": text], method: .post)
                        guard savingFileResult == ServerResponse.succeeded else {
                            Application.shared.writeErrorLog(savingFileResult)
                            return
                        }
                    }
                }
            }
        }
    }
    
}
