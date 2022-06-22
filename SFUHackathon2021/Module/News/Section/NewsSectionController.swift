import IGListKit
import Atributika

protocol NewsSectionControllerDelegate: AnyObject {
    func newsSectionController(didSelect news: News)
}

class NewsSectionController: ListSectionController {
    
    weak var delegate: NewsSectionControllerDelegate?
    
    override init() {
        super.init()
        
        minimumLineSpacing = 12.0
        minimumInteritemSpacing = 12.0
    }
    
    override func numberOfItems() -> Int {
        return News.plugNews.count
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 100.0)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(of: NewsCell.self, for: self, at: index) as! NewsCell
        
        return configure(cell: cell, news: News.plugNews[index])
    }
    
    private func configure(cell: NewsCell, news: News) -> NewsCell {
        ImageLoader.setImage(url: news.image, imgView: cell.imageView, side: 84.0)
        cell.titleLabel.text = news.title
        cell.eventLabel.isHidden = news.point == nil
        cell.textLabel.text = news.text
        cell.textLabel.numberOfLines = news.point == nil ? 3 : 2
                
        return cell
    }
    
    override func didSelectItem(at index: Int) {
        super.didSelectItem(at: index)
        
        delegate?.newsSectionController(didSelect: News.plugNews[index])
    }
    
}
