
import UIKit

final class Router {
    
    static func showSignIn(from sourceVC: UIViewController) {
        let vc = createSignIn()
        sourceVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func showSignUp(from sourceVC: UIViewController) {
        let vc = Self.createSignUp()
        sourceVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func showSearch(from sourceVC: UIViewController) {
        let vc = Self.createSearch()
        sourceVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func showProfile(from sourceVC: UIViewController, with user: UserViewModel, image: UIImageView) {
        let vc = Self.createProfileScreen()
        vc.hidesBottomBarWhenPushed = true
        vc.user = user
        vc.profileImage = image
        sourceVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func showGreet(from sourceVC: UIViewController) {
        let vc = Self.createGreetScreen()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        sourceVC.present(nav, animated: true)
    }
    
    static func showCart(from sourceVC: UIViewController) {
        let vc = Self.createCartScreen()
        sourceVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func showAddRecipe(from sourceVC: UIViewController, for user: UserViewModel) {
        let vc = createAddRecipeScreen(user: user)
        vc.modalPresentationStyle = .formSheet
        sourceVC.navigationController?.present(vc, animated: true)
    }
    
    static func showPrepareRecipe(from sourceVC: UIViewController, recipe: RecipeViewModel, image: UIImage, user: UserViewModel) {
        let vc = Self.createPrepareScreen()
        vc.recipeImage = image
        vc.recipeViewModel = recipe
        if let nav = sourceVC.navigationController {
            nav.pushViewController(vc, animated: true)

        }
    }
    
    static func showMainTabBar(from sourceVC: UIViewController, with user: UserViewModel) {
        let vc = Self.createMainTabBarVC(with: user)
        sourceVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func showRecipe(from sourceVC: UIViewController, user: UserViewModel, recipe: RecipeViewModel) {
        let vc = Self.createRecipeScreen(with: user, recipe: recipe)
        sourceVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func showRecipes(from sourceVC: UIViewController, recipes: [RecipeViewModel]) {
        let vc = createRecipesScreen(exploreVC: sourceVC as! ExploreViewController, recipes: recipes)
        sourceVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func showEditProfile(from sourceVC: UIViewController, for user: UserViewModel, image: UIImageView) {
        let vc = Self.createEditProfileScreen(user: user, image: image)
        sourceVC.navigationController?.pushViewController(vc, animated: true)
    }
    
}

 private extension Router {
     
     static func createSearch() -> RecipeSearchViewController {
         
         let recipeService = DependencyContainer.shared.getRecipeService()
         
         let viewModel = SearchVM(recipeService: recipeService)
         let vc = RecipeSearchViewController(viewModel: viewModel)
         return vc
     }
     
     static func createSignUp() -> SignupController {
         
         let userService = DependencyContainer.shared.getUserService()
         let authService = DependencyContainer.shared.getAuthService(userService: userService)
         let userRealmService = DependencyContainer.shared.getUserRealmService()

         let viewModel = SignUpVM(authService: authService, userService: userService, userRealmService: userRealmService)
         let vc = SignupController(viewModel: viewModel)
         return vc
     }
     
     static func createSignIn() -> LoginViewController {
         
         let userService = DependencyContainer.shared.getUserService()
         let userRealmService = DependencyContainer.shared.getUserRealmService()
         let authService = DependencyContainer.shared.getAuthService(userService: userService)
                  
         let viewModel = SignInVM(authService: authService, userService: userService, userRealmService: userRealmService)
         let vc = LoginViewController(viewModel: viewModel)
         return vc
     }
     
     static func createEditProfileScreen(user: UserViewModel, image: UIImageView) -> EditProfileViewController {
         
         let userService = DependencyContainer.shared.getUserService()
         let userRealmService = DependencyContainer.shared.getUserRealmService()
         let authService = DependencyContainer.shared.getAuthService(userService: userService)
         
         let viewModel = EditProfileVM(userService: userService, userRealmService: userRealmService, authService: authService)
         let vc = EditProfileViewController(user: user, viewModel: viewModel, profileImage: image)
         return vc
     }
     
     static func createRecipesScreen(exploreVC: ExploreViewController, recipes: [RecipeViewModel]) -> RecipesViewController {
         
         let userService = DependencyContainer.shared.getUserService()
         
         let viewModel = RecipesVM(userService: userService)
         let vc = RecipesViewController(recipes: recipes, exploreVC: exploreVC, viewModel: viewModel)
         return vc
     }
     
     static func createRecipeScreen(with user: UserViewModel, recipe: RecipeViewModel) -> RecipeViewController {
         
         let recipeService = DependencyContainer.shared.getRecipeService()
         let recipesRealmService = DependencyContainer.shared.getRecipesRealmService()
         
         let viewModel = RecipeVMP(recipeService: recipeService, recipesRealmService: recipesRealmService)
         let vc = RecipeViewController(user: user, recipe: recipe, viewModel: viewModel)
         return vc
     }

    static func createProfileScreen() -> ProfileViewController {
        
        let userService = DependencyContainer.shared.getUserService()
        let authService = DependencyContainer.shared.getAuthService(userService: userService)
        let userRealmService = DependencyContainer.shared.getUserRealmService()
        
        let viewModel = ProfileVM(authService: authService, userService: userService, userRealmService: userRealmService)
        let vc = ProfileViewController(viewModel: viewModel )
        return vc
    }
     
     static func createGreetScreen() -> GreetViewController {
         
         let userService = DependencyContainer.shared.getUserService()
         let googleAuthService = DependencyContainer.shared.getGoogleAuthService(userService: userService)
         let userRealmService = DependencyContainer.shared.getUserRealmService()
         
         let viewModel = GreetVM(googleAuthService: googleAuthService, userRealmService: userRealmService)
         let vc = GreetViewController(viewModel: viewModel)
         vc.modalPresentationStyle = .fullScreen
         return vc
     }
     
     static func createCartScreen() -> CartViewController {
         let vc = CartViewController()
         return vc
     }
     
     static func createPrepareScreen() -> PrepareViewController {
         let vc = PrepareViewController.instantiateFromStoryboard()
         
         let recipeService = DependencyContainer.shared.getRecipeService()
         
         let viewModel = PrepareVM(recipeService: recipeService)
         
         vc.viewModel = viewModel
         
         return vc
     }
     
     static func createAddRecipeScreen(user: UserViewModel) -> UINavigationController {
         let vc = AddRecipeViewController.instantiateFromStoryboard()
         vc.user = user
         let nav = UINavigationController(rootViewController: vc)
         return nav
     }
     
     static func createMainTabBarVC(with user: UserViewModel) -> MainTabBarController {
         
         let recipeService = DependencyContainer.shared.getRecipeService()
         
         let viewModel = MainTabBarVM(recipeService: recipeService)
         let vc = MainTabBarController(viewModel: viewModel, user: user)
         return vc
     }

}

extension Router {
    
    static func createExploreVC(user: UserViewModel) -> ExploreViewController {
        
        let collectionService = DependencyContainer.shared.getCollectionService()
        let recipeService = DependencyContainer.shared.getRecipeService()
        let userService = DependencyContainer.shared.getUserService()
        
        let viewModel = ExploreVM(collectionService: collectionService, recipeService: recipeService, userService: userService)
        let vc = ExploreViewController(viewModel: viewModel, user: user)
        return vc
    }
    
    static func createSavedVC() -> SavedViewController {
        
        let collectionService = DependencyContainer.shared.getCollectionService()
        let userService = DependencyContainer.shared.getUserService()
        
        let viewModel = SavedVM(collectionService: collectionService, userService: userService)
        let vc = SavedViewController(viewModel: viewModel)
        return vc
    }
    
    static func createMealPlanVC() -> MealPlanVC {
        
        let mealsService = DependencyContainer.shared.getMealsService()
        let recipesRealmService = DependencyContainer.shared.getRecipesRealmService()
        
        let viewModel = MealPlanVM(recipesRealmService: recipesRealmService, mealsService: mealsService)
        let vc = MealPlanVC(viewModel: viewModel)
        return vc
    }
    
}
