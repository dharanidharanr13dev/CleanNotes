
import Foundation


protocol NoteListViewModelContract {
    func getNotes()
    func refreshNotes()
    func showNoteDetail(_ note: NoteModel?)
    func searchNotes(_ text: String)
}
