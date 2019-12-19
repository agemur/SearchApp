

import Foundation

class LastFMSearchService: SearchService {

    func startSearch(result: String, completion: @escaping ([SearchResultViewModel]?, Error?) -> ()) {
        
        let result = LastFMSearchAPIRouter.searchArtist(result)
        
        let completion: (LastFMSearchRoot?, Error?) -> () = { result, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            let results = result?.results.artistmatches.artist.map({
                SearchResultViewModel(
                    imageURL: $0.smallImageURL,
                    title: $0.name,
                    subTitle: "artist")
            })
            completion(results ?? [], nil)
        }
        
        APIClient.request(route: result, completion: completion)
    }
    
    
}
