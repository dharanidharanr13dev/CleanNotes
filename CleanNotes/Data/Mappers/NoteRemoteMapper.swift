
import Foundation


enum NoteRemoteMapper {
    private static let formatter = ISO8601DateFormatter()

    static func toDomain(dto: NoteRemoteDTO) -> Note {
        Note(id: dto.id, title: dto.title, detail: dto.detail, createdDate: formatter.date(from: dto.createdDate) ?? Date()
        )
    }

    static func toDTO(note: Note) -> NoteRemoteDTO {
        NoteRemoteDTO(id: note.id, title: note.title, detail: note.detail, createdDate: formatter.string(from: note.createdDate))
    }
}
