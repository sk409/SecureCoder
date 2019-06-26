import Foundation

struct URLUtils {
    
    static func make(_ components: [String]) -> URL? {
        var urlString = ""
        components.forEach { component in
            urlString += component
            if !component.hasSuffix("/") {
                urlString += "/"
            }
        }
        guard let percentEncodedURULString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        return URL(string: percentEncodedURULString)
    }
    
}
