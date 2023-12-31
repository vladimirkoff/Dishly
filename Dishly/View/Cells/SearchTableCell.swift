//
//  SearchTableCell.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 07.07.2023.
//

import UIKit

class SearchTableCell: UITableViewCell {
    //MARK: - Properties
    
    var recipe: RecipeViewModel?
    
    var searchVariantLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = isDark ? .white : .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    var searchImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(systemName: "magnifyingglass")
        iv.tintColor = isDark ? .white : .black
        return iv
    }()
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configureCell() {
        backgroundColor = isDark ? AppColors.customGrey.color : AppColors.customLight.color

        
        addSubview(searchImageView)
        NSLayoutConstraint.activate([
            searchImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 4)
        ])
        
        addSubview(searchVariantLabel)
        NSLayoutConstraint.activate([
            searchVariantLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchVariantLabel.leftAnchor.constraint(equalTo: searchImageView.rightAnchor, constant: 4)
        ])
    }
    
}
