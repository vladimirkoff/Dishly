import UIKit

class MealPlanVC: UIViewController {
    //MARK: - Properties
    
    private var mealsViewModel: MealsViewModel!
    private let recipesRealmViewModel: RecipesRealmViewModel!
    
    var recipes: [String : [RecipeViewModel]]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = greyColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    //MARK: - Lifecycle
    
    init(mealsService: MealsServiceProtocol, recipesRealmService: RecipesRealmServiceProtocol) {
        mealsViewModel = MealsViewModel(mealsService: mealsService)
        recipesRealmViewModel = RecipesRealmViewModel(recipesRealmService: recipesRealmService)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        setupCollectionView()
        fecthRecipesForPlans()
    }
    
    //MARK: - Helpers
    
    private func configureNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Meal Plan"
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MealCell.self, forCellWithReuseIdentifier: "MealCell")
        
        view.addSubview(collectionView)
        
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
        cell.backgroundColor = greyColor
        cell.dayLabel.text = dayOfWeek.rawValue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: 300)
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
}

//MARK: - MealCellDelegate

extension MealPlanVC: MealCellDelegate {
    func goToRecipe(recipe: RecipeViewModel) {
        let vc = RecipeViewController(user: UserViewModel(user: nil, userService: UserService()), recipe: recipe)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func addRecipe(cell: MealCell) {
        let vc = SavedViewController(collectionService: CollectionService(), user: nil)
        vc.mealDelegate = cell
        vc.isToChoseMeal = true
        present(vc, animated: true)
    }
}



