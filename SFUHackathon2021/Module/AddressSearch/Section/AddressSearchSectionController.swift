import IGListKit
import Atributika

protocol AddressSearchSectionControllerDelegate: AnyObject {
    func addressSearchSectionController(didSelect sectionModel: AddressSearchSectionModel)
}

class AddressSearchSectionController: ListSectionController {
    
    private var sectionModel: AddressSearchSectionModel!
    
    weak var delegate: AddressSearchSectionControllerDelegate?
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 54.0)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(of: AddressSearchCell.self, for: self, at: index) as! AddressSearchCell
        
        return configure(cell: cell)
    }
    
    private func configure(cell: AddressSearchCell) -> AddressSearchCell {
        
        var title = sectionModel.hit.name
        if let houseNumber = sectionModel.hit.housenumber {
            title.append(", " + houseNumber)
        }
        cell.titleLabel.text = title
        
        if let city = sectionModel.hit.city {
            cell.subtitleLabel.text = city
        } else {
            cell.subtitleLabel.text = sectionModel.hit.country
        }
        
                
        return cell
    }
    
    override func didUpdate(to object: Any) {
        precondition(object is AddressSearchSectionModel)
        sectionModel = object as? AddressSearchSectionModel
    }
    
    override func didSelectItem(at index: Int) {
        super.didSelectItem(at: index)
        
        delegate?.addressSearchSectionController(didSelect: sectionModel)
    }
    
}
