
import Foundation


protocol NoteDetailViewModelContract {
    func saveNote(note: NoteModel)
    func deleteNote(id: String)
    func loadNoteListPage()
    func popToNoteListPage()
}
