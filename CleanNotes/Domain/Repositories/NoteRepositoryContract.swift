
import Foundation


public protocol NoteRepositoryContract {
    func getNoteList(onSuccess: @escaping ([Note]) -> Void, onFailure: @escaping (Error) -> Void)
    func saveNote(note: Note, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void)
    func deleteNote(id: String, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void)
}
