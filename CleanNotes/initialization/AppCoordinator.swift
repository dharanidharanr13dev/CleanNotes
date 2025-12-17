
import Foundation
import UIKit


protocol CoordinatorContract: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
}

protocol NoteListCoordinatorContract: AnyObject {
    func showNoteDetail(_ note: Note?)
}

protocol NoteDetailCoordinatorContract: AnyObject {
    func didFinishEditingNote()
    func popToNoteListPage()
}




class AppCoordinator: CoordinatorContract, NoteListCoordinatorContract, NoteDetailCoordinatorContract {

    var navigationController: UINavigationController
    private weak var noteListViewModel: NoteListViewModel?
    private let assembler: AssemblerContract
    
    init(navigationController: UINavigationController, assembler: AssemblerContract) {
        self.navigationController = navigationController
        self.assembler = assembler
    }
    
    func start() {
        let module = assembler.makeNoteListModule(coordinator: self)
        let listVC = module.vc
        noteListViewModel = module.viewModel
        navigationController.pushViewController(listVC, animated: false)
    }
    
    func showNoteDetail(_ note: Note?) {
        let detailVC = assembler.makeNoteDetailViewController(note: note, coordinator: self)
        navigationController.pushViewController(detailVC, animated: true)
    }
    
    func didFinishEditingNote() {
        navigationController.popViewController(animated: true)
        noteListViewModel?.refreshNotes()
    }
    
    func popToNoteListPage() {
        navigationController.popViewController(animated: true)
    }
}
