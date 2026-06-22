
import Foundation


protocol NoteDetailViewModelContract: AnyObject {
    var stateDidChange: ((NoteDetailViewState) -> Void)? { get set }
    func saveNote(note: Note)
    func deleteNote(id: String)
    func didSaveNote()
    func didCancelEditing()
    func didTapBack(title: String, detail: String, existingNote: Note?, createdDate: Date?)
}
