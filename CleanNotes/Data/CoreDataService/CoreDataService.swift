
import Foundation
import CoreData


public final class CoreDataService {
    public static let shared = CoreDataService()
    public let persistentContainer: NSPersistentContainer

    private init(modelName: String = "CleanNotes") {
        persistentContainer = NSPersistentContainer(name: modelName)
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data load error: \(error)")
            }
        }
        persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }

    public var viewContext: NSManagedObjectContext { persistentContainer.viewContext }

    public func saveContext() {
        let context = viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                Logger.debug("CoreData save failed: \(error)")
            }
        }
    }
    
    public func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask { context in
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            block(context)
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    Logger.debug("Background save failed: \(error)")
                }
            }
        }
    }
    
    public func deleteAll(completion: (() -> Void)? = nil) {
        performBackgroundTask { context in
            let fetch: NSFetchRequest<NSFetchRequestResult> = NoteEntity.fetchRequest()
            let delete = NSBatchDeleteRequest(fetchRequest: fetch)
            do {
                try context.execute(delete)
                try context.save()
            } catch {
                Logger.debug("Batch delete error: \(error)")
            }
            DispatchQueue.main.async {
                completion?()
            }
        }
    }
}
