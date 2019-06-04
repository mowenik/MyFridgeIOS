import UIKit

extension UITableViewCell {
    
    static var reuseID: String {
        return String(describing: self)
    }
    
}

extension UITableView {
    
    func register(cellReuseID reuseID: String) {
        let nib = UINib(nibName: reuseID, bundle: nil)
        register(nib, forCellReuseIdentifier: reuseID)
    }
    
}
