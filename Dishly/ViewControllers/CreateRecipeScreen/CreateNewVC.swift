

import UIKit

protocol AddRecipeViewControllerProtocol {
    func setPortion(portion: PortionModel)
}

final class AddRecipeViewController: UIViewController, Storyboardable {
    
    //MARK: - Properties
    
    @IBOutlet weak var continueButton: CustomButton!
    @IBOutlet weak var createRecipeLabel: UILabel!
    @IBOutlet weak var addIngredientButton: CustomButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var categoryButton: CustomButton!
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
    
    private var newImage: UIImage?
    
    private var portion: PortionModel?
        
    var user: UserViewModel!
    
    var delegate: AddRecipeViewControllerProtocol?
    
    private var ingredients = [Ingredient]() {
        didSet { tableView.reloadData() }
    }
    
    private var recipeViewModel: RecipeViewModel?
    
    //MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recipeNameField.backgroundColor = .white
        recipeNameField.textColor = .black
        createRecipeLabel.textColor = isDark ? .white : .black
        addIngredientButton.tintColor = isDark ? .white : .black
        addIngredientButton.setTitleColor(isDark ? .white : .black, for: .normal)
        continueButton.backgroundColor = isDark ? .white : AppColors.customBrown.color
        continueButton.setTitleColor(isDark ? UIColor.black : UIColor.white, for: .normal)
        continueButton.tintColor = isDark ? UIColor.black : UIColor.white
        categoryButton.backgroundColor = isDark ? .black : AppColors.customBrown.color
        categoryButton.setTitleColor(.white, for: .normal)
        recipeNameField.clipsToBounds = true
        recipeNameField.layer.cornerRadius = 20
        addIngredientButton.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = isDark ? AppColors.customGrey.color : AppColors.customLight.color
        contentView.backgroundColor = isDark ? AppColors.customGrey.color : AppColors.customLight.color

        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = cancelButton
        configureTableView()
        configureImagePicker()
        serveField.delegate = self
        cookTimeField.delegate = self
        
        
        configureTextFields(placeholder: "Recipe name", textField: recipeNameField)
        configureTextFields(placeholder: "Serve", textField: serveField)
        configureTextFields(placeholder: "Minutes", textField: cookTimeField)

        
    }
    
    //MARK: - Helpers
    
    func configureTextFields(placeholder: String, textField: UITextField) {
        let placeholderText = placeholder
        let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: textField == recipeNameField ? UIColor.lightGray : UIColor.white])
        textField.textColor = textField == recipeNameField ? .black : UIColor.white
        textField.attributedPlaceholder = attributedPlaceholder
        textField.backgroundColor = isDark ? AppColors.customLightGrey.color : AppColors.customBrown.color
    }
    
    func configurePickerView() {
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        categoryPickerView.contentMode = .top
        categoryPickerView.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width, height: 200)
        categoryPickerView.backgroundColor = UIColor.systemBackground
        
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .default
        toolBar.backgroundColor = isDark ? .black : .white
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        
        let barButton = UIBarButtonItem(image: UIImage(systemName: "checkmark.circle.fill"),
                                        style: .done, target: self, action: #selector(configureCategoryPV))
        spacer.width = UIScreen.main.bounds.size.width - barButton.width
        toolBar.items = [spacer, barButton]
        toolBar.sizeToFit()
        
        UIView.transition(with: self.view, duration: 0.5, options: [.transitionCrossDissolve] , animations: {
            self.view.addSubview(self.categoryPickerView)
            self.view.addSubview(self.toolBar)
        })
    }
    
    func configurePortionPickerView() {
        portionPickerView.delegate = self
        portionPickerView.dataSource = self
        portionPickerView.contentMode = .top
        portionPickerView.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width, height: 200)
        portionPickerView.backgroundColor = UIColor.systemBackground
        
        toolBar = UIToolbar(frame: CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .default
        toolBar.backgroundColor = isDark ? .black : .white
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(image: UIImage(systemName: "checkmark.circle.fill"),
                                        style: .done, target: self, action: #selector(configurePortionPV))
                
        toolBar.items = [spacer, barButton]
        toolBar.sizeToFit()
        
        UIView.transition(with: view, duration: 0.5, options: [.transitionCrossDissolve], animations: {
            self.view.addSubview(self.portionPickerView)
            self.view.addSubview(self.toolBar)
        })
    }
    
    
    func configureViewModel() {
        guard let selectedCategory = selectedCategory else {return}
        guard let title = recipeNameField.text else { return }
        guard let time = cookTimeField.text else { return }
        guard let serve = serveField.text else { return }
        
        let ingredients = self.ingredients
        let recipe = Recipe(ownerId: user.uid,
                            id: UUID().uuidString,
                            name: title,
                            serve: serve,
                            cookTime: time,
                            category: selectedCategory,
                            ingredients: ingredients,
                            instructions: [],
                            ratingList: []
        )
        self.recipeViewModel = RecipeViewModel(recipe: recipe, recipeService: RecipeService())
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
        print(ingredients)
        guard !ingredients.contains(where: { $0.name?.isEmpty ?? true || $0.volume == nil }) else {
            presentAlert(title: "Cannot continue", message: "Please fill all ingredient fields", completion: nil)
            return false
        }

        
        return true
        
    }
    
    //MARK: - Actions
    
    @IBAction func categoryButtonClicked(_ sender: Any) {
        configurePickerView()
    }
    
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
            Router.showPrepareRecipe(from: self, recipe: recipeViewModel!, image: foodImage.image!, user: user)
        }
    }
    
    @objc func close() {
        self.dismiss(animated: true)
    }
    
    @objc func configureCategoryPV() {
        categoryPickerView.removeFromSuperview()
        toolBar.removeFromSuperview()
    }
    
    @objc func configurePortionPV() {
        portionPickerView.removeFromSuperview()
        toolBar.removeFromSuperview()
        
        if let portion = portion {
            delegate?.setPortion(portion: portion)
        } else {
            let volumeRow = portionPickerView.selectedRow(inComponent: 0)
            let portionRow = portionPickerView.selectedRow(inComponent: 1)
            
            portion = PortionModel(name: "\(Recipe.Portion.allCases[portionRow])", volume: portionsMesures[volumeRow])
            delegate?.setPortion(portion: portion!)
        }
        
    }
    
    @objc func hidePickerView() {
        portionPickerView.removeFromSuperview()
    }
    
    @objc func imageTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
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
        self.delegate = cell
        cell.tag = indexPath.row
        cell.delegate = self
        cell.configure(ingredient: ingredients[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerTitle: UILabel = {
            let title = UILabel()
            title.text = "Ingredients"
            title.textColor = isDark ? .white : .black
            title.font = UIFont(name: "Gill Sans SemiBold", size: 22)
            return title
        }()
        return headerTitle
    }
}

