

import UIKit

class RecipeViewController: UIViewController {
    //MARK: - Properties
    
    private  var recipeViewModel: RecipeViewModel! {
        didSet {
            tableView.reloadData()
        }
    }
    
    let starSize: CGFloat = 50.0
    var rating: Int = 0 {
        didSet {
            updateStarColors()
        }
    }
    
    private  var recipeService: RecipeServiceProtocol!
    
    private var user: UserViewModel!
    
    private let dishImage: UIImageView = {
        let image = UIImage(named: "" )
        let iv = UIImageView(image: image)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let directionsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .yellow
        return view
    }()
    
    private let directionsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.text = "Directions"
        return label
    }()
    
    let stepByStepButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Step by step mode", for: .normal)
        button.setImage(UIImage(systemName: "play"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .black
        button.contentMode = .center
        button.semanticContentAttribute = .forceLeftToRight
        button.contentHorizontalAlignment = .leading
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        button.addTarget(self, action: #selector(stepByStepButtonTapped), for: .touchUpInside)
        
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 100
        
        
        return button
    }()
    
    let addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add to cart", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .green
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var nameAndAythorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var profileView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        view.layer.cornerRadius = 10
        return view
    }()
    
    let nutritionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "Nutrition per serving"
        return label
    }()
    
    private let discriptionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.2117647059, blue: 0.2745098039, alpha: 1)
        return view
    }()
    
    private let totalTimeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.cornerRadius = 15
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.text = "41min"
        return label
    }()
    
    private let totalTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .lightGray
        label.text = "Total Time"
        return label
    }()
    
    private lazy var nameAndAuthorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.attributedText = configureNameAndAuthorLabel(name: "Homemade Stuffing Width Sausage and Ham", author: "Vladimir")
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 30
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(UINib(nibName: "IngredientTableCell", bundle: nil), forCellReuseIdentifier: "IngredientCell")
        tableView.delegate = self
        return tableView
    }()
    
    private let ingridientsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.textColor = .black
        label.text = "Ingridients"
        return label
    }()
    
    private let footerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
//    let collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.minimumLineSpacing = 0
//
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.backgroundColor = .white
//        collectionView.showsHorizontalScrollIndicator = false
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
//        return collectionView
//    }()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    private var starImage1: UIImageView = {
        let image = UIImage(named: "star")
        let iv = UIImageView(image: image)
        return iv
    }()
    
    private var starImage2: UIImageView = {
        let image = UIImage(named: "star")
        let iv = UIImageView(image: image)
        return iv
    }()
    
    private var starImage3: UIImageView = {
        let image = UIImage(named: "star.filled")
        let iv = UIImageView(image: image)
        return iv
    }()
    
    private var starImage4: UIImageView = {
        let image = UIImage(named: "star.half.filled")
        let iv = UIImageView(image: image)
        return iv
    }()
    
    private var starImage5: UIImageView = {
        let image = UIImage(named: "star")
        let iv = UIImageView(image: image)
        return iv
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "4.5"
        return label
    }()
    
    let ratingsCount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "25 ratings"
        label.textAlignment = .center
        return label
    }()
    
    private let profileImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .red
        iv.clipsToBounds = true
        return iv
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.textColor = .black
        label.text = "@fdmvs"
        return label
    }()
    
    private let categoryImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "recipeBook")
        iv.heightAnchor.constraint(equalToConstant: 50).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 50).isActive = true
        return iv
    }()
    
    private let serveImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "serve")
        iv.heightAnchor.constraint(equalToConstant: 50).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 50).isActive = true
        return iv
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .black
        label.text = "Dinners"
        label.textColor = .white

        return label
    }()
    
    private let serveLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .black
        label.text = "4 serve"
        label.textColor = .white
        return label
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        collectionView.delegate = self
//        collectionView.dataSource = self
        view.backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.2117647059, blue: 0.2745098039, alpha: 1)
        
