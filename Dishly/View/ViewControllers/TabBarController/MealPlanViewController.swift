import UIKit

class MealPlanVC: UIViewController {
    //MARK: - Properties
    
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
    
    //MARK: - Selectors
    
}

//MARK: - UICollectionViewDataSource & UICollectionViewDelegateFlowLayout

extension MealPlanVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealCell", for: indexPath) as! MealCell
        let dayOfWeek = getDayOfWeek()[indexPath.row]
        
        cell.day = dayOfWeek
        if let recipes = recipes {
            cell.recipes = recipes[dayOfWeek.rawValue]
        }
        
        cell.delegate = self
        cell.backgroundColor = greyColor
        cell.dayLabel.text = getDayOfWeek()[indexPath.row].rawValue

        return cell
    }
    
    private func getDayOfWeek() -> [DaysOfWeek] {
        var days: [DaysOfWeek] = []
        for day in DaysOfWeek.allCases {
            days.append(day)
        }
        return days
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: 300)
    }
    
    func fecthRecipesForPlans() {
        RecipeService().fetchRecipesForPlans { complexRecipes in
            self.recipes = complexRecipes
        }
    }
}

//MARK: - MealCellDelegate

extension MealPlanVC: MealCellDelegate {
    func addRecipe(cell: MealCell) {
        let vc = SavedViewController(collectionService: CollectionService())
        vc.mealDelegate = cell
        vc.isToChoseMeal = true
        present(vc, animated: true)
    }
    
}



