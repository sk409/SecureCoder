import Foundation

struct CoderManager {
    
    static var shared = CoderManager()
    
    static private let isUserLogedInKey = "SecureCoder.IsUserLogedIn"
    static private let coderNameKey = "SecureCoder.CoderName"
    static private let coderPasswordKey = "SecureCoder.CoderPassword"
    
    
    var relativeCoderDirectoryURLString: String? {
        guard isLogedIn() else {
            return nil
        }
        guard let coderName = self.coderName else {
            return nil
        }
        return "./Coder/" + coderName + "/"
    }
    var absoluteCoderDirectoryURLString: String? {
        guard isLogedIn() else {
            return nil
        }
        guard let coderName = self.coderName else {
            return nil
        }
        return Application.webServerRootURLString + "Coder/" + coderName + "/"
    }
    
    private(set) var coderName: String?
    private(set) var coderPassword: String?
    
    
    func isLogedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: CoderManager.isUserLogedInKey)
    }
    
    func isExisting(coderName: String, coderPassword: String) -> Bool {
        let result = DatabaseSession.sync(with: "CheckExistenceCoder.php", parameters: ["coder_name": coderName, "coder_password": coderPassword], method: .get)
        return (result == ServerResponse.true)
    }
    
    func signUp(coderName: String, coderPassword: String) -> Bool {
        let result = DatabaseSession.sync(with: "SignUp.php", parameters: ["coder_name": coderName, "coder_password": coderPassword], method: .post)
        return result == ServerResponse.succeeded
    }
    
    mutating func logIn(coderName: String, coderPassword: String) -> Bool {
        guard isExisting(coderName: coderName, coderPassword: coderPassword) else {
            return false
        }
        guard !isLogedIn() else {
            return false
        }
        self.coderName = coderName
        self.coderPassword = coderPassword
        UserDefaults.standard.set(true, forKey: CoderManager.isUserLogedInKey)
        UserDefaults.standard.set(coderName, forKey: CoderManager.coderNameKey)
        UserDefaults.standard.set(coderPassword, forKey: CoderManager.coderPasswordKey)
        return true
    }
    
    mutating func logOut(coderName: String, coderPassword: String) -> Bool {
        guard isExisting(coderName: coderName, coderPassword: coderPassword) else {
            return false
        }
        guard isLogedIn() else {
            return false
        }
        self.coderName = nil
        self.coderPassword = nil
        UserDefaults.standard.set(false, forKey: CoderManager.isUserLogedInKey)
        UserDefaults.standard.set("", forKey: CoderManager.coderNameKey)
        UserDefaults.standard.set("", forKey: CoderManager.coderPasswordKey)
        return true
    }
    
    private init() {
        guard isLogedIn() else {
            return
        }
        coderName = UserDefaults.standard.string(forKey: CoderManager.coderNameKey)
        coderPassword = UserDefaults.standard.string(forKey: CoderManager.coderPasswordKey)
    }
    
}
