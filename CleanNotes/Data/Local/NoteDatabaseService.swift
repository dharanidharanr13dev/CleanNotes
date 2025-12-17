
import Foundation
import CoreData


public class NoteDatabaseService: NoteDatabaseServiceContract {
    public init() {}

    public func getNoteList(onSuccess: @escaping ([Note]) -> Void, onFailure: @escaping (Error) -> Void) {
        let context = CoreDataService.shared.viewContext
        context.perform {
            let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
            request.sortDescriptors = [
                NSSortDescriptor(key: "createdDate", ascending: false)
            ]
            do {
                let results = try context.fetch(request)
                let notes = results.map {
                    Note(
                        id: $0.id ?? "",
                        title: $0.title ?? "",
                        detail: $0.detail ?? "",
                        createdDate: $0.createdDate ?? ""
                    )
                }
                onSuccess(notes)
            } catch {
                Logger.debug("Fetch error: \(error)")
                onFailure(error)
            }
        }
    }

    public func saveNotes(_ notes: [Note], onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        CoreDataService.shared.performBackgroundTask { context in
            for i in notes {
                let entity = NoteEntity(context: context)
                entity.id = i.id
                entity.title = i.title
                entity.detail = i.detail
                entity.createdDate = i.createdDate
            }
            do {
                try context.save()
                onSuccess()
            } catch {
                Logger.debug("Save error: \(error)")
                onFailure(error)
            }
        }
    }

    public func saveNote(note: Note, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        CoreDataService.shared.performBackgroundTask { context in
            let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", note.id)
            do {
                let results = try context.fetch(request)
                if let existing = results.first {
                    existing.title = note.title
                    existing.detail = note.detail
                } else {
                    let noteEntity = NoteEntity(context: context)
                    noteEntity.id = note.id
                    noteEntity.title = note.title
                    noteEntity.detail = note.detail
                    noteEntity.createdDate = note.createdDate
                }
                try context.save()
                onSuccess()
            } catch {
                Logger.debug("SaveOrUpdate error: \(error)")
                onFailure(error)
            }
        }
    }

    public func deleteNote( id: String, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        CoreDataService.shared.performBackgroundTask { context in
            let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id)
            do {
                let results = try context.fetch(request)
                if let noteToDelete = results.first {
                    context.delete(noteToDelete)
                    try context.save()
                    onSuccess()
                } else {
                    let notFound = NSError(domain: "NoteDatabaseService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Note not found"])
                    onFailure(notFound)
                }
            } catch {
                Logger.debug("Delete error: \(error)")
                onFailure(error)
            }
        }
    }
}
