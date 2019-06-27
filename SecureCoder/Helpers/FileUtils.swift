import Foundation

struct FileUtils {
    
    static func makeDirectory(url: URL) {
        if url.scheme == "http" && url.host == "localhost" {
            if let scriptURL = URL(string: "http://localhost/make_directory.php") {
                let urlString = url.absoluteString
                let queryItems = [URLQueryItem(name: "path", value: urlString.replacingOccurrences(of: "http://localhost(:80)?/", with: "", options: .regularExpression, range: urlString.range(of: urlString)))]
                let _ = URLTask.sync(url: scriptURL, method: .post, queryItems: queryItems)
            }
        } else {
            if !FileManager.default.fileExists(atPath: url.path) {
                do {
                    try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    Application.printErrorLog(error.localizedDescription)
                }
            }
        }
    }
    
    static func makeDirectories(urls: [URL]) {
        urls.forEach { makeDirectory(url: $0) }
    }
    
    static func makeFiles(urls: [URL], texts: [String]) {
        guard urls.count == texts.count else {
            return
        }
        for (index, url) in urls.enumerated() {
            makeFile(url: url, text: texts[index])
        }
    }
    
    static func makeFile(url: URL, text: String) {
        if url.scheme == "http" && url.host == "localhost" {
            if let scriptURL = URL(string: "http://localhost/make_file.php") {
                let fileURLString = url.absoluteString.replacingOccurrences(of: "http://localhost(:80)?/", with: "", options: .regularExpression, range: url.absoluteString.range(of: url.absoluteString))
                let queryItems = [URLQueryItem(name: "path", value: fileURLString), URLQueryItem(name: "text", value: text)]
                let _ = URLTask.sync(url: scriptURL, method: .post, queryItems: queryItems)
            }
        } else {
            if !FileManager.default.fileExists(atPath: url.path) {
                do {
                    try text.write(to: url, atomically: true, encoding: .utf8)
                } catch {
                    Application.printErrorLog(error.localizedDescription)
                }
            }
        }
    }
    
    static func deleteFile(url: URL) {
        if url.scheme == "http" && url.host == "localhost" {
            if let scriptURL = URL(string: "http://localhost/delete_file.php") {
                let fileURLString = url.absoluteString.replacingOccurrences(of: "http://localhost(:80)?/", with: "", options: .regularExpression, range: url.absoluteString.range(of: url.absoluteString))
                let queryItems = [URLQueryItem(name: "path", value: fileURLString)]
                let _ = URLTask.sync(url: scriptURL, method: .post, queryItems: queryItems)
            }
        } else {
            if FileManager.default.fileExists(atPath: url.path) {
                do {
                    try FileManager.default.removeItem(at: url)
                } catch {
                    Application.printErrorLog(error.localizedDescription)
                }
            }
        }
    }
    
    static func saveFile(url: URL, text: String) {
        if url.scheme == "http" && url.host == "localhost" {
            if let scriptURL = URL(string: "http://localhost/save_file.php") {
                let fileURLString = url.absoluteString.replacingOccurrences(of: "http://localhost(:80)?/", with: "", options: .regularExpression, range: url.absoluteString.range(of: url.absoluteString))
                let queryItems = [URLQueryItem(name: "path", value: fileURLString), URLQueryItem(name: "text", value: text)]
                let _ = URLTask.sync(url: scriptURL, method: .post, queryItems: queryItems)
            }
        } else {
            if FileManager.default.fileExists(atPath: url.path) {
                do {
                   try text.write(to: url, atomically: true, encoding: .utf8)
                } catch {
                    Application.printErrorLog(error.localizedDescription)
                }
            }
        }
    }
    
}
