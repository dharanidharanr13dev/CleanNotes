
import Foundation
import CoreData


public class NoteDatabaseService: NoteDatabaseServiceContract {
    public init() {}

    public func getNoteList(onSuccess: @escaping ([NoteLocalDTO]) -> Void, onFailure: @escaping (Error) -> Void) {
        let context = CoreDataService.shared.viewContext
        context.perform {
            let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
            request.sortDescriptors = [
                NSSortDescriptor(key: "createdDate", ascending: false)
            ]
            do {
                let entities = try context.fetch(request)
                let notes = entities.map {
                    NoteEntityMapper.toLocalDTO(entity: $0)
                }
                onSuccess(notes)
            } catch {
                Logger.debug("Fetch error: \(error)")
                onFailure(error)
            }
        }
    }

    public func saveNoteList(_ notes: [NoteLocalDTO], onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        CoreDataService.shared.performBackgroundTask { context in
            for note in notes {
                let entity = NoteEntity(context: context)
                NoteEntityMapper.update(entity: entity, from: note)
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

    public func saveNote(_ note: NoteLocalDTO, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        CoreDataService.shared.performBackgroundTask { context in
            let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", note.id)
            do {
                let results = try context.fetch(request)
                if let existing = results.first {
                    existing.title = note.title
                    existing.detail = note.detail
                } else {
                    let entity = NoteEntity(context: context)
                    NoteEntityMapper.update(entity: entity, from: note)
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
                    onFailure(DatabaseError.noteNotFound)
                }
            } catch {
                Logger.debug("Delete error: \(error)")
                onFailure(error)
            }
        }
    }
}
