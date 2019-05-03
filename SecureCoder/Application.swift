import Foundation

struct Application {
    
    static var shared = Application()
    static let webServerRootURLString = "http://localhost:80/"
    
    func initialize() {
        CoderManager.shared.logIn(coderName: "TestCoder", coderPassword: "TestCoder")
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
