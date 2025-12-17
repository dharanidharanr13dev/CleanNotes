
import Foundation


protocol NoteNetworkServiceContract {
    func fetchRemoteNotes(limit: Int, onSuccess: @escaping ([Note]) -> Void, onFailure: @escaping (NetworkError) -> Void)
}
