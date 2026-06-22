
import Foundation


enum NoteDetailViewState {
    case loading
    case saveSuccess
    case deleteSuccess
    case validationError(String)
    case error(String)
}
