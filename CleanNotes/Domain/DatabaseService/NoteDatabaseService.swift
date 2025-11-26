
import Foundation
import CoreData


public class NoteDatabaseService: NoteDatabaseServiceContract {
    public init() {}

    public func getNoteList(onSuccess: @escaping ([NoteModel]) -> Void, onFailure: @escaping (Error) -> Void) {
        let context = CoreDataService.shared.viewContext
        context.perform {
            let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
            request.sortDescriptors = [
                NSSortDescriptor(key: "createdDate", ascending: false)
            ]
            do {
                let results = try context.fetch(request)
                let notes = results.map {
                    NoteModel(
                        id: $0.id ?? "",
                        title: $0.title ?? "",
                        detail: $0.detail ?? "",
                        createdDate: $0.createdDate ?? ""
                    )
                }
                DispatchQueue.main.async { onSuccess(notes) }
            } catch {
                Logger.debug("Fetch error: \(error)")
                DispatchQueue.main.async { onFailure(error) }
            }
        }
    }

    public func saveNotes(_ notes: [NoteModel], onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        CoreDataService.shared.performBackgroundTask { context in
            for t in notes {
                let entity = NoteEntity(context: context)
                entity.id = t.id
                entity.title = t.title
                entity.detail = t.detail
                entity.createdDate = t.createdDate
            }
            do {
                try context.save()
                DispatchQueue.main.async {
                    onSuccess()
                }
            } catch {
                Logger.debug("Save error: \(error)")
                DispatchQueue.main.async {
                    onFailure(error)
                }
            }
        }
    }

    public func saveNote(note: NoteModel, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
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
                DispatchQueue.main.async {
                    onSuccess()
                }
            } catch {
                Logger.debug("SaveOrUpdate error: \(error)")
                DispatchQueue.main.async {
                    onFailure(error)
                }
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
                    DispatchQueue.main.async {
                        onSuccess()
                    }
                } else {
                    let notFound = NSError(domain: "NoteDatabaseService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Note not found"])
                    DispatchQueue.main.async {
                        onFailure(notFound)
                    }
                }
            } catch {
                Logger.debug("Delete error: \(error)")
                DispatchQueue.main.async {
                    onFailure(error)
                }
            }
        }
    }

}
