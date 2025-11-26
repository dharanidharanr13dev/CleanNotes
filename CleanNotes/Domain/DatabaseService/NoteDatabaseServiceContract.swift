
import Foundation


protocol NoteDatabaseServiceContract {
    func getNoteList(onSuccess: @escaping ([NoteModel]) -> Void, onFailure: @escaping (Error) -> Void)
    
    func saveNotes(_ notes: [NoteModel], onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void)
    
    func saveNote(note: NoteModel, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void)
    
    func deleteNote(id: String, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void)
}
