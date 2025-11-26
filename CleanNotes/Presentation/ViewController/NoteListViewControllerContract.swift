
import Foundation


public protocol NoteListViewControllerContract: AnyObject {
    func loadNotes(_ notes: [NotePresentationModel])
    func showError(_ message: String)
}
