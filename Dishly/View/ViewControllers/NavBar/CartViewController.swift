
import UIKit

private let tableCellReuseIdentifier = "IngredientTableCell"

class CartViewController: UIViewController {
    // MARK: - Properties
    
    private var isClearTapped = false
    
    var ingredients: [Ingredient]? {
        didSet { tableView.reloadData() }
    }
    
    private let itemCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "0 items"
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = AppColors.customGrey.color

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UINib(nibName: "IngredientTableCell", bundle: nil), forCellReuseIdentifier: tableCellReuseIdentifier)
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.customGrey.color

        tableView.delegate = self
        tableView.dataSource = self
        setupNavigationBar()
        setupUI()
    }
    
    // MARK: - Helpers
    
    private func setupNavigationBar() {
        navigationItem.title = "My Groceries"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: isDark ? UIColor.white : UIColor.black]

        navigationController?.navigationBar.prefersLargeTitles = true
        
        let rightButton = UIBarButtonItem(title: "Clear cart", style: .plain, target: self, action: #selector(rightButtonTapped))
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func setupUI() {

        view.addSubview(itemCountLabel)
        NSLayoutConstraint.activate([
            itemCountLabel.topAnchor.constraint(equalTo: view.topAnchor),
            itemCountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(tableView)
    
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.widthAnchor.constraint(equalToConstant: view.bounds.width - 20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    
    }
    
    //MARK: - Selectors
    
    @objc private func rightButtonTapped() {
        isClearTapped = true
        myGroceries = []
        UserDefaults.standard.removeObject(forKey: "customIngredients")
        tableView.reloadData()
        isClearTapped = false
    }
}

//MARK: - UITableViewDelegate & UITableViewDataSource

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var ingredientsCount = 0
        if let savedData = UserDefaults.standard.data(forKey: "customIngredients") {
            let decoder = JSONDecoder()
            if let loadedIngredients = try? decoder.decode([Ingredient].self, from: savedData) {
                ingredientsCount = loadedIngredients.count
                for ingredient in loadedIngredients {
                    print(ingredient.name ?? "")
                    print(ingredient.volume ?? "")
                    print(ingredient.portion ?? "")
                }
            }
        }
        return isClearTapped ? 0 : ingredientsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellReuseIdentifier, for: indexPath) as! IngredientTableCell
        cell.item.isUserInteractionEnabled = false
        cell.delegate = self
        cell.item.backgroundColor = .white
        if let savedData = UserDefaults.standard.data(forKey: "customIngredients") {
            let decoder = JSONDecoder()
            if let loadedIngredients = try? decoder.decode([Ingredient].self, from: savedData) {
                cell.configure(ingredient: loadedIngredients[indexPath.row])
            }
        }
        return cell
    }
}

//MARK: - IngredientCellDelegate

extension CartViewController: IngredientCellDelegate {
    func updateCell(itemName: String?, portion: PortionModel, cell: IngredientTableCell) {}
    func portionButtonTapped(cell: IngredientTableCell) {}

    func deleteCell(cell: IngredientTableCell) {
        guard let ingredientToDelete = cell.item.text else { return }
        myGroceries.removeAll { $0.name == ingredientToDelete }
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(myGroceries) {
            UserDefaults.standard.set(encodedData, forKey: "customIngredients")
        }
        tableView.reloadData()
    }
    
}

