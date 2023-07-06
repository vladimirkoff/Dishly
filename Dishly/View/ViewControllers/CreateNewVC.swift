

import UIKit

class AddRecipeViewController: UIViewController, Storyboardable {
    
    //MARK: - Properties
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var categoryButton: UIButton!
    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var foodImage: UIImageView!
    @IBOutlet private weak var pickerLogo: UIImageView!
    @IBOutlet private weak var serveImage: UIImageView!
    @IBOutlet private weak var cookTimeImage: UIImageView!
    @IBOutlet private weak var categoryImage: UIImageView!
    @IBOutlet private weak var recipeNameField: UITextField!
    @IBOutlet private weak var serveField: UITextField!
    @IBOutlet private weak var cookTimeField: UITextField!
    
    private var selectedCategory: Recipe.Category?
    private var categoryPickerView = UIPickerView()
    private var portionPickerView = UIPickerView()
    private var toolBar = UIToolbar()
    
    private var portion: Recipe.Portion?
    
    var recipeService: RecipeServiceProtocol!
    var user: User!
    
    private var ingredients = [Ingredient]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var recipeViewModel: RecipeViewModel?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.2117647059, blue: 0.2745098039, alpha: 1)
        tableView.backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.2117647059, blue: 0.2745098039, alpha: 1)
        scrollView.backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.2117647059, blue: 0.2745098039, alpha: 1)
        let closeButton = UIBarButtonItem(image: #imageLiteral(resourceName: "xmark"), style: .plain, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = closeButton
        //        hideKeyboard()
        configureTableView()
        configureImagePicker()
        serveField.delegate = self
        cookTimeField.delegate = self
    }
    
    //MARK: - Helpers
    
    
    func configureViewModel() {
        guard let selectedCategory = selectedCategory else {return}
        guard let title = recipeNameField.text else { return }
        guard let time = cookTimeField.text else { return }
        guard let serve = serveField.text else { return }
        let ingredients = self.ingredients
        
        if var recipeViewModel = recipeViewModel {
            recipeViewModel.recipe.name = title
            recipeViewModel.recipe.serve = serve
            recipeViewModel.recipe.cookTime = time
            recipeViewModel.recipe.ingredients = ingredients
            recipeViewModel.recipe.category = selectedCategory
        } else {
            let recipe = Recipe(ownerId: user.uid,
                                id: UUID().uuidString,
                                name: self.recipeNameField.text,
                                serve: self.serveField.text,
                                cookTime: self.cookTimeField.text,
                                category: selectedCategory,
                                ingredients: self.ingredients,
                                instructions: [],
                                ratingList: []
            )
            self.recipeViewModel = RecipeViewModel(recipe: recipe, recipeService: recipeService)
        }
    }
    
    var checkFieldValid: Bool {
        
        guard recipeNameField.hasText else {
            presentAlert(title: "Can not continue", message: "Please enter a Recipe name", completion: nil);
            return false
        }
        
        guard serveField.hasText else {
            presentAlert(title: "Can not continue", message: "Please fill serve field", completion: nil);
            return false
        }
        
        guard cookTimeField.hasText else {
            presentAlert(title: "Can not continue", message: "Please fill cook time field", completion: nil);
            return false
        }
        
        guard selectedCategory != nil else {
            presentAlert(title: "Can not continue", message: "Please select a category", completion: nil);
            return false
        }
        
        guard !ingredients.isEmpty else {
            presentAlert(title: "Can not continue", message: "Please enter an ingredient", completion: nil);
            return false
        }
        
        guard !(ingredients.contains { ($0.name?.isEmpty ?? true) }) else {
            presentAlert(title: "Can not continue", message: "Please fill all ingredient fields", completion: nil);
            return false
        }
        
        return true
        
    }
    
    //MARK: - Selectors
    
    @IBAction func addButtonClicked(_ sender: Any) {
        let newIngredient = Ingredient()
        ingredients.append(newIngredient)
        scrollView.layoutIfNeeded()
        let bottom = scrollView.contentSize.height - scrollView.bounds.height
        scrollView.setContentOffset(CGPoint(x: 0, y: bottom), animated: true)
    }
    
    @IBAction func continueClicked(_ sender: Any) {
        if checkFieldValid {
            configureViewModel()
            let vc = PrepareViewController.instantiateFromStoryboard()
            vc.recipeViewModel = recipeViewModel
            vc.recipeImage = foodImage.image
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func close() {
        self.dismiss(animated: true)
    }
    
}

// MARK: - Tableview Delegates

extension AddRecipeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: IngredientTableCell.identifier, bundle: nil),
                           forCellReuseIdentifier: IngredientTableCell.identifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IngredientTableCell.identifier, for: indexPath) as? IngredientTableCell else { fatalError("Could not Load")}
        
        cell.tag = indexPath.row
        cell.delegate = self
        cell.configure(ingredient: ingredients[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerTitle: UILabel = {
            let title = UILabel()
            title.text = "Ingredients"
            title.font = UIFont(name: "Gill Sans SemiBold", size: 20.0)
            return title
        }()
        return headerTitle
    }
}

// MARK: - TableCell Delegate

extension AddRecipeViewController: IngredientCellDelegate {
    
    func choosePortion() {
        
    }
    
    func updateCell(itemName: String?, cell: IngredientTableCell) {
        let row = cell.tag
        ingredients[row].name = itemName
    }
    
    func deleteCell(cell: IngredientTableCell) {
        let row = cell.tag
        ingredients.remove(at: row)
    }
}

// MARK: - ImagePickerDelegate

extension AddRecipeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func configureImagePicker() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        foodImage.addGestureRecognizer(gesture)
        foodImage.isUserInteractionEnabled = true
    }
    
    @objc func imageTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        foodImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - PickerView Delegate

extension AddRecipeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoryPickerView {
            return Recipe.Category.allCases.count
        } else {
            return Recipe.Portion.allCases.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == categoryPickerView {
            return Recipe.Category.allCases[row].rawValue
        } else {
            return "\(Recipe.Category.allCases[row])"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == categoryPickerView {
            selectedCategory = Recipe.Category.allCases[row]
            let buttonTitle = selectedCategory?.rawValue
            categoryButton.setTitle(buttonTitle, for: .normal)
        } else {
            portion = Recipe.Portion.allCases[row]
        }
    }
    
    @IBAction func categoryButtonClicked(_ sender: Any) {
        configurePickerView()
    }
    
    func configurePickerView() {
        
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        categoryPickerView.contentMode = .top
        categoryPickerView.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width, height: 200)
        categoryPickerView.backgroundColor = UIColor.systemBackground
        
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .default
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(image: UIImage(systemName: "checkmark.circle.fill"),
                                        style: .done, target: self, action: #selector(doneButtonTapped))
        
        spacer.width = UIScreen.main.bounds.size.width - barButton.width
        toolBar.items = [spacer, barButton]
        toolBar.sizeToFit()
        
        UIView.transition(with: self.view, duration: 0.5, options: [.transitionCrossDissolve] , animations: {
            self.view.addSubview(self.categoryPickerView)
            self.view.addSubview(self.toolBar)
        })
    }
    
    @objc func doneButtonTapped() {
        categoryPickerView.removeFromSuperview()
        toolBar.removeFromSuperview()
    }
}

// MARK: - TextField Delegate

extension AddRecipeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let onlyNumbers = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return onlyNumbers.isSuperset(of: characterSet)
    }
}

