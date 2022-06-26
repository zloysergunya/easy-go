import UIKit
import IGListKit

class OnboardingViewController: ViewController<OnboardingView> {
    
    private var currentIndex = 0
    private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.nextButton.addTarget(self, action: #selector(nextPageAction), for: .touchUpInside)
        
        adapter.collectionView = mainView.collectionView
        adapter.dataSource = self
        adapter.reloadData(completion: nil)
    }
    
    private func updatePage(index: Int) {
        let index = index + 1
        if index >= OnboardingConfig.allPages.count {
            close()
            return
        }
        
        mainView.collectionView.scrollToItem(at: IndexPath(item: index, section: 0),
                                             at: .centeredHorizontally,
                                             animated: true)
        currentIndex = index
    }
    
    private func close() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func nextPageAction() {
        updatePage(index: currentIndex)
    }
    
}

// MARK: - ListAdapterDataSource
extension OnboardingViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return SingleSectionModel.model
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let sectionController = OnboardingSectionController()
        sectionController.delegate = self
        
        return sectionController
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? { nil }
    
}

// MARK: - OnboardingSectionControllerDelegate
extension OnboardingViewController: OnboardingSectionControllerDelegate {
    
    func onboardingSectionController(didSelectAt index: Int) {
        updatePage(index: index)
    }
    
}
