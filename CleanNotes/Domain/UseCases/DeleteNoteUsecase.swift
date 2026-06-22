
import Foundation


public struct DeleteNoteUsecaseRequest: Request {
    public let id: String
    public init(id: String) {
        self.id = id
    }
}

public struct DeleteNoteUsecaseResponse: Response {
    public init() {}
}


public final class DeleteNoteUsecase: ParentUsecase {
    private let repository: NoteRepositoryContract
    public init(repository: NoteRepositoryContract) {
        self.repository = repository
        super.init()
    }

    public override func run(request: Request, onSuccess: @escaping (Response) -> Void, onFailure: @escaping (Error) -> Void) {
        guard let id = (request as? DeleteNoteUsecaseRequest)?.id else {
            onFailure(DomainError.invalidRequest)
            return
        }
        repository.deleteNote(id: id) {
            let response = DeleteNoteUsecaseResponse()
            self.invokeSuccess(response: response, onSuccess: onSuccess)
        } onFailure: { error in
            self.invokeFailure(error: error, onFailure: onFailure)
        }
    }
}
