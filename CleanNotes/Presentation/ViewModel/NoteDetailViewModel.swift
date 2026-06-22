
import Foundation


public final class NoteDetailViewModel {
    private weak var coordinator: NoteDetailCoordinatorContract?
    private let saveNoteUsecase: SaveNoteUsecase
    private let deleteNoteUsecase: DeleteNoteUsecase
    var stateDidChange: ((NoteDetailViewState) -> Void)?
    
    init(saveNoteUsecase: SaveNoteUsecase, deleteNoteUsecase: DeleteNoteUsecase, coordinator: NoteDetailCoordinatorContract) {
        self.saveNoteUsecase = saveNoteUsecase
        self.deleteNoteUsecase = deleteNoteUsecase
        self.coordinator = coordinator
    }
    
    private func emit(_ state: NoteDetailViewState) {
        DispatchQueue.main.async { [weak self] in
            self?.stateDidChange?(state)
        }
    }
}




extension NoteDetailViewModel: NoteDetailViewModelContract {
    func saveNote(note: Note) {
        emit(.loading)
        let request = SaveNoteUsecaseRequest(note: note)
        saveNoteUsecase.execute(request: request, onSuccess: { [weak self] response in
            guard let self else { return }
            guard let _ = response as? SaveNoteUsecaseResponse else {
                self.emit(.error("Invalid response"))
                return
            }
            self.emit(.saveSuccess)
        }, onFailure: { [weak self] error in
            guard let self else { return }
            self.emit(.error(error.localizedDescription))
        })
    }
    
    func deleteNote(id: String) {
        emit(.loading)
        let request = DeleteNoteUsecaseRequest(id: id)
        deleteNoteUsecase.execute(request: request, onSuccess: { [weak self] response in
            guard let self else { return }
            guard let _ = response as? DeleteNoteUsecaseResponse else {
                self.emit(.error("Invalid response"))
                return
            }
            self.emit(.deleteSuccess)
        }, onFailure: { [weak self] error in
            guard let self else { return }
            self.emit(.error(error.localizedDescription))
        })
    }
    
    func didTapBack(title: String, detail: String, existingNote: Note?, createdDate: Date?) {
        let titleText = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let detailText = detail.trimmingCharacters(in: .whitespacesAndNewlines)
        if titleText.isEmpty && !detailText.isEmpty {
            emit(.validationError("Please enter a title."))
            return
        }
        if titleText.isEmpty && detailText.isEmpty {
            coordinator?.didCancelEditing()
            return
        }
    
        let note = Note(id: existingNote?.id ?? UUID().uuidString, title: titleText, detail: detailText, createdDate: (existingNote?.createdDate ?? createdDate) ?? Date())
        saveNote(note: note)
    }
    
    func didSaveNote() {
        coordinator?.didSaveNote()
    }
    
    func didCancelEditing() {
        coordinator?.didCancelEditing()
    }
}

