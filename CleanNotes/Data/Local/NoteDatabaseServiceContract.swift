
import Foundation


public protocol NoteDatabaseServiceContract {
    func getNoteList(onSuccess: @escaping ([NoteLocalDTO]) -> Void, onFailure: @escaping (Error) -> Void)

    func saveNoteList(_ notes: [NoteLocalDTO], onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void)

    func saveNote(_ note: NoteLocalDTO, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void)

    func deleteNote(id: String, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void)
}
