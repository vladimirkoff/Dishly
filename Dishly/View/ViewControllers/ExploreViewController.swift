import UIKit

class MainViewController: UIViewController {
    //MARK: - Properties
    
    var user: User
    var recipeViewModel: RecipeViewModel?
  
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        return searchController
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9333333333, blue: 0.8784313725, alpha: 1)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    
    //MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Helpers
    
    func configureAttributedString() -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "Hello, ", attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.white])
        attributedText.append(NSAttributedString(string: "Vladimir\n", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.green]))
        return attributedText
    }
    
    func configureUI() {
        view.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9333333333, blue: 0.8784313725, alpha: 1)
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "cart"), style: .plain, target: self, action: #selector(rightBarButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 1000)
        ])
        
        collectionView.register(ParentCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    //MARK: - Selectors
    
    @objc func rightBarButtonTapped() {
        // Handle right bar button tap event
    }
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // Implement your search functionality here
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ParentCell

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: view.frame.height / 2)
    }
}
