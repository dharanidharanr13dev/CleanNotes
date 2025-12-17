
import Foundation


public class NoteRepository: NoteRepositoryContract {
    
    private var database: NoteDatabaseServiceContract
    private var network: NoteNetworkServiceContract

    init(database: NoteDatabaseServiceContract, network: NoteNetworkServiceContract) {
        self.database = database
        self.network = network  
    }

    public func getNoteList(onSuccess: @escaping ([Note]) -> Void, onFailure: @escaping (Error) -> Void) {
        database.getNoteList { [weak self] notes in
            guard let self else { return }
            if !notes.isEmpty {
                onSuccess(notes)
            } else {
                self.network.fetchRemoteNotes(limit: 1) { [weak self] notes in
                    guard let self else { return }
                    database.saveNotes(notes) {
                        onSuccess(notes)
                    } onFailure: { error in
                        onFailure(error)
                    }
                 } onFailure: { error in
                     onFailure(error)
                 }
            }
        } onFailure: { [weak self] error in
            guard let self else { return }
            self.network.fetchRemoteNotes(limit: 5) { notes in
                onSuccess(notes)
            } onFailure: { error in
                onFailure(error)
            }
        }
    }
    
    public func saveNote(note: Note, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        database.saveNote(note: note) {
            onSuccess()
        } onFailure: { error in
            onFailure(error)
        }
    }
    
    public func deleteNote(id: String, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        database.deleteNote(id: id) {
            onSuccess()
        } onFailure: { error in
            onFailure(error)
        }    
    }
}
