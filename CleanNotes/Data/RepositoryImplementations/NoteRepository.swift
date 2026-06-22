
import Foundation


public final class NoteRepository: NoteRepositoryContract {
    
    private let database: NoteDatabaseServiceContract
    private let network: NoteNetworkServiceContract
    
    public init(database: NoteDatabaseServiceContract, network: NoteNetworkServiceContract) {
        self.database = database
        self.network = network
    }
}


extension NoteRepository {
    public func getNoteList(onSuccess: @escaping ([Note]) -> Void, onFailure: @escaping (Error) -> Void) {
        database.getNoteList { [weak self] localNoteDTOs in
            guard let self else { return }
            let notes = localNoteDTOs.map {
                NoteLocalMapper.toDomain(dto: $0)
            }
            guard notes.isEmpty else {
                onSuccess(notes)
                return
            }
            self.network.fetchRemoteNotes(limit: 1) { [weak self] remoteNoteDTOs in
                guard let self else { return }
                let notes = remoteNoteDTOs.map {
                    NoteRemoteMapper.toDomain(dto: $0)
                }
                let localDTOs = notes.map { NoteLocalMapper.toDTO(note: $0) }
                database.saveNoteList(localDTOs) {
                    onSuccess(notes)
                } onFailure: { error in
                    onFailure(error)
                }
            } onFailure: { error in
                onFailure(error)
            }
        } onFailure: { [weak self] error in
            guard let self else { return }
            self.network.fetchRemoteNotes(limit: 1) { remoteNoteDTOs in
                let notes = remoteNoteDTOs.map {
                    NoteRemoteMapper.toDomain(dto: $0)
                }
                onSuccess(notes)
            } onFailure: { error in
                onFailure(error)
            }
        }
    }
    
    public func saveNote(note: Note, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        let localDTO = NoteLocalMapper.toDTO(note: note)
        database.saveNote(localDTO) {
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
