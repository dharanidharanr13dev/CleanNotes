
import Foundation
import UIKit


public struct NotePresentationModel {
    public let id: String
    public let attributedTitle: NSAttributedString
    public let detailText: NSAttributedString
    public let createdDate: String

    public init(todo: TodoModel) {
        self.id = todo.id

        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 17)
        ]
        self.attributedTitle = NSAttributedString(string: todo.title, attributes: titleAttributes)
        
        let contentAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.secondaryLabel
        ]
        self.detailText = NSAttributedString(string: todo.detail, attributes: contentAttributes)
        
        self.createdDate = todo.createdDate.isoToFormatted() ?? ""
    }
}
