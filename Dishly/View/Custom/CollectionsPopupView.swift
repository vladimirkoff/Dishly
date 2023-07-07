import UIKit

class CollectionsPopupView: UIView {
    //MARK: - Properties
    
    private var collectionView: UICollectionView!
    
    var recipe: RecipeViewModel?
    
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
        // Create a UICollectionViewFlowLayout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        // Create the UICollectionView instance with the desired frame and layout
        let frame = CGRect(x: bounds.minX, y: bounds.maxY + 200, width: bounds.width, height: 200)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        
        // Register cell classes if needed
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: "CollectionCell")
        
        // Set the collection view's data source and delegate
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Add the collection view as a subview
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Dequeue and configure the collection view cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        cell.collection = Collection(name: "Breakfasts", imageUrl: "someUrl", id: "wfjkebeiuwgviwb")
        cell.backgroundColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let collection = collectionView.cellForItem(at: indexPath) as! CollectionCell
        saveToCollection(collection: collection.collection! )
    }
    
    func saveToCollection(collection: Collection) {
        RecipeService().saveRecipeToCollection(collection: collection, recipe: recipe!) { error in
            print("SAVED")
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension CollectionsPopupView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Specify the size of the collection view items
        return CGSize(width: 100, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        // Specify the minimum interitem spacing between collection view items
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // Specify the section insets for the collection view
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}