//        recipeViewModel = RecipeViewModel(recipeService: recipeService)
        
        setupNavigationBar()
        setupScrollView()
        configureUI()
        configure()
    }
    
    init(user: UserViewModel, recipe: RecipeViewModel) {
         self.recipeViewModel = recipe
         self.user = user
         super.init(nibName: nil, bundle: nil)
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    //MARK: - Helpers
    
    func configureNameAndAuthorLabel(name: String, author: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "RECIPE\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 18), .foregroundColor: UIColor.white])
        attributedText.append(NSAttributedString(string: "\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14), .foregroundColor: UIColor.white]))
        attributedText.append(NSAttributedString(string: "\(name)\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 18), .foregroundColor: UIColor.white]))
        attributedText.append(NSAttributedString(string: "\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14), .foregroundColor: UIColor.white]))
        attributedText.append(NSAttributedString(string: "by \(author)", attributes: [.font: UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor.lightGray]))
        return attributedText
    }
    
    func configure() {
        dishImage.sd_setImage(with: URL(string: recipeViewModel.recipe.recipeImageUrl!)!)
        nameAndAuthorLabel.attributedText = configureNameAndAuthorLabel(name: recipeViewModel.recipeName!, author: "Vladimir")
        timeLabel.text = "\(recipeViewModel.recipe.cookTime!) min"
        ratingLabel.text = "\(recipeViewModel.recipe.rating!)"
        ratingsCount.text = "\(recipeViewModel.recipe.ratingList!.count - 1) ratings"
        configureRatingImages(rating: Float(recipeViewModel.recipe.rating!), imageViews: [starImage1, starImage2, starImage3, starImage4, starImage5 ])
        categoryLabel.text = recipeViewModel.category
        serveLabel.text = recipeViewModel.recipe.serve
        usernameLabel.text = user.user!.username
        
        if let url = URL(string: user.user!.profileImage) {
            profileImage.sd_setImage(with: url)
        }
        
    }
    
    func configureRatingImages(rating: Float, imageViews: [UIImageView]) {
        let filledStarImage = UIImage(systemName: "star.fill")
        let halfFilledStarImage = UIImage(systemName: "star.lefthalf.fill")
        let emptyStarImage = UIImage(systemName: "star")

        let filledCount = Int(rating)
        let hasHalfStar = rating - Float(filledCount) >= 0.5

        for (index, imageView) in imageViews.enumerated() {
            if index < filledCount {
                imageView.image = filledStarImage
            } else if index == filledCount && hasHalfStar {
                imageView.image = halfFilledStarImage
            } else {
                imageView.image = emptyStarImage
            }
        }
    }
    
    private func configureUI() {
        view.addSubview(dishImage)
        NSLayoutConstraint.activate([
            dishImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            dishImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dishImage.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            dishImage.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            dishImage.heightAnchor.constraint(equalToConstant: view.frame.height / 2 )
        ])
        
        dishImage.addSubview(nameAndAythorView)
        NSLayoutConstraint.activate([
            nameAndAythorView.widthAnchor.constraint(equalToConstant: view.frame.width - 30),
            nameAndAythorView.heightAnchor.constraint(equalToConstant: view.frame.height / 6 ),
            nameAndAythorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameAndAythorView.centerYAnchor.constraint(equalTo: dishImage.bottomAnchor)
        ])
        
        contentView.addSubview(discriptionView)
        NSLayoutConstraint.activate([
            discriptionView.topAnchor.constraint(equalTo: nameAndAythorView.bottomAnchor),
            discriptionView.widthAnchor.constraint(equalToConstant: view.frame.width),
            discriptionView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            discriptionView.heightAnchor.constraint(equalToConstant: view.frame.height / 2)
        ])
        
        discriptionView.addSubview(totalTimeView)
        NSLayoutConstraint.activate([
            totalTimeView.widthAnchor.constraint(equalToConstant: view.frame.width - 30),
            totalTimeView.heightAnchor.constraint(equalToConstant: view.frame.height / 7),
            totalTimeView.centerXAnchor.constraint(equalTo: discriptionView.centerXAnchor),
            totalTimeView.bottomAnchor.constraint(equalTo: discriptionView.bottomAnchor, constant: -16)
        ])
        
        totalTimeView.addSubview(timeLabel)
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: totalTimeView.topAnchor, constant: 12),
            timeLabel.centerXAnchor.constraint(equalTo: totalTimeView.centerXAnchor)
        ])
        
        totalTimeView.addSubview(totalTimeLabel)
        NSLayoutConstraint.activate([
            totalTimeLabel.bottomAnchor.constraint(equalTo: totalTimeView.bottomAnchor , constant: -16),
            totalTimeLabel.centerXAnchor.constraint(equalTo: totalTimeView.centerXAnchor)
        ])
        
        nameAndAythorView.addSubview(nameAndAuthorLabel)
        NSLayoutConstraint.activate([
            nameAndAuthorLabel.centerXAnchor.constraint(equalTo: nameAndAythorView.centerXAnchor),
            nameAndAuthorLabel.centerYAnchor.constraint(equalTo: nameAndAythorView.centerYAnchor)
        ])
        
        contentView.addSubview(ingridientsLabel)
        NSLayoutConstraint.activate([
            ingridientsLabel.topAnchor.constraint(equalTo: discriptionView.bottomAnchor),
            ingridientsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16)
        ])
        
        contentView.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: ingridientsLabel.bottomAnchor),
            tableView.widthAnchor.constraint(equalToConstant: view.frame.width),
            tableView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(70 * recipeViewModel.ingredients.count))
        ])
        
        contentView.addSubview(footerView)
        NSLayoutConstraint.activate([
            footerView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            footerView.widthAnchor.constraint(equalToConstant: view.frame.width),
            footerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            footerView.heightAnchor.constraint(equalToConstant: view.frame.height / 4)
        ])
        
        footerView.addSubview(addToCartButton)
        NSLayoutConstraint.activate([
            addToCartButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 8),
            addToCartButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            addToCartButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
            addToCartButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        
        contentView.addSubview(directionsView)
        NSLayoutConstraint.activate([
            directionsView.topAnchor.constraint(equalTo: footerView.bottomAnchor, constant: 16),
            directionsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            directionsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            directionsView.heightAnchor.constraint(equalToConstant: 600)
        ])
        
        directionsView.addSubview(directionsLabel)
        NSLayoutConstraint.activate([
            directionsLabel.topAnchor.constraint(equalTo: directionsView.topAnchor, constant: 16),
            directionsLabel.leadingAnchor.constraint(equalTo: directionsView.leadingAnchor, constant: 16)
        ])
        
  
        
        directionsView.addSubview(stepByStepButton)
        NSLayoutConstraint.activate([
            stepByStepButton.topAnchor.constraint(equalTo: directionsLabel.bottomAnchor, constant: 8),
            stepByStepButton.centerXAnchor.constraint(equalTo: directionsView.centerXAnchor),
            stepByStepButton.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            stepByStepButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([

        ])
        
        let stack = UIStackView(arrangedSubviews: [ratingLabel, starImage1, starImage2, starImage3, starImage4, starImage5])
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: discriptionView.topAnchor, constant: 4),
            stack.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            stack.heightAnchor.constraint(equalToConstant: 40),
            stack.widthAnchor.constraint(equalToConstant: view.frame.width / 2)
        ])
        
        view.addSubview(ratingsCount)
        NSLayoutConstraint.activate([
            ratingsCount.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 4),
            ratingsCount.centerXAnchor.constraint(equalTo: stack.centerXAnchor)
        ])
        
        view.addSubview(profileView)
        NSLayoutConstraint.activate([
            profileView.bottomAnchor.constraint(equalTo: totalTimeView.topAnchor, constant: -16),
            profileView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            profileView.heightAnchor.constraint(equalToConstant: 100),
            profileView.widthAnchor.constraint(equalToConstant: view.bounds.width - 20)
        ])
        
        profileView.addSubview(profileImage)
        
        let heightAnchor = profileView.heightAnchor
        
        if let heightConstant = heightAnchor.retrieveCGFloat(from: profileView) {
            profileImage.layer.cornerRadius = (heightConstant - 10) / 2

            NSLayoutConstraint.activate([
                profileImage.centerYAnchor.constraint(equalTo: profileView.centerYAnchor),
                profileImage.leftAnchor.constraint(equalTo: profileView.leftAnchor, constant: 6),
                profileImage.heightAnchor.constraint(equalToConstant: heightConstant - 10),
                profileImage.widthAnchor.constraint(equalToConstant: heightConstant - 10)
            ])
        }

        
        profileView.addSubview(usernameLabel)
        NSLayoutConstraint.activate([
            usernameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            usernameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 4)
        ])
        
        view.addSubview(categoryImageView)
        NSLayoutConstraint.activate([
            categoryImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: -(view.bounds.width / 4)),
            categoryImageView.topAnchor.constraint(equalTo: ratingsCount.bottomAnchor, constant: 5)
        ])
        
        view.addSubview(serveImageView)
        NSLayoutConstraint.activate([
            serveImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: (view.bounds.width / 4)),
            serveImageView.topAnchor.constraint(equalTo: ratingsCount.bottomAnchor, constant: 5)
        ])
        
        view.addSubview(categoryLabel)
        NSLayoutConstraint.activate([
            categoryLabel.centerXAnchor.constraint(equalTo: categoryImageView.centerXAnchor),
            categoryLabel.topAnchor.constraint(equalTo: categoryImageView.bottomAnchor, constant: 2)
        ])
        
        view.addSubview(serveLabel)
        NSLayoutConstraint.activate([
            serveLabel.centerXAnchor.constraint(equalTo: serveImageView.centerXAnchor),
            serveLabel.topAnchor.constraint(equalTo: serveImageView.bottomAnchor, constant: 2)
        ])
        
