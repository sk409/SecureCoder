import Foundation

struct URLTask {
    
    struct Result {
        let data: Data?
        let response: URLResponse?
        let error: Error?
    }
    
    static func sync(url: URL, method: HTTPMethod, queryItems: [URLQueryItem]?) -> Result {
        let semaphore = DispatchSemaphore(value: 0)
        var result: Result!
        async(url: url, method: method, queryItems: queryItems) { data, response, error in
            result = Result(data: data, response: response, error: error)
            semaphore.signal()
        }
        semaphore.wait()
        return result
    }
    
    static func async(url: URL, method: HTTPMethod, queryItems: [URLQueryItem]?) {
        async(url: url, method: method, queryItems: queryItems) { _, _, _ in }
    }
    
    static func async(url: URL, method: HTTPMethod, queryItems: [URLQueryItem]?, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        if let queryItems = queryItems {
            guard let urlRequest = makeURLRequest(with: url, method: method, queryItems: queryItems) else {
                completionHandler(nil, nil, nil)
                return
            }
            URLSession.shared.dataTask(with: urlRequest, completionHandler: completionHandler).resume()
        } else {
            URLSession.shared.dataTask(with: url, completionHandler: completionHandler).resume()
        }
    }
    
    private static func makeURLRequest(with url: URL, method: HTTPMethod, queryItems: [URLQueryItem]) -> URLRequest? {
        var urlComponents = URLComponents(string: url.absoluteString)
        urlComponents?.queryItems = queryItems
        switch method {
        case .get:
            if let url = urlComponents?.url {
                return URLRequest(url: url)
            }
        case .post:
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = urlComponents?.query?.data(using: .utf8)
            return urlRequest
        }
        return nil
    }
    
}
