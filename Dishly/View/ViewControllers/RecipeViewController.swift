

import UIKit

class RecipeViewController: UIViewController {
    //MARK: - Properties
    
    var recipeViewModel: RecipeViewModel!
    var recipeService: RecipeServiceProtocol!
    
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
        view.backgroundColor = .black
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
        view.backgroundColor = .red
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
        label.attributedText = configureNameAndAuthorLabel(name: "Homemade Stuffing Width Sausage and Ham", author: "Sidechef Everyday")
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 30
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
    
    
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        view.backgroundColor = .white
        
        recipeService = RecipeService.shared
        recipeViewModel = RecipeViewModel(recipeService: recipeService)
        
        setupNavigationBar()
        setupScrollView()
        configureUI()
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionView
    }()
    
    //MARK: - Helpers
    
    func configureNameAndAuthorLabel(name: String, author: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "RECIPE\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 18), .foregroundColor: UIColor.white])
        attributedText.append(NSAttributedString(string: "\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14), .foregroundColor: UIColor.white]))
        attributedText.append(NSAttributedString(string: "\(name)\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 18), .foregroundColor: UIColor.white]))
        attributedText.append(NSAttributedString(string: "\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14), .foregroundColor: UIColor.white]))
        attributedText.append(NSAttributedString(string: "by \(author)", attributes: [.font: UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor.lightGray]))
        return attributedText
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
            tableView.heightAnchor.constraint(equalToConstant: 15 * 70)
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
        
        footerView.addSubview(nutritionLabel)
        NSLayoutConstraint.activate([
            nutritionLabel.topAnchor.constraint(equalTo: addToCartButton.bottomAnchor, constant: 8),
            nutritionLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            nutritionLabel.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16)
        ])
        
        footerView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: nutritionLabel.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: footerView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: footerView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 50)
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
            stepByStepButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            stepByStepButton.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            stepByStepButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(leftButtonTapped))
        
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
        
    }
    
    @objc private func leftButtonTapped() {
        // Handle left button tap
    }
    
    @objc private func rightButton1Tapped() {
        // Handle right button 1 tap
    }
    
    @objc private func rightButton2Tapped() {
        // Handle right button 2 tap
    }
    
    @objc private func stepByStepButtonTapped() {
        // Handle step by step button tap
    }
}

//MARK: - UITableViewDelegate & UITableViewDataSource

extension RecipeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = "Cell \(indexPath.row + 1)"
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
