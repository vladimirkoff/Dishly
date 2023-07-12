import UIKit

class SearchHeaderView: UICollectionReusableView {
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        addSubview(searchBar)
        searchBar.barTintColor = greyColor
        searchBar.tintColor = .white
        searchBar.searchTextField.backgroundColor = .white
        
        
        
        NSLayoutConstraint.activate([
            searchBar.centerXAnchor.constraint(equalTo: centerXAnchor),
            searchBar.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            searchBar.widthAnchor.constraint(equalToConstant: bounds.width)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
