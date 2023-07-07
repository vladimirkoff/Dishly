
import UIKit

class CartViewController: UIViewController {
    // MARK: - Properties
    
    private var isClearTapped = false
    
    var ingredients: [Ingredient]? {
        didSet {
            tableView.reloadData()
        }
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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UINib(nibName: "IngredientTableCell", bundle: nil), forCellReuseIdentifier: "IngredientTableCell")
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        setupNavigationBar()
        setupUI()
    }
    
    // MARK: - Helpers
    
    private func setupNavigationBar() {
        navigationItem.title = "My Groceries"
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
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    
    }
    
    //MARK: - Selectors
    
    @objc private func rightButtonTapped() {
        isClearTapped = true
        myGroceries = []
        tableView.reloadData()
        isClearTapped = false
    }
    

}

//MARK: - UITableViewDelegate & UITableViewDataSource

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isClearTapped ? 0 : myGroceries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientTableCell", for: indexPath) as! IngredientTableCell
        cell.item.isUserInteractionEnabled = false
        cell.deleteButton.isHidden = true
        cell.configure(ingredient: myGroceries[indexPath.row])
        return cell
    }
}

