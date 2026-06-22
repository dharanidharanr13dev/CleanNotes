
import Foundation


protocol AssemblerContract {
    func makeNoteListViewController(coordinator: NoteListCoordinatorContract) -> NoteListViewController
    func makeNoteDetailViewController(note: Note?, coordinator: NoteDetailCoordinatorContract) -> NoteDetailViewController
}
