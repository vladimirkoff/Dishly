import UIKit

class MealPlanVC: UIViewController {
    //MARK: - Properties
    
    private var mealsViewModel: MealsViewModel!
    private let recipesRealmViewModel: RecipesRealmViewModel!
    private let recipesRealmService: RecipesRealmServiceProtocol!
    
    var recipes: [String : [RecipeViewModel]]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var customView: CustomUIViewBackground!
    
    override func loadView() {
        customView = CustomUIViewBackground()
        view = customView
    }
    
    //MARK: - Lifecycle
    
    init(mealsService: MealsServiceProtocol, recipesRealmService: RecipesRealmServiceProtocol) {
        self.recipesRealmService = recipesRealmService
        mealsViewModel = MealsViewModel(mealsService: mealsService)
        recipesRealmViewModel = RecipesRealmViewModel(recipesRealmService: recipesRealmService)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(addRecipe(_:)), name: .addTriggered, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteRecipe(_:)), name: .deleteTriggered, object: nil)
        
        setupCollectionView()
        fecthRecipesForPlans()
    }
    
    //MARK: - Helpers
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MealCell.self, forCellWithReuseIdentifier: "MealCell")
        
        customView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

//MARK: - UICollectionViewDataSource & UICollectionViewDelegateFlowLayout

extension MealPlanVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealCell", for: indexPath) as! MealCell
        let dayOfWeek = DaysOfWeek.allCases[indexPath.row]
        cell.day = dayOfWeek
        if let recipes = recipes {
            cell.recipes = recipes[dayOfWeek.rawValue]
        }
        cell.delegate = self
        cell.dayLabel.text = dayOfWeek.rawValue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: 300)
    }
    

    
    func showDeleteAlert(for  id: String) {
        let alert = UIAlertController(title: "Delete recipe", message: "Are you sure you want to delete this recipe?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let logoutAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
            self.deleteRecipe(id: id)
        }
        alert.addAction(logoutAction)
        present(alert, animated: true, completion: nil)
    }
    
    func deleteRecipe(id: String) {
        recipesRealmViewModel.deleteRecipeRealm(id: id) { [weak self] success in
            guard let self = self else { return }
            if success {
                self.fecthRecipesForPlans()
            }
        }
    }
    
    //MARK: - DB calls
    
    func fecthRecipesForPlans() {
        recipesRealmViewModel.fecthRecipesRealm { recipesViewModels in
            var recipes: [RecipeViewModel] = []
            for day in DaysOfWeek.allCases {
                for recipe in recipesViewModels {
                    if recipe.recipe.day == day.rawValue {
                        recipes.append(recipe)
                    }
                }
                recipesForMealPlan[day.rawValue] = recipes
                recipes = []
            }
        }
        self.recipes = recipesForMealPlan
    }
    
    //MARK: - Selectors
    
    @objc func addRecipe(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let day = userInfo["day"] as? String, let recipe = userInfo["recipe"] as? RecipeViewModel {
                recipesRealmViewModel.addRecipeRealm(recipe: recipe, day: day) { success in
                    self.fecthRecipesForPlans()
                    return
                }
            }
        }
        
    }
    
    @objc func deleteRecipe(_ notification: Notification) {
        var id = ""
        if let userInfo = notification.userInfo {
            id = userInfo["id"] as? String ?? ""
            showDeleteAlert(for: id)
        }
    }
}

//MARK: - MealCellDelegate

extension MealPlanVC: MealCellDelegate {
    func goToRecipe(recipe: RecipeViewModel) {
        let vc = RecipeViewController(user: UserViewModel(user: nil, userService: UserService()), recipe: recipe, recipesRealmService: recipesRealmService)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func addRecipe(cell: MealCell) {
        let vc = SavedViewController(collectionService: CollectionService(), user: nil, recipesRealmService: recipesRealmService)
        vc.mealDelegate = cell
        vc.isToChoseMeal = true
        present(vc, animated: true)
    }
}

//MARK: - NotificationCenter

extension Notification.Name {
    static let addTriggered = Notification.Name("AddNotificationTriggered")
    static let deleteTriggered = Notification.Name("DeleteNotificationTriggered")
}
