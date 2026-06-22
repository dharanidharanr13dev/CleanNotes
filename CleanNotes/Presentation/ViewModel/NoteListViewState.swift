
import Foundation

enum NoteListViewState {
    case loading
    case loaded([NotePresentationModel])
    case error(String)
}
