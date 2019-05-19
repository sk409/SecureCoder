import Foundation

struct DatabaseSession {
    
    static func sync(with fileName: String, parameters: [String: String], method: HTTPMethod) -> String {
        var result = ""
        let semaphore = DispatchSemaphore(value: 0)
        async(with: fileName, parameters: parameters, method: method) { data, urlResponse, error in
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
    
    static func sync(with fileName: String, query: URLQueryObject, method: HTTPMethod) -> String {
        var result = ""
        let semaphore = DispatchSemaphore(value: 0)
        async(with: fileName, query: query, method: method) { data, urlResponse, error in
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
    
    
    static func async(with fileName: String, query: URLQueryObject, method: HTTPMethod) {
        async(with: fileName, query: query, method: method) { _, _, _ in }
    }
    
    static func async(with fileName: String, query: URLQueryObject, method: HTTPMethod, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let urlString = Application.webServerRootURLString + fileName
        guard let request = makeURLRequest(urlString: urlString, query: query, method: method) else {
            return
        }
        let dataTask = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
        dataTask.resume()
    }
    
    static func async(with fileName: String, parameters: [String: String], method: HTTPMethod) {
        async(with: fileName, parameters: parameters, method: method) { _, _, _ in }
    }
    
    static func async(with fileName: String, parameters: [String: String], method: HTTPMethod, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let urlString = Application.webServerRootURLString + fileName
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
    
    private static func makeURLRequest(urlString: String, query: URLQueryObject, method: HTTPMethod) -> URLRequest? {
        guard var urlComponents = URLComponents(string: urlString) else {
            return nil
        }
        urlComponents.queryItems = query.items
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
