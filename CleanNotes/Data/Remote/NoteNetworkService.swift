
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
    public func fetchRemoteNotes(limit: Int = 5, onSuccess: @escaping ([NoteRemoteDTO]) -> Void, onFailure: @escaping (Error) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.2) {
            var notes: [NoteRemoteDTO] = []
            let baseDate = Date()
            for i in 1...limit {
                let created = Calendar.current.date(byAdding: .hour, value: i, to: baseDate) ?? baseDate
                let firstNote = NoteRemoteDTO(
                    id: UUID().uuidString,
                    title: "Upcomming Project - Scalable SwiftUI App with Modern iOS Architecture",
                    detail: "This application will covers modern iOS development using SwiftUI, Swift Concurrency, MVVM-C, and Clean Architecture. Learn how to design scalable applications with pagination, local caching, repository patterns, dependency injection, offline-first data handling, structured concurrency, task cancellation, performance optimization, modular feature development, and comprehensive testing strategies. Explore real-world approaches used in production apps to improve maintainability, responsiveness, and long-term scalability.",
                    createdDate: created.isoString
                )
                let secondNote = NoteRemoteDTO(
                    id: UUID().uuidString,
                    title: "MVVM-C Architecture: An UIkit App with clean iOS Approach",
                    detail: "This application explains how I built a simple iOS app using MVVM-C, Clean Architecture, ARC, and Core Data, with a strong focus on how MVVM and the Coordinator pattern work together.",
                    createdDate: baseDate.isoString
                )
                notes.append(contentsOf: [firstNote, secondNote])
            }
            onSuccess(notes)
        }
    }
}
