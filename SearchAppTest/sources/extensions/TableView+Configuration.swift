
import UIKit


enum TableViewSize {
    case automatic
    case custom(headerHeight: CGFloat, rowHeight: CGFloat, footerHeight: CGFloat)
}

enum DataRepositoryState {
    case filled
    case message(String)
    case loading
}

//Extension for empty state
extension UITableView {
    func dataStateDidChanged(_ state: DataRepositoryState) {
        switch state {
        case .message(let message):
            let label = UILabel(frame: self.bounds)
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.font = UIFont.systemFont(ofSize: 18)
            label.text = message
            label.textAlignment = .center
            label.textColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
            self.backgroundView = label
        case .filled:
            self.backgroundView = nil
        case .loading:
            let activity = UIActivityIndicatorView.init(style: .large)
            activity.tintColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
            activity.startAnimating()
            self.backgroundView = activity
        }
    }
}

extension UITableView {
    func setupTableView(
        size: TableViewSize = .automatic,
        delegate: UITableViewDelegate? = nil,
        dataSource: UITableViewDataSource? = nil,
        cellsIdentifiers: [String] = [],
        allowSelection: Bool = true) {
        
        registerViews(cellsIdentifiers: cellsIdentifiers)
        self.allowsSelection = allowSelection

        self.delegate = delegate
        self.dataSource = dataSource

        switch size {
        case .automatic:
            self.sectionHeaderHeight = UITableView.automaticDimension
            self.estimatedSectionHeaderHeight = UITableView.automaticDimension
            self.rowHeight = UITableView.automaticDimension
            self.estimatedRowHeight = UITableView.automaticDimension
            self.sectionFooterHeight = UITableView.automaticDimension
            self.estimatedSectionFooterHeight = UITableView.automaticDimension
        case .custom(let headerHeight, let rowHeight, let footerHeight):
            self.sectionHeaderHeight = headerHeight
            self.estimatedSectionHeaderHeight = 22
            self.rowHeight = rowHeight
            self.estimatedRowHeight = 44
            self.sectionFooterHeight = footerHeight
            self.estimatedSectionFooterHeight = 22
        }
    }

    private func registerViews(cellsIdentifiers: [String]) {
        for identifier in cellsIdentifiers {
            let cell = UINib(nibName: identifier, bundle: nil)
            self.register(cell, forCellReuseIdentifier: identifier)
        }
    }
}


extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to Dequeue Reusable Table View Cell")
        }
        return cell
    }
}
