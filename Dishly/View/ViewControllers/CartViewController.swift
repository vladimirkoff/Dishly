
import UIKit

class CartViewController: UIViewController {
    // MARK: - Properties
    
    private let itemCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "0 items"
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width - 20, height: 90)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: 200)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupUI()
    }
    
    // MARK: - Helpers
    
    private func setupNavigationBar() {
        navigationItem.title = "My Groceries"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(leftButtonTapped))
        navigationItem.leftBarButtonItem = leftButton
        
        let rightButton = UIBarButtonItem(title: "Right", style: .plain, target: self, action: #selector(rightButtonTapped))
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func setupUI() {

        view.addSubview(itemCountLabel)
        NSLayoutConstraint.activate([
            itemCountLabel.topAnchor.constraint(equalTo: view.topAnchor),
            itemCountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: itemCountLabel.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    //MARK: - Selectors
    
    @objc private func leftButtonTapped() {
        // Handle left button tap
    }
    
    @objc private func rightButtonTapped() {
        // Handle right button tap
    }
    
    @objc private func checkmarkButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        guard let cell = sender.superview as? UICollectionViewCell else {
            return
        }
        
        if sender.isSelected {
            cell.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        } else {
            cell.backgroundColor = .lightGray
        }
    }
}

// MARK: - UICollectionViewDataSource

extension CartViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .lightGray
        cell.layer.cornerRadius = 20
        
        let imageView = UIImageView(frame: CGRect(x: 5, y: (cell.bounds.height - 40) / 2, width: 60, height: 60))
        imageView.layer.cornerRadius = 30
        imageView.backgroundColor = .red 
        
        cell.addSubview(imageView)
        
        let attributedLabel = UILabel(frame: CGRect(x: imageView.frame.maxX + 30, y: (cell.bounds.height - 40) / 2, width: cell.bounds.width - imageView.frame.maxX - 30, height: 40))
        attributedLabel.textAlignment = .center
        
        let upperText = "Lemon"
        let lowerText = "1"
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: upperText, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]))
        attributedString.append(NSAttributedString(string: "\n"))
        attributedString.append(NSAttributedString(string: lowerText, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        attributedLabel.attributedText = attributedString
        
        cell.addSubview(attributedLabel)
        
        let checkmarkButton = UIButton(type: .custom)
        let buttonSize: CGFloat = 30
        checkmarkButton.frame = CGRect(x: cell.bounds.width - buttonSize - 10, y: (cell.bounds.height - buttonSize) / 2, width: buttonSize, height: buttonSize)
        checkmarkButton.setImage(UIImage(systemName: "circle"), for: .normal)
        checkmarkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        checkmarkButton.tintColor = .black
        checkmarkButton.addTarget(self, action: #selector(checkmarkButtonTapped(_:)), for: .touchUpInside)
        
        cell.addSubview(checkmarkButton)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
            headerView.backgroundColor = .white
            
            let addButton: UIButton = {
                let button = UIButton(type: .system)
                button.translatesAutoresizingMaskIntoConstraints = false
                button.setTitle("ADD YOUR OWN ITEMS", for: .normal)
                button.setImage(UIImage(systemName: "plus"), for: .normal)
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
                button.setTitleColor(.black, for: .normal)
                button.tintColor = .black
                button.semanticContentAttribute = .forceLeftToRight
                button.contentHorizontalAlignment = .leading
                button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
                
                button.layer.cornerRadius = 70
                
                NSLayoutConstraint.activate([
                    button.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
                    button.heightAnchor.constraint(equalToConstant: 50)
                ])
                
                return button
            }()
            
            headerView.addSubview(addButton)
            addButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
            addButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
            
            return headerView
        }
        
        return UICollectionReusableView()
    }
}

