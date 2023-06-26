
import Foundation

protocol RecipeService {
    func fetchRecipes(completion: @escaping ([Recipe]) -> Void)
}

class RemoteRecipeService: RecipeService {
    func fetchRecipes(completion: @escaping ([Recipe]) -> Void) {
        // Реализация фетчинга рецептов из удаленной базы данных
    }
}