//        let starImages = UIImageView.generateStars()
//
//        let starsStack = UIStackView(arrangedSubviews: starImages)
//        starsStack.axis = .horizontal
//        starsStack.translatesAutoresizingMaskIntoConstraints = false
//        starsStack.distribution = .fillEqually
//
//        footerView.addSubview(starsStack)
//        NSLayoutConstraint.activate([
//            starsStack.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
//            starsStack.topAnchor.constraint(equalTo: addToCartButton.bottomAnchor, constant: 12),
//            starsStack.widthAnchor.constraint(equalToConstant: view.bounds.width / 2),
//            starsStack.heightAnchor.constraint(equalToConstant:  40)
//        ])
        
        let starsStack = UIStackView()
        starsStack.axis = .horizontal
        starsStack.translatesAutoresizingMaskIntoConstraints = false
        starsStack.distribution = .fillEqually
        view.addSubview(starsStack)
        
        NSLayoutConstraint.activate([
            starsStack.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            starsStack.topAnchor.constraint(equalTo: addToCartButton.bottomAnchor, constant: 12),
            starsStack.widthAnchor.constraint(equalToConstant: view.bounds.width / 2),
            starsStack.heightAnchor.constraint(equalToConstant:  40)
        ])
        
        for i in 1...5 {
            let starButton = UIButton(type: .custom)
            
            starButton.setImage(UIImage(systemName: "star"), for: .normal)
            starButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
            
            starButton.tag = i
            starButton.tintColor = .yellow
            starButton.addTarget(self, action: #selector(starButtonTapped(_:)), for: .touchUpInside)
            starButton.translatesAutoresizingMaskIntoConstraints = false
            
            starButton.widthAnchor.constraint(equalToConstant: starSize).isActive = true
            starButton.heightAnchor.constraint(equalToConstant: starSize).isActive = true
            
            
            starsStack.addArrangedSubview(starButton)
        }
        
    }
    
    private func updateStarColors() {
        for i in 1...5 {
            if let starButton = view.viewWithTag(i) as? UIButton {
                starButton.isSelected = i <= rating
            }
        }
    }
    
