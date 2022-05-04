import UIKit
import MapKit
import IGListKit

protocol AddressSearchViewControllerDelegate: AnyObject {
    func addressSearchViewController(_ controller: AddressSearchViewController, didSearch hit: Hit)
}

class AddressSearchViewController: UIViewController {
    
    enum SearchPointType {
        case from, to
    }
    
    private var query: String?
    private let provider = AddressSearchProvider()
    private var hits: [AddressSearchSectionModel] = []
    
    weak var delegate: AddressSearchViewControllerDelegate?
    
    private lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    private var mainView: AddressSearchView {
        return view as! AddressSearchView
    }
    
    let searchPointType: SearchPointType
    let region: MKCoordinateRegion
    
    init(searchPointType: SearchPointType, region: MKCoordinateRegion) {
        self.searchPointType = searchPointType
        self.region = region
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = AddressSearchView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        mainView.searchBar.delegate = self
        
        adapter.collectionView = mainView.collectionView
        adapter.dataSource = self
        
        switch searchPointType {
        case .from:
            mainView.titleLabel.text = "Откуда"
        case .to:
            mainView.titleLabel.text = "Куда"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainView.searchBar.becomeFirstResponder()
    }
    
    @objc private func close() {
        dismiss(animated: true)
    }
    
    private func search() {
        guard let query = query else {
            return
        }
        
        provider.search(query: query) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let hits):
                self.hits = hits.map({ AddressSearchSectionModel(hit: $0) })
                self.adapter.reloadData(completion: nil)
                
            case .failure:
                break
            }
        }
    }
    
}

// MARK: - UISearchBarDelegate
extension AddressSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard query != searchText.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }
        
        if searchText.isEmpty {
            query = nil
        } else {
            query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        search()
    }
    
}

// MARK: - ListAdapterDataSource
extension AddressSearchViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return hits
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let addressSearchSectionController = AddressSearchSectionController()
        addressSearchSectionController.delegate = self
        
        return addressSearchSectionController
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}

// MARK: - AddressSearchSectionControllerDelegate
extension AddressSearchViewController: AddressSearchSectionControllerDelegate {
    
    func addressSearchSectionController(didSelect sectionModel: AddressSearchSectionModel) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else {
                return
            }
            
            self.delegate?.addressSearchViewController(self, didSearch: sectionModel.hit)
        }
    }
    
}
