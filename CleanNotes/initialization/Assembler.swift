
import UIKit


public final class Assembler: AssemblerContract {

    public static let shared = Assembler()

    private let databaseService: NoteDatabaseService
    private let networkService: NoteNetworkService
    private let dataManager: NoteDataManager

    private init() {
        self.databaseService = NoteDatabaseService()
        self.networkService = NoteNetworkService()
        self.dataManager = NoteDataManager(
            database: databaseService,
            network: networkService
        )
    }

    func makeNoteListModule(coordinator: NoteListCoordinatorContract) -> (vc: NoteListViewController, viewModel: NoteListViewModel) {
        let getNoteListUsecase = GetNoteListUsecase(dataManager: dataManager)
        let viewModel = NoteListViewModel(getNoteListUsecase: getNoteListUsecase, coordinator: coordinator)
        let vc = NoteListViewController(viewModel: viewModel)
        viewModel.viewController = vc
        return (vc, viewModel)
    }

    func makeNoteDetailViewController(note: NoteModel?, coordinator: NoteDetailCoordinatorContract) -> NoteDetailViewController {
        let saveNoteUsecase = SaveNoteUsecase(dataManager: dataManager)
        let deleteNoteUsecase = DeleteNoteUsecase(dataManager: dataManager)
        let viewModel = NoteDetailViewModel(saveNoteUsecase: saveNoteUsecase, deleteNoteUsecase: deleteNoteUsecase, coordinator: coordinator)
        let vc = NoteDetailViewController(viewModel: viewModel, note: note)
        viewModel.viewController = vc
        return vc
    }
}
