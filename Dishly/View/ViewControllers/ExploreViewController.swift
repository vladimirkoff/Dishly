
import UIKit

//private let reuseIdentifier = "FoodCell"
//private let headerReuseIdentifier = "MainHeader"

class MainViewController: UIViewController {
    //MARK: - Properties
    
//    var categoryModelsArray: [Category]? {
//        didSet { collectionView.reloadData() }
//    }
    
    lazy private var profileSubview: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.2117647059, blue: 0.2745098039, alpha: 1)
        return view
    }()
    
    lazy private var greetLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        let string = configureAttributedString()
         label.attributedText = string
         label.textAlignment = .left
         return label
     }()
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.backgroundColor = .black
        iv.isUserInteractionEnabled = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goToProfile))
        iv.addGestureRecognizer(gestureRecognizer)
        
        return iv
    }()
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
  
        configureUI()
      
    }
    
    //MARK: - Helpers
    
    func configureCollectionView() {
//        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: reuseIdentifier)
//        collectionView.register(MainHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
//        collectionView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9333333333, blue: 0.8784313725, alpha: 1)
    }

    func configureAttributedString() -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "Hello, ", attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.white])
        attributedText.append(NSAttributedString(string: "Vladimir\n", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.green]))
        return attributedText
    }
    
    func configureUI() {
        view.backgroundColor = .yellow
        navigationController?.navigationBar.isHidden = true
//        view.addSubview(profileSubview)
//        NSLayoutConstraint.activate([
//            profileSubview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            profileSubview.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            profileSubview.widthAnchor.constraint(equalToConstant: view.frame.width),
//            profileSubview.heightAnchor.constraint(equalToConstant: 120)
//        ])
//
//        view.addSubview(greetLabel)
//        NSLayoutConstraint.activate([
//            greetLabel.bottomAnchor.constraint(equalTo: profileSubview.bottomAnchor, constant: -8),
//            greetLabel.leftAnchor.constraint(equalTo: profileSubview.leftAnchor, constant: 8)
//        ])
//
//        view.addSubview(profileImageView)
//        NSLayoutConstraint.activate([
//            profileImageView.widthAnchor.constraint(equalToConstant: 50),
//            profileImageView.heightAnchor.constraint(equalToConstant: 50),
//            profileImageView.bottomAnchor.constraint(equalTo: profileSubview.bottomAnchor, constant: -6),
//            profileImageView.rightAnchor.constraint(equalTo: profileSubview.rightAnchor, constant: -4)
//        ])
//        profileImageView.layer.cornerRadius = 25
        
    }
    
    //MARK: - Selectors
    
   @objc func goToProfile() {
//       let vc = ProfileViewController(nibName: nil, bundle: nil)
//       navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UICollectionViewDelegate & UICollectionViewDataSource

//extension MainViewController: UICollectionViewDelegateFlowLayout {
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 4
//    }
    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryCell
////        if let categories = categoryModelsArray {
////            cell.categoryImageView.image = categories[indexPath.row].image
////            cell.nameLabel.text = categories[indexPath.row].name
////        }
//        return cell
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let size = CGSize(width: view.frame.width - 20, height: view.frame.height / 4)
//        return size
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: view.frame.width, height: 400)
//    }
    
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! MainHeader
//        header.delegate = self
//        header.points = user.points
//        return header
//    }
////
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////        let vc = ItemsViewController(collectionViewLayout: UICollectionViewFlowLayout())
////        navigationController?.pushViewController(vc, animated: true)
//    }
    












