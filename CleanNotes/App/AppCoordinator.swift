
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
    func didSaveNote()
    func didCancelEditing()
}




class AppCoordinator: CoordinatorContract, NoteListCoordinatorContract, NoteDetailCoordinatorContract {

    var navigationController: UINavigationController
    private let assembler: AssemblerContract
    
    init(navigationController: UINavigationController, assembler: AssemblerContract) {
        self.navigationController = navigationController
        self.assembler = assembler
    }
    
    func start() {
        let vc = assembler.makeNoteListViewController(coordinator: self)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showNoteDetail(_ note: Note?) {
        let vc = assembler.makeNoteDetailViewController(note: note, coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func didSaveNote() {
        navigationController.popViewController(animated: true)
    }
    
    func didCancelEditing() {
        navigationController.popViewController(animated: true)
    }
}
