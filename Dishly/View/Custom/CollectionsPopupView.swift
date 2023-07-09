import UIKit

protocol CollectionsPopupViewDelegate {
    func fetchCollections()
    func createCollection()
    func saveToCollection()
}

class CollectionsPopupView: UIView {
    //MARK: - Properties
    
    private var collectionView: UICollectionView!
    
    var recipe: RecipeViewModel?
    
    var delegate: CollectionsPopupViewDelegate?
    
    var collectionViewModel: CollectionViewModel?
    
    private var collections: [Collection]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func didMoveToSuperview() {
        fetchCollections()
    }
    
    private let popupLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Choose a collection to save the recipe"
        label.textColor = .black
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
            popupLabel.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -6),
            popupLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 4)
        ])
    }
}

//MARK: - UICollectionViewDataSource

extension CollectionsPopupView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let collectionsNum = collections?.count {
            return collectionsNum + 1
        } else {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Dequeue and configure the collection view cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        
        if let collections = collections {
            
            if indexPath.row == collections.count  {
                cell.collectionImageView.image = UIImage(systemName: "plus")
            } else {
                cell.collection = collections[indexPath.row]
            }
        }
        cell.backgroundColor = .red
        return cell
    }
    
    func showCollectionNameAlert() {
        let alertController = UIAlertController(title: "Enter collection name", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Collection Name"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            if let collectionName = alertController.textFields?.first?.text {
                print("Entered collection name: \(collectionName)")
                let collection = Collection(name: collectionName, imageUrl: "", id: UUID().uuidString)
                self.collectionViewModel?.saveToCollection(collection: collection) { error in
                    print("SUCCESS")
                    self.collections!.append(collection)
                    self.collectionView!.reloadData()
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
        let collection = collectionView.cellForItem(at: indexPath) as! CollectionCell
        if indexPath.row == collections!.count {
            showCollectionNameAlert()
        } else {
            saveToCollection(collection: collection.collection! )
        }
    }
    
    func fetchCollections() {
        guard let collectionViewModel = collectionViewModel else { return }
        collectionViewModel.fetchCollections(completion: { collections in
            DispatchQueue.main.async {
                self.collections = collections
            }
        })
    }
    
    func saveToCollection(collection: Collection) {
        CollectionService().saveRecipeToCollection(collection: collection, recipe: recipe) { error in
            print("SUCCESS")
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
