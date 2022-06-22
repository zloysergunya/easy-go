import IGListKit

class SingleSectionModel: ListDiffable {
    
    static let model: [ListDiffable] = [SingleSectionModel()]
    
    private init() {}
    
    func diffIdentifier() -> NSObjectProtocol { 0 as NSObjectProtocol }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return object is SingleSectionModel
    }
}
