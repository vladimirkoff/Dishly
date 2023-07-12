//
//  SearchViewControler.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 07.07.2023.
//

import UIKit
import Firebase
import FirebaseFirestore

class RecipeSearchViewController: UIViewController, UITextFieldDelegate {
    //MARK: - Properties
    
    private let recipesService: RecipeServiceProtocol!
    private var recipesViewModel: RecipesViewModel!
    
    private var recipes: [RecipeViewModel]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.2117647059, blue: 0.2745098039, alpha: 1)
        tableView.register(SearchTableCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    //MARK: - Lifecycle
    
    init(recipesService: RecipeServiceProtocol) {
        self.recipesService = recipesService
        recipesViewModel = RecipesViewModel(recipeService: recipesService)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.2117647059, blue: 0.2745098039, alpha: 1)
       
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск рецептов"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.barTintColor = .lightGray
        searchController.searchBar.tintColor = .white
        searchController.searchBar.searchTextField.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        
        view.addSubview(tableView)
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
        recipesViewModel.searchForRecipes(text: searchText) { [weak self] recipes, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let error = error {
                    let alert = createErrorAlert(error: error.localizedDescription)
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
            let vc = RecipeViewController(user: UserViewModel(user: User(dictionary: [:]), userService: nil)  , recipe: cell.recipe! )
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}


