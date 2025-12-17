
import Foundation


public class SaveNoteUsecaseRequest: Request {
    public let note: Note
    public init(note: Note) {
        self.note = note
    }
}

public class SaveNoteUsecaseResponse: Response {
    public init() {}
}


public class SaveNoteUsecase: ParentUsecase {
    var repository: NoteRepositoryContract
    public init(dataManager: NoteRepositoryContract) {
        self.repository = dataManager
        super.init()
    }

    public override func run(request: Request, onSuccess: @escaping (Response) -> Void, onFailure: @escaping (Error) -> Void) {
        guard let note = (request as? SaveNoteUsecaseRequest)?.note else {
            fatalError("Invalid SaveNoteUsecaseRequest request")
        }
        repository.saveNote(note: note) {
            let response = SaveNoteUsecaseResponse()
            self.invokeSuccess(response: response, onSuccess: onSuccess)
        } onFailure: { error in
            self.invokeFailure(error: error, onFailure: onFailure)
        }
    }
}
