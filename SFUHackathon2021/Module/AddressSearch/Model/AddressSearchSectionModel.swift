import Foundation
import IGListDiffKit

class AddressSearchSectionModel {
    
    let hit: Hit
    
    init(hit: Hit) {
        self.hit = hit
    }
    
}

// MARK: - ListDiffable
extension AddressSearchSectionModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return String(hit.osm_id) as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Self else {
            return false
        }
        
        return object.hit.osm_id == hit.osm_id
    }
    
}
