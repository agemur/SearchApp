

import Foundation


extension SearchViewModelImpl: SearchViewModel {
    func viewDidLoad() {
        self.controller?.setError(message: "Enter your search query")
    }
    
    var countViewModels: Int { return viewModels.count }
    
    func viewModel(for index: Int) -> SearchResultViewModel? {
        guard viewModels.count > index else { return nil }
        return viewModels[index]
    }
    
    func didChangeSearchType(_ searchType: SearchType) {
        guard searchType != self.searchType else { return }
        self.searchType = searchType
        currentSearchService = searchType.searchService
        updateData()
    }
}
    
class SearchViewModelImpl {
    var viewModels: [SearchResultViewModel] = []
    var currentSearchService: SearchService
    var searchType: SearchType
    var lastSearchText: String = ""
    
    weak var controller: SearchViewModelDelegate?
    
    init(controller: SearchViewModelDelegate? = nil) {
        self.controller = controller
        
        self.searchType = .itunes
        self.currentSearchService = searchType.searchService
    }
    
    func searchTextDidChange(with text: String?) {
        self.lastSearchText = text ?? ""
        updateData()
    }
    
    private func updateData () {
        self.viewModels = []
        self.controller?.reloadSearchResult()
        
        guard self.lastSearchText != "" else {
            self.controller?.setError(message: "Enter your search query")
            return
        }
        self.controller?.startLoading()
        
        currentSearchService.startSearch(
            result: self.lastSearchText
        ) { [weak self] (result, error) in
            self?.reloadTable(models: result, error: error)
        }
    }
 
    private func reloadTable(models: [SearchResultViewModel]?, error: Error?) {
        DispatchQueue.main.async {
            if let models = models {
                self.controller?.setError(message: models.count > 0 ? nil : "Not found")
                self.viewModels = models
                self.controller?.reloadSearchResult()
            } else if let error = error {
                self.controller?.setError(message: error.localizedDescription)
            } else {
                self.controller?.setError(message: "Undefined error")
            }
        }
    }
}
