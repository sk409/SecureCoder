import UIKit

class DescriptionImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var descriptionImageView: UIImageView!
    
    func setImage(_ image: UIImage) {
        descriptionImageView.image = image
    }
    
}
