
import Foundation
import UIKit


public struct NotePresentationModel {
    public let id: String
    public let attributedTitle: NSAttributedString
    public let detailText: NSAttributedString
    public let createdDate: String

    public init(note: NoteModel) {
        self.id = note.id

        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 17)
        ]
        self.attributedTitle = NSAttributedString(string: note.title, attributes: titleAttributes)
        
        let contentAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.secondaryLabel
        ]
        self.detailText = NSAttributedString(string: note.detail, attributes: contentAttributes)
        
        
        
        self.createdDate = note.createdDate.isoToFormatted() ?? ""
    }
}
