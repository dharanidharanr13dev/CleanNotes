
import Foundation


public class GetNoteListUsecaseRequest: Request {
    public init() {}
}

public class GetNoteListUsecaseResponse: Response {
    public let notes: [Note]
    public init(notes: [Note]) {
        self.notes = notes
    }
}


public class GetNoteListUsecase: ParentUsecase {
    var repository: NoteRepositoryContract
    public init(dataManager: NoteRepositoryContract) {
        self.repository = dataManager
        super.init()
    }

    public override func run(request: Request, onSuccess: @escaping (Response) -> Void, onFailure: @escaping (Error) -> Void) {
        repository.getNoteList { notes in
            let response = GetNoteListUsecaseResponse(notes: notes)
            self.invokeSuccess(response: response, onSuccess: onSuccess)
        } onFailure: { error in
            self.invokeFailure(error: error, onFailure: onFailure)
        }
    }
}
