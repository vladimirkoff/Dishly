import UIKit

class ParentCell: UICollectionViewCell {
    //MARK: - Properties
    
    var isForCategories: Bool? {
        didSet {
            if let isForCategories = isForCategories {
                isForCategories ? configureCellForCategories() : configureCell()
            }
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: bounds.width - 20, height: 20))
        label.text = "Daily inspiration"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var horizontalCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: titleLabel.frame.maxY + 5, width: bounds.width, height: bounds.height - 40), collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .purple
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private lazy var categoryCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .red
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9333333333, blue: 0.8784313725, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    override func prepareForReuse() {
        super.prepareForReuse()
        horizontalCollectionView.isHidden = true
        categoryCollectionView.isHidden = true
    }
    
    func configureCell() {
        horizontalCollectionView.isHidden = false
        contentView.addSubview(titleLabel)
        contentView.addSubview(horizontalCollectionView)
        horizontalCollectionView.register(RecipeCell.self, forCellWithReuseIdentifier: "HorizontalCell")
    }
    
    func configureCellForCategories() {
        contentView.addSubview(categoryCollectionView)
        categoryCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        categoryCollectionView.isHidden = false
    }
}

extension ParentCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == horizontalCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalCell", for: indexPath) as! RecipeCell
            cell.backgroundColor = .red
            return cell
        } else if collectionView == categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            cell.backgroundColor = .yellow
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == horizontalCollectionView {
            print("Select recipe")
        } else if collectionView == categoryCollectionView {
            print("Select category")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == horizontalCollectionView {
            let width = collectionView.bounds.width * 3/4
            let height = collectionView.bounds.height - 10
            return CGSize(width: width, height: height)
        } else if collectionView == categoryCollectionView {
            let width = bounds.width / 2.2
            let height: CGFloat = 80
            return CGSize(width: width, height: height)
        }
        return CGSize.zero
    }
}



