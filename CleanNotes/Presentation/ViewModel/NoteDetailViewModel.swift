
import Foundation


public class NoteDetailViewModel {
    weak var coordinator: NoteDetailCoordinatorContract?
    weak var viewController: NoteDetailViewControllerContract?
    private var saveNoteUsecase: SaveNoteUsecase
    private var deleteNoteUsecase: DeleteNoteUsecase
    
    init(viewController: NoteDetailViewControllerContract? = nil, saveNoteUsecase: SaveNoteUsecase, deleteNoteUsecase: DeleteNoteUsecase, coordinator: NoteDetailCoordinatorContract) {
        self.viewController = viewController
        self.saveNoteUsecase = saveNoteUsecase
        self.deleteNoteUsecase = deleteNoteUsecase
        self.coordinator = coordinator
    }
}




extension NoteDetailViewModel: NoteDetailViewModelContract {
    func saveNote(note: Note) {
        let request = SaveNoteUsecaseRequest(note: note)
        saveNoteUsecase.execute(request: request, onSuccess: { [weak self] response in
            guard let self else { return }
            guard let _ = response as? SaveNoteUsecaseResponse else {
                self.viewController?.showError("Invalid response")
                return
            }
            self.viewController?.showSuccessToast("Note saved Successfully")
        }, onFailure: { [weak self] error in
            guard let self else { return }
            self.viewController?.showError(error.localizedDescription)
        })
    }
    
    func deleteNote(id: String) {
        let request = DeleteNoteUsecaseRequest(id: id)
        deleteNoteUsecase.execute(request: request, onSuccess: { [weak self] response in
            guard let self else { return }
            guard let _ = response as? DeleteNoteUsecaseResponse else {
                self.viewController?.showError("Invalid response")
                return
            }
            self.viewController?.showSuccessToast("Note deleted Successfully")
        }, onFailure: { [weak self] error in
            guard let self else { return }
            self.viewController?.showError(error.localizedDescription)
        })
    }
    
    func loadNoteListPage() {
        coordinator?.didFinishEditingNote()
    }
    
    func popToNoteListPage() {
        coordinator?.popToNoteListPage()
    }
}
