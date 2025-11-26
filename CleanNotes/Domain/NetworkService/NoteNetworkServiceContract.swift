
import Foundation


protocol NoteNetworkServiceContract {
    func fetchRemoteNotes(limit: Int, onSuccess: @escaping ([NoteModel]) -> Void, onFailure: @escaping (NetworkError) -> Void)
}
