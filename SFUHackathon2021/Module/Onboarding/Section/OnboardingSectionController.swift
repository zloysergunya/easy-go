import Foundation
import IGListKit

protocol OnboardingSectionControllerDelegate: AnyObject {
    func onboardingSectionController(didSelectAt index: Int)
}

class OnboardingSectionController: ListSectionController {
            
    weak var delegate: OnboardingSectionControllerDelegate?
        
    override func numberOfItems() -> Int {
        return OnboardingConfig.allPages.count
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return collectionContext!.containerSize
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(of: OnboardingCell.self, for: self, at: index) as! OnboardingCell
        
        return configure(cell: cell, config: OnboardingConfig.allPages[index])
    }
    
    private func configure(cell: OnboardingCell, config: OnboardingSectionModel) -> UICollectionViewCell {
        cell.imageView.image = config.image
        cell.titleLabel.text = config.title
        
        return cell
    }
    
    override func didSelectItem(at index: Int) {
        super.didSelectItem(at: index)
        
        delegate?.onboardingSectionController(didSelectAt: index)
    }
    
}
