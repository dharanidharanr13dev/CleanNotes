
import UIKit


public final class Assembler: AssemblerContract {
    private let databaseService: NoteDatabaseService
    private let networkService: NoteNetworkService
    private let dataManager: NoteRepository

    public static let shared = Assembler()
    private init() {
        self.databaseService = NoteDatabaseService()
        self.networkService = NoteNetworkService()
        self.dataManager = NoteRepository(
            database: databaseService,
            network: networkService
        )
    }

    func makeNoteListViewController(coordinator: NoteListCoordinatorContract) -> NoteListViewController {
        let getNoteListUsecase = GetNoteListUsecase(repository: dataManager)
        let viewModel = NoteListViewModel(getNoteListUsecase: getNoteListUsecase, coordinator: coordinator)
        let vc = NoteListViewController(viewModel: viewModel)
        return vc
    }

    func makeNoteDetailViewController(note: Note?, coordinator: NoteDetailCoordinatorContract) -> NoteDetailViewController {
        let saveNoteUsecase = SaveNoteUsecase(repository: dataManager)
        let deleteNoteUsecase = DeleteNoteUsecase(repository: dataManager)
        let viewModel = NoteDetailViewModel(saveNoteUsecase: saveNoteUsecase, deleteNoteUsecase: deleteNoteUsecase, coordinator: coordinator)
        let vc = NoteDetailViewController(viewModel: viewModel, note: note)
        return vc
    }
}
