
import Foundation

protocol RecipeServiceProtocol {
    func fetchRecipes(completion: @escaping ([Recipe]) -> Void)
}

class RecipeService: RecipeServiceProtocol {
    
    static let shared = RecipeService()
    init() {}
    
    func fetchRecipes(completion: @escaping ([Recipe]) -> Void) {
        // Реализация фетчинга рецептов из удаленной базы данных
    }
}
