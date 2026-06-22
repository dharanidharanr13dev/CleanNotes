
import Foundation


public struct SaveNoteUsecaseRequest: Request {
    public let note: Note
    public init(note: Note) {
        self.note = note
    }
}

public struct SaveNoteUsecaseResponse: Response {
    public init() {}
}


public final class SaveNoteUsecase: ParentUsecase {
    private let repository: NoteRepositoryContract
    public init(repository: NoteRepositoryContract) {
        self.repository = repository
        super.init()
    }

    public override func run(request: Request, onSuccess: @escaping (Response) -> Void, onFailure: @escaping (Error) -> Void) {
        guard let note = (request as? SaveNoteUsecaseRequest)?.note else {
            onFailure(DomainError.invalidRequest)
            return
        }
        repository.saveNote(note: note) {
            let response = SaveNoteUsecaseResponse()
            self.invokeSuccess(response: response, onSuccess: onSuccess)
        } onFailure: { error in
            self.invokeFailure(error: error, onFailure: onFailure)
        }
    }
}
