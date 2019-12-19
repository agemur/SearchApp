

import Foundation


/// This enum configure server API request for LastFM
enum LastFMSearchAPIRouter: URLRequestConvertible {
    
    case searchArtist(String)
    
    var baseURL: String {
        return "http://ws.audioscrobbler.com/2.0"
    }
    
    // MARK: - HTTPMethod
    var methot: HTTPMethod {
        switch self {
        case .searchArtist:       return .get
        }
    }
    
    // MARK: - Path
    var path: String {
        return ""
    }
    
    // MARK: - Headers
    var headers: [String: String]? {
        return ["Content-Type" : "application/json"]
    }
    
    // MARK: - Parameters
    var parameters: [String: Any]? {
        var params = [ "format" : "json",
                       "api_key" : LastFMConstatnts.API_KEY]
        
        switch self {
        case .searchArtist(let searchRequest):
            params["method"] = "artist.search"
            params["artist"] = searchRequest
            return params
        }
    }
}
