import UIKit
import JGProgressHUD

protocol PrepareViewControllerDelegate {
    func update()
}

class PrepareViewController: UIViewController, Storyboardable {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var saveButton: UIButton!
    
    private let hud = JGProgressHUD(style: .dark)
    
    var delegate: PrepareViewControllerDelegate?

    var recipeViewModel: RecipeViewModel?
    var recipeImage: UIImage!
    
    private var instructions = [Instruction]() {
        didSet {
            tableView.reloadData()
            recipeViewModel?.recipe.instructions = instructions
        }
    }
    
    //MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.textColor = isDark ? .white : .black
        view.backgroundColor = isDark ? AppColors.customGrey.color : AppColors.customLight.color
        contentView.backgroundColor = isDark ? AppColors.customGrey.color : AppColors.customLight.color
        tableView.backgroundColor = isDark ? AppColors.customGrey.color : AppColors.customLight.color
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        configureTableView()
    }
    
    //MARK: - Functions
    
    func showLoader(_ show: Bool) {
        view.endEditing(true )
        show ? hud.show(in: view) : hud.dismiss()
    }
    
    func updateUI() {
        guard let instructions = recipeViewModel?.recipe.instructions else { return }
        self.instructions = instructions
    }
    
    func saveRecipe() {
        showLoader(true)
        recipeViewModel?.createRecipe(image: recipeImage) { [weak self] error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let error = error {
                    self.showLoader(false)
                    print("DEBUG: Error creating recipe - \(error.localizedDescription)")
                    let alert = createErrorAlert(error: error.localizedDescription)
                    self.present(alert, animated: true)
                    return
                } else {
                    self.delegate?.update()
                    self.showLoader(false)
                    self.dismiss(animated: true)
                    print("DEBUG: Recipe created successfully")
                }
            }
            
        }
    }
    
    //MARK: - Button Taps
    
    @IBAction func addButtonClicked(_ sender: Any) {
        let newInstruction = Instruction()
        instructions.append(newInstruction)
        scrollView.layoutIfNeeded()
        let bottom = scrollView.contentSize.height - scrollView.bounds.height
        scrollView.setContentOffset(CGPoint(x: 0, y: bottom), animated: true)
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        saveRecipe()
    }
    
    var checkFieldValid: Bool {
        guard !instructions.isEmpty else {
            presentAlert(title: "Can not continue", message: "Please enter an instruction", completion: nil)
            return false
        }
        
        guard !(instructions.contains { ($0.text?.isEmpty ?? true) }) else {
            presentAlert(title: "Can not continue", message: "Please fill all instruction fields", completion: nil)
            return false
        }
        return true
    }
}

//MARK: - TableViewDelegates

extension PrepareViewController: UITableViewDelegate, UITableViewDataSource {
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: PrepareTableCell.identifier, bundle: nil), forCellReuseIdentifier: PrepareTableCell.identifier)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PrepareTableCell.identifier, for: indexPath) as? PrepareTableCell else {
            fatalError("Could not Load")
        }
        cell.tag = indexPath.row
        cell.configure(instruction: instructions[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instructions.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            instructions.remove(at: indexPath.row)
            scrollView.layoutIfNeeded()
        }
    }
}

//MARK: - PrepareCellDelegate

extension PrepareViewController: PrepareCellDelegate {
    func updateCell(textView: String?, cell: PrepareTableCell) {
        let row = cell.tag
        instructions[row].text = textView
        tableView.reloadData()
    }
}
