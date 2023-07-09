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
        
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "arrow.backward"), style: .plain, target: self, action: #selector(self.rightBarButtonTapped))
        self.navigationItem.leftBarButtonItem = leftBarButton
        
    }

    
    @objc func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func searchRecipes(with searchText: String) {
   
    }
    
   
    
    @objc func  rightBarButtonTapped() {
    }
    
}

//MARK: - UISearchResultsUpdating

extension RecipeSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        
        searchForRecipes(text: searchText) { recipes in
            self.recipes = recipes
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
    
    
    func searchForRecipes(text: String, completion: @escaping([RecipeViewModel]) -> ()) {
        COLLECTION_RECIPES.getDocuments { snapshot, error in
            var recipesArray: [RecipeViewModel] = []
            if let recipes = snapshot?.documents {
                for recipe in recipes {
                    let name = recipe.data()["name"] as? String ?? ""
                    
                    if name.starts(with: text) {
                        let recipeViewModel =  setRecipesConfiguration(recipe: recipe)
                        recipesArray.append(recipeViewModel)
                    }
                }
                completion(recipesArray)
            }
        }
    }
}


