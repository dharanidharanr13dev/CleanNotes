
import Foundation


enum NoteEntityMapper {

    static func toLocalDTO(entity: NoteEntity) -> NoteLocalDTO {
        NoteLocalDTO(id: entity.id ?? "", title: entity.title ?? "", detail: entity.detail ?? "", createdDate: entity.createdDate ?? Date())
    }

    static func update(entity: NoteEntity, from dto: NoteLocalDTO) {
        entity.id = dto.id
        entity.title = dto.title
        entity.detail = dto.detail
        entity.createdDate = dto.createdDate
    }
}
