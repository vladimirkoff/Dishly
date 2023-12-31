//
//  ItemsHeader.swift
//  Dishly-Test
//
//  Created by Vladimir Kovalev on 15.06.2023.
//

import UIKit

protocol ItemsHeaderDelegate: AnyObject {
    func fecthRecipes(with collection: Collection)
    func createCollection(collection: Collection, completion: @escaping(Error?) -> ())
    func presentAlert(alert: UIAlertController)
    func showDeleteAlert(for: String)
}

class ItemsHeader: UICollectionReusableView {
    //MARK: - Properties
    
    var isFirsAppear = false
    
    private var previousCell: UICollectionViewCell!
    
    var selectedIndexPath: IndexPath? {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    let initialCellScale: CGFloat = 1.0
    let selectedCellScale: CGFloat = 0.9
    
    private var collections: [Collection]?
    
    var collectionView: UICollectionView?
    
    weak var delegate: ItemsHeaderDelegate?
    
    private let customBackground = CustomUIViewBackground()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configureCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: CGRect(x: self.frame.minX + 5, y: self.frame.minY, width: self.frame.width - 10, height: 100), collectionViewLayout: layout)
        
        collectionView!.delegate = self
        collectionView!.dataSource = self
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        collectionView!.addGestureRecognizer(longPressGesture)
        
        collectionView!.register(CollectionCell.self, forCellWithReuseIdentifier: "TopCategoryCell"
        )
        collectionView!.allowsSelection = true
        collectionView!.allowsMultipleSelection = false
        self.addSubview(collectionView!)
        
    }
    

    
    private func resetSelectedCellState() {
        if let indexPath = selectedIndexPath {
            if let cell = collectionView?.cellForItem(at: indexPath) as? CollectionCell {
                cell.transform = CGAffineTransform.identity
                cell.contentView.alpha = 1.0
            }
        }
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        guard let collectionView = collectionView else { return }
        if gestureRecognizer.state == .began {
            let point = gestureRecognizer.location(in: collectionView)
            
            if let indexPath = collectionView.indexPathForItem(at: point) {
                selectedIndexPath = indexPath
                collectionView.performBatchUpdates(nil, completion: nil)
                if let cell = collectionView.cellForItem(at: indexPath) as? CollectionCell {
                    delegate?.showDeleteAlert(for: cell.collection!.id)
                }
            }
        }
    }
    
    
}

//MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension ItemsHeader: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let collectionsNum = collections?.count {
            return collectionsNum + 1
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 4, bottom: 4, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCategoryCell", for: indexPath) as! CollectionCell
        
        if indexPath == selectedIndexPath {
            cell.transform = CGAffineTransform(scaleX: selectedCellScale, y: selectedCellScale)
            cell.contentView.alpha = 0.7
        } else {
            cell.transform = CGAffineTransform.identity
            cell.contentView.alpha = 1.0
        }
        
        if let collections = collections {
            if indexPath.row == collections.count  {
                cell.collectionNameLabel.text = "Create"
                let originalImage = UIImage(systemName: "plus")
                let scaleFactor: CGFloat = 2.0
                let scaledImageSize = CGSize(width: (originalImage?.size.width ?? 0.0) * scaleFactor,
                                             height: (originalImage?.size.height ?? 0.0) * scaleFactor)
                
                UIGraphicsBeginImageContextWithOptions(scaledImageSize, false, 0.0)
                originalImage?.draw(in: CGRect(origin: .zero, size: scaledImageSize))
                let smallerImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                cell.collectionImageView.image = smallerImage?.withRenderingMode(.alwaysTemplate)
                cell.collectionImageView.image = originalImage
                
                cell.collectionImageView.backgroundColor = AppColors.customLightGrey.color
                cell.collectionImageView.tintColor = .white
                cell.collectionImageView.contentMode = .center
                
            }
            else {
                if isFirsAppear {
                    if indexPath.row == 0 {
                        cell.collectionImageView.layer.borderWidth = 3
                        cell.collectionImageView.layer.borderColor = isDark ? UIColor.white.cgColor : AppColors.customBrown.color.cgColor
                        previousCell = cell
                        self.collectionView(collectionView, didSelectItemAt: indexPath)
                    }
                }
                cell.collection = collections[indexPath.row]
            }
        }
        isFirsAppear = false
        return cell
    }
    
    func showCollectionNameAlert() {
        guard let collections = collections else { return }
        
        let alertController = UIAlertController(title: "Enter collection name", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.delegate = self
            textField.placeholder = "Collection Name"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            if let collectionName = alertController.textFields?.first?.text {
                
                let collection = Collection(name: collectionName, imageUrl: "", id: UUID().uuidString)
                self.delegate?.createCollection(collection: collection) { error in
                    if let error = error as? CollectionErrors {
                        let alertController = UIAlertController(title: "Error", message: error.errorMessage, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(okAction)
                        self.delegate?.presentAlert(alert: alertController)
                        return
                    }
                    self.collections!.append(collection)
                    self.collectionView!.reloadData()
                }
                
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        if let topViewController = UIApplication.shared.keyWindow?.rootViewController {
            topViewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let collections = collections else { return }
        if let previousCell = previousCell as? CollectionCell {
            if indexPath.row != 0 {
                previousCell.collectionImageView.layer.borderWidth = 0
            }
        }
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionCell {
            previousCell = cell
            if indexPath.row == collections.count  {
                cell.collectionImageView.layer.borderWidth = 0
            } else {
                cell.collectionImageView.layer.borderWidth = 3
                cell.collectionImageView.layer.borderColor = isDark ? UIColor.white.cgColor : AppColors.customBrown.color.cgColor
            }
         }
        
        indexPath.row == collections.count ? showCollectionNameAlert() : delegate?.fecthRecipes(with: collections[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionCell {
            cell.collectionImageView.layer.borderWidth = 0
        }
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ItemsHeader: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 100, height: 100)
        return size
    }
}

//MARK: - SavedVCProtocol

extension ItemsHeader: SavedVCProtocol {
    func addRecipe(recipe: RecipeViewModel) {}

    func handleCancel() {
        selectedIndexPath = nil
        collectionView?.reloadData()
        collectionView?.performBatchUpdates(nil, completion: nil)
        resetSelectedCellState()
    }
    
    func reload(collections: [Collection], afterDeletion: Bool) {
        guard let collectionView = collectionView else { return }
        self.collections = collections
        if afterDeletion {
            collectionView.performBatchUpdates(nil, completion: nil)
        }
        collectionView.reloadData()
    }
}

//MARK: - UITextFieldDelegate

extension ItemsHeader: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        
        return newText.count > 15 ? false : true
    }
}


