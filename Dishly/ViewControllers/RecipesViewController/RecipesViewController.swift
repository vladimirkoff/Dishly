//
//  RecipesViewController.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 08.07.2023.
//

import UIKit

private let collectionCellReuseId = "RecipeCell"

final class RecipesViewController: UICollectionViewController {
    //MARK: - Properties
    
    private lazy var noRecipesView: NoRecipesView = {
          let view = NoRecipesView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
          view.translatesAutoresizingMaskIntoConstraints = false
          return view
      }()
    
    private var userViewModel: UserViewModel!
    
    private var recipes: [RecipeViewModel]? {
        didSet { collectionView.reloadData() }
    }
    
    var categoryName: String? {
        didSet {
            title = categoryName 
        }
    }
    
    private var exploreVC: ExploreViewController?
    private let viewModel: RecipesVMProtocol
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(RecipeCell.self, forCellWithReuseIdentifier: collectionCellReuseId)
    }
    
    init(recipes: [RecipeViewModel], exploreVC: ExploreViewController, viewModel: RecipesVMProtocol) {
        self.recipes = recipes
        self.exploreVC = exploreVC
        self.viewModel = viewModel
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func showNoRecipes() {
        view.addSubview(noRecipesView)
        NSLayoutConstraint.activate([
            noRecipesView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noRecipesView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noRecipesView.widthAnchor.constraint(equalToConstant: 300),
            noRecipesView.heightAnchor.constraint(equalToConstant: 300),
        ])
    }
    
    func goToRecipe(with recipe: RecipeViewModel) {
        viewModel.fetchUser(with: recipe.recipe.ownerId!) { user in
            Router.showRecipe(from: self, user: user, recipe: recipe)
        }
    }
}

//MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension RecipesViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let numOfRecipes = recipes?.count {
            if numOfRecipes == 0 {
                showNoRecipes()
            }
            return numOfRecipes
        } else {
            showNoRecipes()
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellReuseId, for: indexPath) as! RecipeCell
        cell.layer.cornerRadius = 15
        if let recipes = recipes, let exploreVC = exploreVC {
            cell.delegate = exploreVC as any RecipeCellDelegate
            cell.recipeViewModel = recipes[indexPath.row]
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? RecipeCell {
            if let recipeViewModel = cell.recipeViewModel {
                goToRecipe(with: recipeViewModel)
            }
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension RecipesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width / 2 - 10
        let height: CGFloat = view.bounds.height / 3
        return CGSize(width: width, height: height)
    }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return 20
     }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
          let inset = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
          return inset
      }
}
