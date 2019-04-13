import Foundation

struct DatabaseSession {
    
    static func sync(with fileURL: String, parameters: [String: String], method: HTTPMethod) -> String {
        var result = ""
        let urlString = Application.webServerRootURLString + fileURL
        let semaphore = DispatchSemaphore(value: 0)
        async(with: urlString, parameters: parameters, method: method) { data, urlResponse, error in
            defer {
                semaphore.signal()
            }
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            guard let text = String(data: data, encoding: .utf8) else {
                return
            }
            result = text
        }
        semaphore.wait()
        return result
    }
    
    static func async(with urlString: String, parameters: [String: String], method: HTTPMethod) {
        async(with: urlString, parameters: parameters, method: method) { _, _, _ in }
    }
    
    static func async(with urlString: String, parameters: [String: String], method: HTTPMethod, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let request = makeURLRequest(urlString: urlString, parameters: parameters, method: method) else {
            return
        }
        let dataTask = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
        dataTask.resume()
    }
    
    private static func makeURLRequest(urlString: String, parameters: [String: String], method: HTTPMethod) -> URLRequest? {
        guard var urlComponents = URLComponents(string: urlString) else {
            return nil
        }
        urlComponents.queryItems = parameters.map { URLQueryItem(name: $0, value: $1)}
        switch method {
        case .get:
            guard let url = urlComponents.url else {
                return nil
            }
            return URLRequest(url: url)
        case .post:
            guard let url = URL(string: urlString) else {
                return nil
            }
            guard let query = urlComponents.query else {
                return nil
            }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = query.data(using: .utf8)
            return request
        }
    }
    
}
