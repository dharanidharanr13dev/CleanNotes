
import Foundation


protocol NoteListViewModelContract {
    func getNotes()
    func refreshNotes()
    func showNoteDetail(_ note: Note?)
    func searchNotes(_ text: String)
}
