//
//  CollectionCell.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 07.07.2023.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    //MARK: - Properties
    
    var collection: Collection? {
        didSet {
            configure()
        }
    }
    
    private let collectionImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .lightGray
        iv.layer.cornerRadius = 35
        iv.heightAnchor.constraint(equalToConstant: 70).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 70).isActive = true
        return iv
    }()
    
    private let collectionNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Favorites"
        label.textColor = .white
        return label
    }()
    
    func configure() {
        collectionNameLabel.text = collection!.name
    }
    
    //MARK: - Lifecycle
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
