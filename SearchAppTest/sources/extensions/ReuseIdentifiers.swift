

import UIKit


protocol ReuseIdentifierProtocol {
    static var reuseIdentifier: String { get }
}

extension UITableViewCell: ReuseIdentifierProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
