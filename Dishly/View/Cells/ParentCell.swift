import UIKit

class ParentCell: UICollectionViewCell {
    //MARK: - Properties
    
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
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.addSubview(horizontalCollectionView)
        configureCell()
        horizontalCollectionView.register(RecipeCell.self, forCellWithReuseIdentifier: "HorizontalCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configureCell() {
        backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9333333333, blue: 0.8784313725, alpha: 1)
    }
}

extension ParentCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalCell", for: indexPath) as! RecipeCell
        cell.backgroundColor = .red
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width * 3/4
        let height = collectionView.bounds.height - 10
        return CGSize(width: width, height: height)
    }
}

class HorizontalCell: UICollectionViewCell {
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
