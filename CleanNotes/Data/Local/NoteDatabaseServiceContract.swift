
import Foundation


protocol NoteDatabaseServiceContract {
    func getNoteList(onSuccess: @escaping ([Note]) -> Void, onFailure: @escaping (Error) -> Void)
    
    func saveNotes(_ notes: [Note], onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void)
    
    func saveNote(note: Note, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void)
    
    func deleteNote(id: String, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void)
}
