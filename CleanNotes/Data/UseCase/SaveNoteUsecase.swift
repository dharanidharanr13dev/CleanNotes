
import Foundation


public class SaveNoteUsecaseRequest: Request {
    public let note: NoteModel
    public init(note: NoteModel) {
        self.note = note
    }
}

public class SaveNoteUsecaseResponse: Response {
    public init() {}
}


public class SaveNoteUsecase: ParentUsecase {
    var dataManager: NoteDataManagerContract
    public init(dataManager: NoteDataManagerContract) {
        self.dataManager = dataManager
        super.init()
    }

    public override func run(request: Request, onSuccess: @escaping (Response) -> Void, onFailure: @escaping (Error) -> Void) {
        guard let note = (request as? SaveNoteUsecaseRequest)?.note else {
            fatalError("Invalid SaveNoteUsecaseRequest value")
        }
        dataManager.saveNote(note: note) {
            let response = SaveNoteUsecaseResponse()
            self.invokeSuccess(response: response, onSuccess: onSuccess)
        } onFailure: { error in
            self.invokeFailure(error: error, onFailure: onFailure)
        }
    }
}
