

import UIKit


class SearchViewController: BaseViewController {
    private weak var searchBar: UISearchBar?
    private weak var tableView: UITableView?
    lazy var searchViewModel: SearchViewModel = SearchViewModelImpl(controller: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        searchViewModel.viewDidLoad()
    }
    
    //MARK: - Custom methods
    override func endEditing () {
        self.searchBar?.resignFirstResponder()
    }
    
    private func setupView() {
        self.view.backgroundColor = UIColor.systemBackground
        
        // Add searchBar
        let searchBar = UISearchBar()
        self.searchBar = searchBar
        searchBar.placeholder = "Search"
        searchBar.showsScopeBar = true
        searchBar.barTintColor = UIColor.gray
        searchBar.scopeButtonTitles = SearchType.allCases.map({$0.segmentTitle})
        searchBar.delegate = self
        searchBar.backgroundColor = UIColor.systemBackground
        UISegmentedControl.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .red
        self.navigationItem.titleView = searchBar
        
        //Add tableView
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        self.tableView = tableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor).isActive = true
        
        tableView.setupTableView(
            delegate: self,
            dataSource: self,
            cellsIdentifiers: [SearchResultTableViewCell.reuseIdentifier])
        
    }
    
    @objc private func searchTextDidChange() {
        searchViewModel.searchTextDidChange(with: searchBar?.text)
    }
}

//MARK: - SearchViewModelDelegate
extension SearchViewController: SearchViewModelDelegate {
    func setError(message: String?) {
        guard let message = message else {
            self.tableView?.dataStateDidChanged(.filled)
            return
        }
        
        self.tableView?.dataStateDidChanged(.message(message))
    }
    
    func startLoading() {
        self.tableView?.dataStateDidChanged(.loading)
    }
    
    func reloadSearchResult() {
        tableView?.reloadData()
    }
}

//MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchViewModel.countViewModels
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = self.searchViewModel.viewModel(for: indexPath.row) else {
            return UITableViewCell()
        }
        let cell: SearchResultTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.titleLabel.text = model.title
        cell.subTitleLabel.text = model.subTitle
        cell.setupImage(imageURL: model.imageURL)
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        guard let newType = SearchType(rawValue: selectedScope) else { return }
        
        searchViewModel.didChangeSearchType(newType)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(
            withTarget: self,
            selector: #selector(searchTextDidChange),
            object: nil)
        
        self.perform(#selector(searchTextDidChange), with: nil, afterDelay: 0.5)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchViewModel.searchTextDidChange(with: searchBar.text)
        self.searchBar?.resignFirstResponder()
    }
}
