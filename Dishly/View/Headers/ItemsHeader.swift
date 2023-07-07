//
//  ItemsHeader.swift
//  Dishly-Test
//
//  Created by Vladimir Kovalev on 15.06.2023.
//

import UIKit

class ItemsHeader: UICollectionReusableView {
    //MARK: - Properties
    
    private var collections: [Collection]?
    
    private var collectionView: UICollectionView?
    
    private var numberOfItems = 8

    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCollectionView()
        backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.2117647059, blue: 0.2745098039, alpha: 1)
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
        
        collectionView!.backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.2117647059, blue: 0.2745098039, alpha: 1)
        collectionView!.register(CollectionCell.self, forCellWithReuseIdentifier: "TopCategoryCell")
        
        self.addSubview(collectionView!)
        
        
    }
}

extension ItemsHeader: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collections?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCategoryCell", for: indexPath) as! CollectionCell
        cell.backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.2117647059, blue: 0.2745098039, alpha: 1)
        
        if let collections = collections {
            cell.collection = collections[indexPath.row]
        }

        if indexPath.row == numberOfItems - 1 {
            cell.backgroundColor = .white
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == numberOfItems - 1 {
            print("Add collection")
        }
    }

}

extension ItemsHeader: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 100, height: 100)
        return size
    }
}

extension ItemsHeader: SavedVCProtocol {
    func reload(collections: [Collection]) {
        self.collections = collections
        collectionView?.reloadData()
    }
}
