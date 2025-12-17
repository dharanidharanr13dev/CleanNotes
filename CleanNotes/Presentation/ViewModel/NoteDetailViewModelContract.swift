
import Foundation


protocol NoteDetailViewModelContract {
    func saveNote(note: Note)
    func deleteNote(id: String)
    func loadNoteListPage()
    func popToNoteListPage()
}
