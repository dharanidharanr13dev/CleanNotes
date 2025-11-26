
import Foundation
import UIKit


extension UITableView {
    
    func registerNib<T: UITableViewCell>(_ cellType: T.Type) {
        let nib = UINib(nibName: String(describing: cellType), bundle: nil)
        register(nib, forCellReuseIdentifier: String(describing: cellType))
    }
    
    func register<T: UITableViewCell>(_ cellType: T.Type) {
        self.register(cellType, forCellReuseIdentifier: String(describing: cellType))
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(String(describing: T.self))")
        }
        return cell
    }
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textAlignment = .center
        messageLabel.textColor = .gray
        messageLabel.font = .systemFont(ofSize: 16)
        messageLabel.numberOfLines = 0
        backgroundView = messageLabel
        separatorStyle = .none
    }
    
    func restore() {
        backgroundView = nil
    }
}
