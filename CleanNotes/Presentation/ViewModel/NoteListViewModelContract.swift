
import Foundation


protocol NoteListViewModelContract: AnyObject {
    var stateDidChange: ((NoteListViewState) -> Void)? { get set }
    func getNotes()
    func searchNotes(_ text: String)
    func didSelectRow(at index: Int)
    func didTapAddNote()
}
