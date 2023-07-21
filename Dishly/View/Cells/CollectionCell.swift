//
//  CollectionCell.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 07.07.2023.
//

import UIKit
import SDWebImage

class CollectionCell: UICollectionViewCell {
    //MARK: - Properties
    
    var collection: Collection? {
        didSet { configure() }
    }
    
    var collectionImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .lightGray
        iv.layer.cornerRadius = 35
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.heightAnchor.constraint(equalToConstant: 70).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 70).isActive = true
        return iv
    }()
    
    let collectionNameLabel: CollectionLabel = {
        let label = CollectionLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        if let font = UIFont(name: "GillSans-SemiBold", size: 16) {
            label.font = font
        }
        return label
    }()
    
    func configure() {
        collectionNameLabel.text = collection?.name ?? "Error"
        
        if collection!.imageUrl == "" {
            collectionImageView.image = UIImage(named: "foodPlaceholder")
        } else {
            if let url = URL(string: collection!.imageUrl) {
                collectionImageView.sd_setImage(with: url)
            }
        }
    }
    
    //MARK: - Lifecycle
    
    override func prepareForReuse() {
        collectionImageView.contentMode = .scaleAspectFill
        collectionNameLabel.text = ""
        isSelected = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configureCell() {
        addSubview(collectionImageView)
        NSLayoutConstraint.activate([
            collectionImageView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            collectionImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        addSubview(collectionNameLabel)
        NSLayoutConstraint.activate([
            collectionNameLabel.topAnchor.constraint(equalTo: collectionImageView.bottomAnchor, constant: 2),
            collectionNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
