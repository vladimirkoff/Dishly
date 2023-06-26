
import Foundation

protocol RecipeService {
    func fetchRecipes(completion: @escaping ([Recipe]) -> Void)
    // Добавьте другие методы, связанные с работой с рецептами, по необходимости
}

class RemoteRecipeService: RecipeService {
    func fetchRecipes(completion: @escaping ([Recipe]) -> Void) {
        // Реализация фетчинга рецептов из удаленной базы данных
        // Вызовите completion с полученными рецептами
    }
}
