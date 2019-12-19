

import UIKit

class SearchResultTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var activityLoad: UIActivityIndicatorView!
    
    private var imageURL: URL?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.layer.cornerRadius = iconImageView.frame.width / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        guard let url = imageURL else {
            return
        }
        RequestRepository.imageDownload.cancelRequest(by: url)
        iconImageView.image = nil
    }

    func setupImage(imageURL: URL?) {
        if let url = imageURL {
            iconImageView.image = nil
            activityLoad.isHidden = false
            activityLoad.startAnimating()
            
            let request = iconImageView.download(
                from: url,
                contentMode: .scaleAspectFill
            ) {[weak self] (isSuccess) in
                self?.activityLoad.stopAnimating()
                guard !isSuccess else { return }
                self?.iconImageView.image = UIImage(named: "placeholder")
            }
            self.imageURL = url
            RequestRepository.imageDownload.addRequest(request, for: url)
        } else {
            self.activityLoad.stopAnimating()
            self.iconImageView.image = UIImage(named: "placeholder")
        }
    }
    
}
