
import Foundation


public enum NetworkError: Error {
    case invalidURL
    case network(Error)
    case invalidResponse
    case serverError(Int)
    case noData
    case parsing(Error)
}

public class NoteNetworkService: NoteNetworkServiceContract {
    public init() {}
    
    public func fetchRemoteNotes(
        limit: Int = 5,
        onSuccess: @escaping ([NoteModel]) -> Void,
        onFailure: @escaping (NetworkError) -> Void
    ) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.2) {
            var notes: [NoteModel] = []
            let baseDate = Date()
            
            for i in 1...limit {
                let created = Calendar.current.date(byAdding: .hour, value: i, to: baseDate) ?? baseDate
                
                let note = NoteModel(
                    id: UUID().uuidString,
                    title: "MVVM-C Architecture: A Clean iOS Approach",
                    detail: "This article explains how I built a simple iOS app using MVVM-C, Clean Architecture, ARC, and Core Data, with a strong focus on how MVVM and the Coordinator pattern work together",
                    createdDate: created.isoString
                )
                notes.append(note)
            }
            onSuccess(notes)
        }
        
        func numberToWord(_ number: Int) -> String {
            switch number {
            case 1: return "one"
            case 2: return "two"
            case 3: return "three"
            case 4: return "four"
            case 5: return "five"
            default: return ""
            }
        }
    }
}
