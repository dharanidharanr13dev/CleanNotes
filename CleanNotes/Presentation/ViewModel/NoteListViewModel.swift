
import Foundation


public final class NoteListViewModel {
    private weak var coordinator: NoteListCoordinatorContract?
    private var getNoteListUsecase: GetNoteListUsecase
    var stateDidChange: ((NoteListViewState) -> Void)?
    
    private var allNotes: [Note] = []
    private var allPresentationModels: [NotePresentationModel] = []
    private var displayedPresentationModels: [NotePresentationModel] = []
    
    init(getNoteListUsecase: GetNoteListUsecase, coordinator: NoteListCoordinatorContract) {
        self.getNoteListUsecase = getNoteListUsecase
        self.coordinator = coordinator
    }
    
    private func emit(_ state: NoteListViewState) {
        DispatchQueue.main.async { [weak self] in
            self?.stateDidChange?(state)
        }
    }
}




extension NoteListViewModel: NoteListViewModelContract {
    func didTapAddNote() {
        coordinator?.showNoteDetail(nil)
    }
    
    public func getNotes() {
        emit(.loading)
        let request = GetNoteListUsecaseRequest()
        getNoteListUsecase.execute(request: request, onSuccess: { [weak self] response in
            guard let self else { return }
            guard let resp = response as? GetNoteListUsecaseResponse else {
                self.emit(.error("Invalid response"))
                return
            }
            self.allNotes = resp.notes
            self.allPresentationModels = resp.notes.map {
                NotePresentationModel(note: $0)
            }
            self.displayedPresentationModels = self.allPresentationModels
            self.emit(.loaded(self.displayedPresentationModels))
        }, onFailure: { [weak self] error in
            guard let self else { return }
            self.emit(.error(error.localizedDescription))
        })
    }
     
    public func searchNotes(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if trimmed.isEmpty {
            displayedPresentationModels = allPresentationModels
            emit(.loaded(displayedPresentationModels))
            return
        }
        let filtered = allPresentationModels.filter {
            $0.attributedTitle.string.lowercased().contains(trimmed) || $0.detailText.string.lowercased().contains(trimmed)
        }
        displayedPresentationModels = filtered
        emit(.loaded(filtered))
    }
    
    func didSelectRow(at index: Int) {
        guard index < displayedPresentationModels.count else {
            return
        }
        let selectedId = displayedPresentationModels[index].id
        guard let selectedNote = allNotes.first(where: { $0.id == selectedId }) else {
            return
        }
        coordinator?.showNoteDetail(selectedNote)
    }
}
