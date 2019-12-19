
import Foundation

struct SearchResultViewModel {
    var imageURL: URL?
    var title: String
    var subTitle: String
}

protocol SearchService {
    func startSearch(result: String, completion: @escaping ([SearchResultViewModel]?, Error?)->())
}
