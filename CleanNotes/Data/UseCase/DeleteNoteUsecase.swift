
import Foundation


public class DeleteNoteUsecaseRequest: Request {
    public let id: String
    public init(id: String) {
        self.id = id
    }
}

public class DeleteNoteUsecaseResponse: Response {
    public init() {}
}


public class DeleteNoteUsecase: ParentUsecase {
    var dataManager: NoteDataManagerContract
    public init(dataManager: NoteDataManagerContract) {
        self.dataManager = dataManager
        super.init()
    }

    public override func run(request: Request, onSuccess: @escaping (Response) -> Void, onFailure: @escaping (Error) -> Void) {
        guard let id = (request as? DeleteNoteUsecaseRequest)?.id else {
            fatalError("Invalid SaveNoteUsecaseRequest value")
        }
        dataManager.deleteNote(id: id) {
            let response = DeleteNoteUsecaseResponse()
            self.invokeSuccess(response: response, onSuccess: onSuccess)
        } onFailure: { error in
            self.invokeFailure(error: error, onFailure: onFailure)
        }
    }
}
