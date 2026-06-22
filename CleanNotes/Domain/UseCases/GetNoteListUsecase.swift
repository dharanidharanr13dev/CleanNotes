
import Foundation


public struct GetNoteListUsecaseRequest: Request {
    public init() {}
}

public struct GetNoteListUsecaseResponse: Response {
    public let notes: [Note]
    public init(notes: [Note]) {
        self.notes = notes
    }
}


public final class GetNoteListUsecase: ParentUsecase {
    private let repository: NoteRepositoryContract
    public init(repository: NoteRepositoryContract) {
        self.repository = repository
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
