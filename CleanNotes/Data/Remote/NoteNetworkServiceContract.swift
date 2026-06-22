
import Foundation


public protocol NoteNetworkServiceContract {
    func fetchRemoteNotes(limit: Int, onSuccess: @escaping ([NoteRemoteDTO]) -> Void, onFailure: @escaping (Error) -> Void)
}
