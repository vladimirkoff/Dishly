

import UIKit
import FirebaseAuth

private let tableCellReuseId = "IngredientTableCell"
private let instrTableCellId = "PrepareTableCell"

final class RecipeViewController: UIViewController {
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
    
    private var user: UserViewModel!
    
    let scrollView = UIScrollView()
    let contentView = CustomUIViewBackground()
    
    private let tapToRateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tap to rate"
        label.setFont(name: "GillSans-SemiBold", size: 18)
        return label
    }()
    
    private let dishImage: UIImageView = {
        let image = UIImage(named: "" )
        let iv = UIImageView(image: image)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let cartSymbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)
        let cartSymbol = UIImage(systemName: "cart.fill", withConfiguration: cartSymbolConfig)
        
        button.setImage(cartSymbol, for: .normal)
        
        button.setTitle("Add to cart", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = isDark ? .white : AppColors.customBrown.color
        button.setTitleColor(isDark ? .black : .white, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.tintColor = isDark ? .black : .white
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var nameAndAythorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        view.layer.cornerRadius = 10
        view.backgroundColor = AppColors.additionalColor.color
        return view
    }()
    
    private lazy var profileView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let starsImages = UIImageView.generateStars()
    
    private let discriptionView: CustomUIViewBackground = {
        let view = CustomUIViewBackground()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let totalTimeView: CustomUIViewBackground = {
        let view = CustomUIViewBackground()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.text = "41min"
        return label
    }()
    
    private let totalTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.setFont(name: "GillSans-SemiBold", size: 18)
        label.text = "Total Time"
        return label
    }()
    
    private lazy var nameAndAuthorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.setFont(name: "GillSans-SemiBold", size: 24)
        label.attributedText = configureNameAndAuthorLabel(name: "Homemade Stuffing Width Sausage and Ham", author: "Vladimir")
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 30
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(UINib(nibName: "IngredientTableCell", bundle: nil), forCellReuseIdentifier: tableCellReuseId)
        tableView.delegate = self
        return tableView
    }()
    
    private let ingridientsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setFont(name: "GillSans-SemiBold", size: 32)
        label.text = "Ingridients"
        return label
    }()
    
    private let instructionsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setFont(name: "GillSans-SemiBold", size: 32)
        label.text = "Instructions"
        return label
    }()
    
    private let footerView: CustomUIViewBackground = {
        let view = CustomUIViewBackground()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setFont(name: "GillSans-SemiBold", size: 18)
        label.text = "4.5"
        return label
    }()
    
    let ratingsCount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "25 ratings"
        label.setFont(name: "GillSans-SemiBold", size: 18)
        label.textAlignment = .center
        return label
    }()
    
    private let profileImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        return iv
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.textColor = .white
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
        label.setFont(name: "GillSans-SemiBold", size: 18)
        label.text = "Dinners"
        return label
    }()
    
    private let serveLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setFont(name: "GillSans-SemiBold", size: 18)
        label.text = "4 serve"
        return label
    }()
    
    private lazy var instructionsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PrepareTableCell", bundle: nil), forCellReuseIdentifier: instrTableCellId)
        tableView.delegate = self
        return tableView
    }()
    
    private let chefHatImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "chef")
        return iv
    }()
    
    private let viewModel: RecipeVMProtocol
    
    //MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureTextColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = isDark ? AppColors.customGrey.color : AppColors.customLight.color
        title = "Recipe"
        configureUI()
        configure()
    }
    
    init(user: UserViewModel, recipe: RecipeViewModel, viewModel: RecipeVMProtocol) {
        self.recipeViewModel = recipe
        self.user = user
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helpers
    
    func configureNameAndAuthorLabel(name: String, author: String) -> NSAttributedString {
        let fontBig = UIFont(name: "GillSans-SemiBold", size: 22)!
        let fontSmall = UIFont(name: "GillSans-SemiBold", size: 18)!
        
        let attributedText = NSMutableAttributedString(string: "RECIPE\n", attributes: [.font: fontBig, .foregroundColor: UIColor.white])
        attributedText.append(NSAttributedString(string: "\n", attributes: [.font: fontSmall, .foregroundColor: UIColor.white]))
        attributedText.append(NSAttributedString(string: "\(name)\n", attributes: [.font: fontBig, .foregroundColor: UIColor.white]))
        attributedText.append(NSAttributedString(string: "\n", attributes: [.font: fontSmall, .foregroundColor: UIColor.white]))
        attributedText.append(NSAttributedString(string: "by \(author)", attributes: [.font: fontBig, .foregroundColor: UIColor.white]))
        return attributedText
    }
    
    func configure() {
        if !recipeViewModel.recipeImageUrl.isEmpty {
            if let url = URL(string: recipeViewModel.recipeImageUrl) {
                dishImage.sd_setImage(with: url)
            }
        } else {
            if let imageData = recipeViewModel.imageData {
                let image = UIImage(data: imageData)
                dishImage.image = image
            }
        }
        
        let authror = user.fullName.isEmpty ? recipeViewModel.user?.fullName ?? "" : user.fullName
        
        nameAndAuthorLabel.attributedText = configureNameAndAuthorLabel(name: recipeViewModel.name,
            author: authror)
        timeLabel.text = "\(recipeViewModel.cookTime) min"
        ratingLabel.text = "\(recipeViewModel.rating)"
        ratingsCount.text = "\(recipeViewModel.ratingList?.count ?? recipeViewModel.ratingNum) ratings"
        configureRatingImages(rating: Float(recipeViewModel.rating), imageViews: starsImages)
        categoryLabel.text = recipeViewModel.category.rawValue
        serveLabel.text = recipeViewModel.serve
        usernameLabel.text = user.username.isEmpty ? recipeViewModel.user?.username ?? "" : user.username
        
        if let url = URL(string: user.profileImage) {
            profileImage.sd_setImage(with: url)
        } else {
            if let data = recipeViewModel.user?.imageData {
                profileImage.image = UIImage(data: data)
            }
        }
    }
    
    func configureTextColor() {
        serveLabel.textColor = isDark ? .white : .black
        ratingLabel.textColor = isDark ? .white : .black
        categoryLabel.textColor = isDark ? .white : .black
        ratingsCount.textColor = isDark ? .white : .black
        ingridientsLabel.textColor = isDark ? .white : .black
        tapToRateLabel.textColor = isDark ? .white : .black
        instructionsLabel.textColor = isDark ? .white : .black
        nameAndAythorView.backgroundColor = isDark ? AppColors.customLightGrey.color : AppColors.customBrown.color
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
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        contentView.addSubview(dishImage)
        NSLayoutConstraint.activate([
            dishImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            dishImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dishImage.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            dishImage.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            dishImage.heightAnchor.constraint(equalToConstant: view.frame.height / 2 )
        ])
        
        contentView.addSubview(nameAndAythorView)
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
            addToCartButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 40),
            addToCartButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -40),
            addToCartButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        let stack = UIStackView(arrangedSubviews: starsImages)
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        
        contentView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: discriptionView.topAnchor, constant: 4),
            stack.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            stack.heightAnchor.constraint(equalToConstant: 40),
            stack.widthAnchor.constraint(equalToConstant: view.frame.width / 2)
        ])
        
        contentView.addSubview(ratingsCount)
        NSLayoutConstraint.activate([
            ratingsCount.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 4),
            ratingsCount.centerXAnchor.constraint(equalTo: stack.centerXAnchor)
        ])
        
        contentView.addSubview(ratingLabel)
        NSLayoutConstraint.activate([
            ratingLabel.rightAnchor.constraint(equalTo: stack.leftAnchor, constant: -4),
            ratingLabel.bottomAnchor.constraint(equalTo: stack.bottomAnchor)
        ])
        
        contentView.addSubview(profileView)
        NSLayoutConstraint.activate([
            profileView.bottomAnchor.constraint(equalTo: totalTimeView.topAnchor, constant: -18),
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
            
            profileView.addSubview(chefHatImage)
            NSLayoutConstraint.activate([
                chefHatImage.centerYAnchor.constraint(equalTo: profileView.centerYAnchor),
                chefHatImage.rightAnchor.constraint(equalTo: profileView.rightAnchor, constant: -8),
                chefHatImage.heightAnchor.constraint(equalToConstant: (heightConstant - 10) / 2 ),
                chefHatImage.widthAnchor.constraint(equalToConstant: (heightConstant - 10) / 2 )
            ])
        }
        
        
        profileView.addSubview(usernameLabel)
        NSLayoutConstraint.activate([
            usernameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            usernameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 4)
        ])
        
        
        contentView.addSubview(categoryImageView)
        NSLayoutConstraint.activate([
            categoryImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: -(view.bounds.width / 4)),
            categoryImageView.topAnchor.constraint(equalTo: ratingsCount.bottomAnchor, constant: 5)
        ])
        
        contentView.addSubview(serveImageView)
        NSLayoutConstraint.activate([
            serveImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: (view.bounds.width / 4)),
            serveImageView.topAnchor.constraint(equalTo: ratingsCount.bottomAnchor, constant: 5)
        ])
        
        contentView.addSubview(categoryLabel)
        NSLayoutConstraint.activate([
            categoryLabel.centerXAnchor.constraint(equalTo: categoryImageView.centerXAnchor),
            categoryLabel.topAnchor.constraint(equalTo: categoryImageView.bottomAnchor, constant: 2)
        ])
        
        contentView.addSubview(serveLabel)
        NSLayoutConstraint.activate([
            serveLabel.centerXAnchor.constraint(equalTo: serveImageView.centerXAnchor),
            serveLabel.topAnchor.constraint(equalTo: serveImageView.bottomAnchor, constant: 2)
        ])
        
        let starsStack = UIStackView()
        starsStack.axis = .horizontal
        starsStack.translatesAutoresizingMaskIntoConstraints = false
        starsStack.distribution = .fillEqually
        contentView.addSubview(starsStack)
        NSLayoutConstraint.activate([
            starsStack.rightAnchor.constraint(equalTo: footerView.rightAnchor, constant: -6),
            starsStack.topAnchor.constraint(equalTo: addToCartButton.bottomAnchor, constant: 32),
            starsStack.widthAnchor.constraint(equalToConstant: view.bounds.width / 1.8),
            starsStack.heightAnchor.constraint(equalToConstant:  50)
        ])
        
        footerView.addSubview(tapToRateLabel)
        NSLayoutConstraint.activate([
            tapToRateLabel.centerYAnchor.constraint(equalTo: starsStack.centerYAnchor),
            tapToRateLabel.leftAnchor.constraint(equalTo: footerView.leftAnchor, constant: 12)
        ])
        
        footerView.addSubview(instructionsLabel)
        NSLayoutConstraint.activate([
            instructionsLabel.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -4),
            instructionsLabel.leftAnchor.constraint(equalTo: footerView.leftAnchor, constant: 6)
        ])
        
        var starButtons: [UIButton] = []
        
        for i in 1...5 {
            let starButton = UIButton(type: .custom)
            
            starButton.setImage(UIImage(systemName: "star"), for: .normal)
            starButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
            
            starButton.tag = i
            starButton.tintColor = AppColors.goldenColor.color
            starButton.addTarget(self, action: #selector(starButtonTapped(_:)), for: .touchUpInside)
            starButton.translatesAutoresizingMaskIntoConstraints = false
            
            starButton.widthAnchor.constraint(equalToConstant: starSize).isActive = true
            starButton.heightAnchor.constraint(equalToConstant: starSize).isActive = true
            
            starsStack.addArrangedSubview(starButton)
            starButtons.append(starButton)
        }
        
        configureRatingStars()
        
        let height = 250 * recipeViewModel.instructions.count
        
        contentView.addSubview(instructionsTableView)
        NSLayoutConstraint.activate([
            instructionsTableView.topAnchor.constraint(equalTo: footerView.bottomAnchor, constant: 4),
            instructionsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            instructionsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            instructionsTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            instructionsTableView.heightAnchor.constraint(equalToConstant: CGFloat(height))
        ])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
        
        
    }
    
    func configureRatingStars() {
        viewModel.getOwnRate(recipeId: recipeViewModel.id) { rating in
            for i in 1...5 {
                if let starButton = self.view.viewWithTag(i) as? UIButton {
                    if rating < i {
                        starButton.isSelected = false
                    } else {
                        starButton.isSelected = true
                    }
                }
            }
        }
    }
    
    private func updateStarColors() {
        for i in 1...5 {
            if let starButton = view.viewWithTag(i) as? UIButton {
                if rating < i {
                    starButton.isSelected = false
                } else {
                    starButton.isSelected = true
                }
            }
        }
    }
    
    //MARK: - Selectors
    
    @objc func addToCartButtonTapped() {
        myGroceries += recipeViewModel.ingredients
        
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(myGroceries) {
            UserDefaults.standard.set(encodedData, forKey: "customIngredients")
        }
        
    }
    
    @objc private func starButtonTapped(_ sender: UIButton) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard var ratings = recipeViewModel.ratingList else { return }
        self.rating = sender.tag
        
        
        if let index = ratings.firstIndex(where: { $0.uid == uid }) {
            ratings[index].rating = Float(rating)
        } else {
            ratings.append(Rating(uid: uid, rating: Float(rating)))
        }
        
        var rateSum: Float = 0.0
        
        for rate in ratings {
            rateSum += rate.rating
        }
        
        
        let updatedRating = rateSum / Float(ratings.count)
        
        
        recipeViewModel.ratingList = ratings
        
        var ratingDict: [[String : Any]] = []
        
        for new in ratings {
            let id = new.uid
            let rat = new.rating
            
            let testt = ["uid" : id,
                         "rating" : rat
            ] as [String : Any]
            
            ratingDict.append(testt)
        }
        
        recipeViewModel.rating = updatedRating

        viewModel.updateRecipe(id: recipeViewModel.id, rating: updatedRating, numOfRating: ratings.count) { success in

        }

        let updatedData: [String : Any] = ["rating" : updatedRating,
                                           "numOfRatings" : ratingDict
        ]
        
        viewModel.updateRecipe(with: updatedData, recipe: recipeViewModel.id) { error in
            print("DEBUG: rating updated")
        }
    }
}

//MARK: - UITableViewDelegate & UITableViewDataSource

extension RecipeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return recipeViewModel.ingredients.count
        } else {
            return recipeViewModel.instructions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: tableCellReuseId, for: indexPath) as! IngredientTableCell
            cell.deleteButton.isHidden = true
            cell.item.isUserInteractionEnabled = false
            if let ingredients = recipeViewModel?.recipe.ingredients {
                cell.configure(ingredient: ingredients[indexPath.row])
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: instrTableCellId, for: indexPath) as! PrepareTableCell
            cell.textView.isUserInteractionEnabled = false
            cell.textView.backgroundColor = .white
            cell.instruction = recipeViewModel.instructions[indexPath.row]
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableView {
            return 70
        } else {
            return 250
        }
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