// MARK: - TableCell Delegate

extension AddRecipeViewController: IngredientCellDelegate {
    
    func portionButtonTapped(cell: IngredientTableCell) {
        configurePortionPickerView()
    }
    
    func updateCell(itemName: String?, portion: PortionModel, cell: IngredientTableCell) {
        let row = cell.tag
        let ingredient = Ingredient(name: itemName, volume: portion.volume, portion: portion.name)
        ingredients[row] = ingredient
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

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }

        foodImage.image = selectedImage
        self.newImage = selectedImage
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - PickerView Delegate

extension AddRecipeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == portionPickerView {
            return 2
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoryPickerView {
            return Recipe.Category.allCases.count
        } else {
            if component == 0 {
                return 10
            } else {
                return Recipe.Portion.allCases.count
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == categoryPickerView {
            return Recipe.Category.allCases[row].rawValue
        } else {
            if component == 0 {
                if row <= portionsMesures.count {
                    return "\(portionsMesures[row])"
                } else {
                    return ""
                }
            } else {
                return "\(Recipe.Portion.allCases[row])"
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == categoryPickerView {
            selectedCategory = Recipe.Category.allCases[row]
            let buttonTitle = selectedCategory?.rawValue
            categoryButton.setTitle(buttonTitle, for: .normal)
        } else {
            let volumeRow = pickerView.selectedRow(inComponent: 0)
            let portionRow = pickerView.selectedRow(inComponent: 1)
            portion = PortionModel(name: "\(Recipe.Portion.allCases[portionRow])", volume: portionsMesures[volumeRow])
        }
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