//    func setRating(rating: Float) {
//        var currentRating = recipeViewModel.recipe.rating!
//        var currentRatingNum = Float(recipeViewModel.recipe.ratingList!.count)
//
//        currentRating += rating
//        currentRatingNum += 1
//
//        let updatedRating = currentRatingNum / currentRating
//
//        recipeService.updateRating(for: recipeViewModel, newRating: updatedRating) { error in
//            print("DEBUG: rating updated")
//        }
//    }

    private func setupNavigationBar() {
        let rightButton1 = UIBarButtonItem(image: UIImage(named: "save"), style: .plain, target: self, action: #selector(rightButton1Tapped))
        navigationItem.rightBarButtonItems = [rightButton1]
    }
    
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 4000)
        ])
    }
    
    //MARK: - Selectors
    
    @objc func addToCartButtonTapped() {
        myGroceries += recipeViewModel.ingredients
    }
    
 
    @objc private func rightButton1Tapped() {
        
    }
    
  
    @objc private func stepByStepButtonTapped() {
        
    }
    
    @objc private func starButtonTapped(_ sender: UIButton) {
        
        self.rating = sender.tag

        var currentRating = recipeViewModel.recipe.rating!
        var currentRatingNum = Float(recipeViewModel.recipe.ratingList!.count)
        
        currentRating += Float(rating)
        currentRatingNum += 1
        
        let updatedRating = currentRating / currentRatingNum
        
        var ratings = recipeViewModel.recipe.ratingList!
        ratings.append(Rating(uid: user.user!.uid, rating: Float(rating)))
        
        var test: [[String : Any]] = [[:]]
        
        for new in ratings {
            let id = new.uid
            let rat = new.rating
            
            let testt = ["uid" : id,
                         "rating" : rat
            ] as [String : Any]
            
            test.append(testt)
        }
        
        let updatedData: [String : Any] = ["rating" : updatedRating,
                                           "numOfRatings" : test
        ]
        
        RecipeService().updateRating(with: updatedData, for: recipeViewModel.recipe.id!) { error in
            print("DEBUG: rating updated")
        }
        
    }
}

//MARK: - UITableViewDelegate & UITableViewDataSource

extension RecipeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeViewModel.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as! IngredientTableCell
        cell.item.isUserInteractionEnabled = false
        if let ingredients = recipeViewModel?.ingredients {
            cell.configure(ingredient: ingredients[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}

//MARK: - UICollectionViewDataSource & UICollectionViewDelegateFlowLayout

extension RecipeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .white
        
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .red
        cell.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            separatorView.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
            separatorView.widthAnchor.constraint(equalToConstant: 1),
            separatorView.topAnchor.constraint(equalTo: cell.topAnchor),
            separatorView.bottomAnchor.constraint(equalTo: cell.bottomAnchor)
        ])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 4
        let height: CGFloat = 50
        return CGSize(width: width, height: height)
    }
}

