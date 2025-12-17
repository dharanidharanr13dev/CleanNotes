
import Foundation


public struct Note {
    public let id: String
    public let title: String
    public let detail: String
    public let createdDate: String

    public init(id: String, title: String, detail: String, createdDate: String) {
        self.id = id
        self.title = title
        self.detail = detail
        self.createdDate = createdDate
    }
}
