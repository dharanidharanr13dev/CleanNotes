
import Foundation


protocol AssemblerContract {
    func makeNoteListModule(coordinator: NoteListCoordinatorContract) -> (vc: NoteListViewController, viewModel: NoteListViewModel)
    
    func makeNoteDetailViewController(note: NoteModel?, coordinator: NoteDetailCoordinatorContract) -> NoteDetailViewController
}
