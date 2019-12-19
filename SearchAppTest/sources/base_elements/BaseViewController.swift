

import UIKit

class BaseViewController: UIViewController {
    @IBInspectable private var canEndEditingByTap: Bool = true
    private var endEditingTapGestoreRecognizer: UITapGestureRecognizer?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateEndEditingState()
    }
    
    @objc func endEditing() {
        view.endEditing(true)
    }
    
    private func updateEndEditingState() {
        if canEndEditingByTap {
            endEditingTapGestoreRecognizer = UITapGestureRecognizer(target: self, action: #selector(endEditing))
            endEditingTapGestoreRecognizer?.cancelsTouchesInView = false
            view.addGestureRecognizer(endEditingTapGestoreRecognizer!)
        } else {
            guard let tapGestore = endEditingTapGestoreRecognizer else { return }
            view.removeGestureRecognizer(tapGestore)
        }
    }

}
