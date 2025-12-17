
import Foundation


public class NoteListViewModel {
    weak var coordinator: NoteListCoordinatorContract?
    weak var viewController: NoteListViewControllerContract?
    private var getNoteListUsecase: GetNoteListUsecase
    
    private var allNotes: [Note] = []
    
    init(viewController: NoteListViewControllerContract? = nil, getNoteListUsecase: GetNoteListUsecase, coordinator: NoteListCoordinatorContract) {
        self.viewController = viewController
        self.getNoteListUsecase = getNoteListUsecase
        self.coordinator = coordinator
    }
}




extension NoteListViewModel: NoteListViewModelContract {
    
    public func getNotes() {
        let request = GetNoteListUsecaseRequest()
        getNoteListUsecase.execute(request: request, onSuccess: { [weak self] response in
            guard let self else { return }
            guard let resp = response as? GetNoteListUsecaseResponse else {
                self.viewController?.showError("Invalid response")
                return
            }
            if resp.notes.isEmpty {
                self.viewController?.showError("No notes available")
            } else {
                self.allNotes = resp.notes
                let presentationModels = resp.notes.map { NotePresentationModel(note: $0) }
                self.viewController?.loadNotes(presentationModels)
            }

        }, onFailure: { [weak self] error in
            guard let self else { return }
            self.viewController?.showError(error.localizedDescription)
        })
    }
     
    public func searchNotes(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if trimmed.isEmpty {
            let models = allNotes.map { NotePresentationModel(note: $0) }
            viewController?.loadNotes(models)
            return
        }
        
        let filtered = allNotes.filter {
            $0.title.lowercased().contains(trimmed) ||
            $0.detail.lowercased().contains(trimmed)
        }
        let presentationModels = filtered.map { NotePresentationModel(note: $0) }
        viewController?.loadNotes(presentationModels)
    }
    
    public func refreshNotes() {
        getNotes()
    }
    
    public func showNoteDetail(_ note: Note?) {
        coordinator?.showNoteDetail(note)
    }
}
