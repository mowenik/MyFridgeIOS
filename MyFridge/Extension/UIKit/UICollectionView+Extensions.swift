import UIKit

extension UICollectionViewCell {
    
    static var reuseID: String {
        return String(describing: self)
    }
    
}

extension UICollectionView {
    
    func register(cellReuseID reuseID: String) {
        let nib = UINib(nibName: reuseID, bundle: nil)
        register(nib, forCellWithReuseIdentifier: reuseID)
    }
    
}
