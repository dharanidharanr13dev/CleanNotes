
import Foundation
import CoreData


extension NoteEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteEntity> {
        return NSFetchRequest<NoteEntity>(entityName: "NoteEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var detail: String?
    @NSManaged public var title: String?
    @NSManaged public var createdDate: Date?

}

extension NoteEntity : Identifiable {

}
