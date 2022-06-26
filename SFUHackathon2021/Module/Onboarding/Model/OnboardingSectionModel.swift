import IGListDiffKit
import UIKit

class OnboardingSectionModel {
    
    let title: String
    let image: UIImage?
    
    init(title: String, image: UIImage?) {
        self.title = title
        self.image = image
    }
    
}

// MARK: - ListDiffable
extension OnboardingSectionModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return title as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Self else {
            return false
        }
        
        return object.title == title && object.image == image
    }
    
}
