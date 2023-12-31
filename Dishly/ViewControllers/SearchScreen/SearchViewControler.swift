//
//  SearchViewControler.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 07.07.2023.
//

import UIKit
import Firebase
import FirebaseFirestore

final class RecipeSearchViewController: UIViewController, UITextFieldDelegate {
    //MARK: - Properties
    
    private var recipes: [RecipeViewModel]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SearchTableCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private let customView = CustomUIViewBackground()
    private let viewModel: SearchVMProtocol
    //MARK: - Lifecycle
    
    override func loadView() {
        view = customView
    }
    
    init(viewModel: SearchVMProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search recipes"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.tintColor = isDark ? .white : .black
        searchController.searchBar.searchTextField.backgroundColor = .white
        searchController.searchBar.searchTextField.textColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        
        customView.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    //MARK: - Selectors
    
    @objc func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

}

//MARK: - UISearchResultsUpdating

extension RecipeSearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.searchForRecipes(text: searchText) { [weak self] recipes, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let error = error {
                    let alert = Alerts.createErrorAlert(error: error.localizedDescription)
                    self.present(alert, animated: true)
                    return
                } else {
                    self.recipes = recipes!
                }
            }
        }
    }
}

//MARK: - UITableViewDelegate & UITableViewDataSource

extension RecipeSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchTableCell
        if let recipes = recipes {
            cell.recipe = recipes[indexPath.row]
            cell.searchVariantLabel.text = recipes[indexPath.row].recipe.name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SearchTableCell {
            if let recipe = cell.recipe {
                Router.showRecipe(from: self, user: UserViewModel(user: nil), recipe: recipe)
            }
        }
    }
    
}


