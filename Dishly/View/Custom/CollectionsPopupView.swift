import UIKit
import JGProgressHUD

protocol CollectionsPopupViewDelegate {
    func hidePopup()
    func presentAlert(alert : UIAlertController)
}

class CollectionsPopupView: UIView {
    //MARK: - Properties
    private let hud = JGProgressHUD(style: .dark)

    
    private var collectionView: UICollectionView!
    
    var recipe: RecipeViewModel?
    
    var delegate: CollectionsPopupViewDelegate?
    
    var collectionViewModel: CollectionViewModel?
    
    private var collections: [Collection]? {
        didSet { collectionView.reloadData() }
    }
    
    override func didMoveToSuperview() {
        fetchCollections()
    }
    
    private let popupLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Save to"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configureView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let frame = CGRect(x: bounds.minX, y: bounds.maxY + 200, width: bounds.width, height: 200)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: "CollectionCell")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.centerXAnchor.constraint(equalTo: centerXAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            collectionView.heightAnchor.constraint(equalToConstant: 200),
            collectionView.widthAnchor.constraint(equalToConstant: bounds.width)
        ])
        
        addSubview(popupLabel)
        NSLayoutConstraint.activate([
            popupLabel.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -18),
            popupLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 18)
        ])
    }
    
    func showLoader(_ show: Bool) {
        self.endEditing(true)
        show ? hud.show(in: self) : hud.dismiss()
    }
}

//MARK: - UICollectionViewDataSource

extension CollectionsPopupView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (collections?.count ?? 0) + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        
        if let collections = collections {
            if indexPath.row == collections.count  {
                cell.collectionImageView.image = UIImage(systemName: "plus")
            } else {
                cell.collection = collections[indexPath.row]
            }
        }
        
        cell.backgroundColor = lightGrey
        return cell
    }
 
    
    func showCollectionNameAlert() {
        let alertController = UIAlertController(title: "Enter collection name", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Collection Name"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            if let collectionName = alertController.textFields?.first?.text {
                print("Entered collection name: \(collectionName)")
                let collection = Collection(name: collectionName, imageUrl: "", id: UUID().uuidString)
                self?.collectionViewModel?.saveToCollection(collection: collection) { [weak self] error in
                    if let error = error as? CollectionErrors {
                        let alertController = UIAlertController(title: "Error", message: error.errorMessage, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(okAction)
                        self?.delegate?.presentAlert(alert: alertController)
                        return
                    }
                    self?.collections?.append(collection)
                    self?.collectionView?.reloadData()
                }
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        if let topViewController = UIApplication.shared.keyWindow?.rootViewController {
            topViewController.present(alertController, animated: true, completion: nil)
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == collections?.count {
            showCollectionNameAlert()
        } else {
            if let collectionCell = collectionView.cellForItem(at: indexPath) as? CollectionCell {
                if let collection = collectionCell.collection {
                    saveToCollection(collection: collection)
                }
            }
        }
    }
    
    // API calls

    func fetchCollections() {
        collectionViewModel?.fetchCollections(completion: { [weak self] collections in
            DispatchQueue.main.async {
                self?.collections = collections
            }
        })
    }

    func saveToCollection(collection: Collection) {
        showLoader(true)
        CollectionService().saveRecipeToCollection(collection: collection, recipe: recipe) { [weak self] error in
            guard let self = self else { return }
            self.showLoader(false)
            delegate?.hidePopup()
        }
    }

}

//MARK: - UICollectionViewDelegateFlowLayout

extension CollectionsPopupView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}
