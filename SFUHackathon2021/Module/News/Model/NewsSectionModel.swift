import Foundation
import IGListDiffKit

class NewsSectionModel {
    
    let news: [News]
    
    init(news: [News]) {
        self.news = news
    }
    
}

// MARK: - ListDiffable
extension NewsSectionModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return 0 as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Self else {
            return false
        }
        
        return object.news == news
    }
    
}
