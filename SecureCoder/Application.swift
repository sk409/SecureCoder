import Foundation

struct Application {
    
    static var shared = Application()
    static let webServerRootURLString = "http://localhost:80/"
    
    func initialize() {
//        CoderManager.shared.signUp(coderName: "TestCoder", coderPassword: "TestCoder")
//        makeDatabase(name: "TestCoder")
    }
    
    func makeDatabase(name: String) -> Bool {
        let result = DatabaseSession.sync(with: "MakeDatabase.php", parameters: ["database_name": name], method: .post)
        return result == ServerResponse.succeeded
    }
    
    func writeErrorLog(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        print("|----ERROR----|")
        print("|", file, ": ", function, "(", line, ")")
        print("|", message)
        print("|----ERROR----|")
    }
    
    private init() {}
    
}
