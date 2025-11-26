
import Foundation


public class GetNoteListUsecaseRequest: Request {
    public init() {}
}

public class GetNoteListUsecaseResponse: Response {
    public let notes: [NoteModel]
    public init(notes: [NoteModel]) {
        self.notes = notes
    }
}


public class GetNoteListUsecase: ParentUsecase {
    var dataManager: NoteDataManagerContract
    public init(dataManager: NoteDataManagerContract) {
        self.dataManager = dataManager
        super.init()
    }

    public override func run(request: Request, onSuccess: @escaping (Response) -> Void, onFailure: @escaping (Error) -> Void) {
        dataManager.getNoteList { notes in
            let response = GetNoteListUsecaseResponse(notes: notes)
            self.invokeSuccess(response: response, onSuccess: onSuccess)
        } onFailure: { error in
            self.invokeFailure(error: error, onFailure: onFailure)
        }
    }
}
