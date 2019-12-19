

import Foundation

protocol SearchViewModelDelegate: class {
    func setError(message: String?)
    func startLoading()
    func reloadSearchResult()
}

protocol SearchViewModel {
    var countViewModels: Int { get }
    
    func viewDidLoad()
    func didChangeSearchType(_ searchType: SearchType)
    func viewModel(for index: Int) -> SearchResultViewModel?
    func searchTextDidChange(with text: String?)
}


enum SearchType: Int, CaseIterable {
    case itunes
    case lastFM
    
    var segmentTitle: String {
        switch self {
        case .itunes:
            return "iTunes"
        case .lastFM:
            return "Last.fm"
        }
    }
    
    var searchService: SearchService {
        switch self {
        case .itunes:
            return ITunesSearchService()
        case .lastFM:
            return LastFMSearchService()
        }
    }
}
