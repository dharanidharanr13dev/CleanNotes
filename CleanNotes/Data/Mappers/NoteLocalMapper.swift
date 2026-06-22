
import Foundation


enum NoteLocalMapper {
    static func toDomain(dto: NoteLocalDTO) -> Note {
        Note(id: dto.id, title: dto.title, detail: dto.detail, createdDate: dto.createdDate)
    }

    static func toDTO(note: Note) -> NoteLocalDTO {
        NoteLocalDTO(id: note.id, title: note.title, detail: note.detail, createdDate: note.createdDate)
    }
}
