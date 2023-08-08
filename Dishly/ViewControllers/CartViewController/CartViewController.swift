
import UIKit

private let tableCellReuseIdentifier = "IngredientTableCell"

final class CartViewController: UIViewController {
    // MARK: - Properties
    
    private var isClearTapped = false
    
    var ingredients: [Ingredient]? {
        didSet { tableView.reloadData() }
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UINib(nibName: "IngredientTableCell", bundle: nil), forCellReuseIdentifier: tableCellReuseIdentifier)
        return tableView
    }()
    
    private var loadedIngredients: [Ingredient]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let customView = CustomUIViewBackground()
    
    private let viewModel: CartViewModel
    
    // MARK: - Lifecycle
    
    init(viewModel: CartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = isDark ? AppColors.customGrey.color : AppColors.customLight.color
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupNavigationBar()
        setupUI()
        fetchIngredients()
    }
    
    // MARK: - Helpers
    
    private func setupNavigationBar() {
        navigationItem.title = "My Groceries"
        let rightButton = UIBarButtonItem(title: "Clear cart", style: .plain, target: self, action: #selector(clearTapped))
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.widthAnchor.constraint(equalToConstant: view.bounds.width - 20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    
    }
    
    func fetchIngredients() {
        viewModel.getIngredients { result in
            switch result {
            case .success(let ingredients):
                self.loadedIngredients = ingredients
            case .failure(let error):
                self.showErrorAlert(error: error.localizedDescription)
            }
        }
    }
    
    func showErrorAlert(error: String) {
        let alert = Alerts.createErrorAlert(error: error)
        present(alert, animated: true)
    }
    
    
    //MARK: - Selectors
    
    @objc private func clearTapped() {
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
        return isClearTapped ? 0 : loadedIngredients?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellReuseIdentifier, for: indexPath) as! IngredientTableCell
        cell.item.isUserInteractionEnabled = false
        cell.delegate = self
        if let loadedIngredients = loadedIngredients {
            cell.configure(ingredient: loadedIngredients[indexPath.row])
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
        viewModel.saveIngredients { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success():
                self.fetchIngredients()
            case .failure(let error):
                self.showErrorAlert(error: error.localizedDescription)
            }
        }
    }
}

