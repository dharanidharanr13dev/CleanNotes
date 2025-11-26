
import Foundation


public protocol NoteDetailViewControllerContract: AnyObject {
    func showError(_ message: String)
    func showSuccessToast(_ message: String)
}
