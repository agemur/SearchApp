

import Foundation

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case patch = "PATCH"
}

protocol URLRequestConvertible {
    var baseURL: String { get }
    
    var path: String { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
    var methot: HTTPMethod { get }
    
    func request(url: URL) -> URLRequest?
}

    
extension URLRequestConvertible {
    func request(url: URL) -> URLRequest? {
        guard let params = parameters else {
            var request = URLRequest(url: url)
            request.httpMethod = self.methot.rawValue
            return request
        }
        
        switch methot {
        case .post, .patch:
            guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
                return nil
            }
            var request = URLRequest(url: url)
            request.httpMethod = self.methot.rawValue
            request.httpBody = httpBody
            return addHeaders(request: request)
        case .get:
            guard let params = params as? [String: String] else {
                return nil
            }
            var components = URLComponents(string: url.absoluteString)!
            components.queryItems = params.map { (arg) -> URLQueryItem in
                let (key, value) = arg
                return URLQueryItem(name: key, value: value)
            }
            components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
            let request = URLRequest(url: components.url!)
            
            return addHeaders(request: request)
        }
    }
    
    private func addHeaders(request: URLRequest) -> URLRequest {
        var request = request
        if let headers = headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        return request
    }

}

