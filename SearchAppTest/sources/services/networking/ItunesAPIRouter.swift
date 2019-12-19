

import Foundation

/// This enum configure server API request for Itunes
enum ItunesSearchAPIRouter: URLRequestConvertible {
    case search(String)
    
    var baseURL: String {
        return "https://itunes.apple.com"
    }
    
    // MARK: - HTTPMethod
    var methot: HTTPMethod {
        switch self {
        case .search:       return .get
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
        case .search:       return "/search"
        }
    }
    
    // MARK: - Headers
    var headers: [String: String]? {
        return ["Content-Type" : "application/json"]
    }
    
    // MARK: - Parameters
    var parameters: [String: Any]? {
        switch self {
        case .search(let searchRequest): return ["term" : searchRequest]
        }
    }
}

