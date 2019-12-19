

import Foundation

class ITunesSearchService: SearchService {
    func startSearch(result: String, completion: @escaping ([SearchResultViewModel]?, Error?) -> ()) {
        let searchStr = result.lowercased()
        let result = ItunesSearchAPIRouter.search(searchStr)
        
        let completion: (ItunesSearchResult?, Error?) -> () = { result, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            let results = result?.results.map({
                SearchResultViewModel(
                    imageURL: $0.artworkUrl100,
                    title: $0.artistName,
                    subTitle: $0.wrapperType)
            })
            completion(results ?? [], nil)
        }
        
        APIClient.request(route: result, completion: completion)
    }
}
