import UIKit
import JGProgressHUD

protocol CollectionsPopupViewDelegate {
    func hidePopup()
    func presentAlert(alert : UIAlertController)
    func fetchCollections()
    func saveToCollection(collection: Collection, recipe: RecipeViewModel, completion: @escaping(Error?) -> ())
    func addCollection(collection: Collection)
}

class CollectionsPopupView: UIView {
    //MARK: - Properties
    private let hud = JGProgressHUD(style: .dark)

    
    private var collectionView: UICollectionView!
    
    var recipe: RecipeViewModel?
        
    var delegate: CollectionsPopupViewDelegate?
    
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
        fetchCollections()
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

        cell.backgroundColor = .clear
        cell.collectionNameLabel.textColor = .white
        if let collections = collections {
           
            if indexPath.row == collections.count  {
                cell.collectionNameLabel.text = "Create"
                
                let originalImage = UIImage(systemName: "plus")
                let scaleFactor: CGFloat = 2.0
                  let scaledImageSize = CGSize(width: (originalImage?.size.width ?? 0.0) * scaleFactor,
                                               height: (originalImage?.size.height ?? 0.0) * scaleFactor)

                  UIGraphicsBeginImageContextWithOptions(scaledImageSize, false, 0.0)
                  originalImage?.draw(in: CGRect(origin: .zero, size: scaledImageSize))
                  let smallerImage = UIGraphicsGetImageFromCurrentImageContext()
                  UIGraphicsEndImageContext()
                cell.collectionImageView.image = smallerImage?.withRenderingMode(.alwaysTemplate)
                cell.collectionImageView.image = originalImage

                cell.collectionImageView.backgroundColor = AppColors.customGrey.color
                cell.collectionImageView.tintColor = .white
                cell.collectionImageView.contentMode = .center 
            } else {
                cell.collection = collections[indexPath.row]
            }
        }
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
                self?.showLoader(true)
                self?.delegate?.addCollection(collection: collection)
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
        delegate?.fetchCollections()
    }

    func saveToCollection(collection: Collection) {
        showLoader(true)
        guard let recipe = recipe else { return }
        delegate?.saveToCollection(collection: collection, recipe: recipe, completion: { error in
            self.showLoader(false)
        })
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

//MARK: - ExploreVCDelegate

extension CollectionsPopupView: ExploreVCDelegate {
    func appendCollection(collection: Collection) {
        showLoader(false)
        collections?.append(collection)
        collectionView?.reloadData()
    }
    
    
    func returnFetchedCollection(collections: [Collection]) {
        showLoader(false)
        self.collections = collections
    }
    
}
