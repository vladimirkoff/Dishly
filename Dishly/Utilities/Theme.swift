

import UIKit

var isDark = true

func changeAppearance(isDarkMode: Bool, navigationController: UINavigationController) {
    
    let navBarAppearance = UINavigationBarAppearance()
    

    if isDarkMode {
        isDark = true

        
        UIBarButtonItem.appearance().tintColor = .white
        UIButton.appearance().setTitleColor(.white, for: .normal)
        UIButton.appearance().tintColor = .white
        CustomUICollectionViewCellBackground.appearance().backgroundColor = AppColors.customLightGrey.color

//        navigationController.navigationItem.rightBarButtonItem?.tintColor = .white
        CollectionLabel.appearance().textColor = .white
        TableLabel.appearance().textColor = .white
        navigationController.navigationBar.barStyle = .black
        navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = AppColors.customGrey.color
        UserDefaults.standard.set(isDark, forKey: "isDarkMode")
        UICollectionViewCell.appearance().backgroundColor = AppColors.customLightGrey.color
        UICollectionView.appearance().backgroundColor = AppColors.customGrey.color
        CustomUIViewBackground.appearance().backgroundColor = AppColors.customGrey.color
        UICollectionReusableView.appearance().backgroundColor = AppColors.customGrey.color
        UICollectionView.appearance().backgroundColor = AppColors.customGrey.color
        navigationController.navigationBar.tintColor = AppColors.customGrey.color
        navigationController.navigationBar.backgroundColor = AppColors.customGrey.color
        navigationController.navigationItem.rightBarButtonItem?.tintColor = .white
        UITableView.appearance().backgroundColor = AppColors.customGrey.color
        UIScrollView.appearance().backgroundColor = .clear
        UISearchBar.appearance().barTintColor = AppColors.customGrey.color
        navigationController.navigationBar.tintColor = .white
        UITextField.appearance().textColor = .black
        CustomButton.appearance().backgroundColor = .white
        CustomButton.appearance().tintColor = .black
        CustomButton.appearance().setTitleColor(.black, for: .normal)
        UISearchBar.appearance().backgroundColor = AppColors.customGrey.color
    

    } else {
        isDark = false
        UIBarButtonItem.appearance().tintColor = AppColors.customPurple.color
        UIButton.appearance().setTitleColor(.black, for: .normal)
        UIButton.appearance().tintColor = .black


        CollectionLabel.appearance().textColor = .black
        navigationController.navigationItem.rightBarButtonItem?.tintColor = AppColors.customPurple.color
        TableLabel.appearance().textColor = .black
        navigationController.navigationBar.barStyle = .default
        navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navBarAppearance.backgroundColor = AppColors.customLight.color
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        UISearchBar.appearance().barTintColor = AppColors.customLight.color
        UserDefaults.standard.set(isDark, forKey: "isDarkMode")
        UISearchBar.appearance().backgroundColor = .white
        UITextField.appearance().textColor = .black
        UITextField.appearance().backgroundColor = .white
        navigationController.navigationItem.rightBarButtonItem?.tintColor = AppColors.customPurple.color
        CustomButton.appearance().backgroundColor = AppColors.customPurple.color
        CustomUIViewBackground.appearance().backgroundColor = AppColors.customLight.color
//        CustomUIViewBackground.appearance().backgroundColor = AppColors.customLight.color
        UICollectionView.appearance().backgroundColor = AppColors.customLight.color
        
        UICollectionViewCell.appearance().backgroundColor = AppColors.customPurple.color
        CustomUICollectionViewCellBackground.appearance().backgroundColor = AppColors.customPurple.color
        
        UICollectionReusableView.appearance().backgroundColor = AppColors.customLight.color
        UISearchBar.appearance().backgroundColor = AppColors.customLight.color
        navigationController.navigationItem.rightBarButtonItem?.tintColor = AppColors.customPurple.color
        navigationController.navigationBar.tintColor = AppColors.customPurple.color
        navigationController.navigationBar.backgroundColor = AppColors.customLight.color
        UITableView.appearance().backgroundColor = AppColors.customLight.color
        UIScrollView.appearance().backgroundColor = .clear
        CustomButton.appearance().backgroundColor = AppColors.customPurple.color
        CustomButton.appearance().tintColor = .white
        CustomButton.appearance().setTitleColor(.white, for: .normal)
        UISearchBar.appearance().backgroundColor = AppColors.customLight.color

    }
    navigationController.navigationBar.standardAppearance = navBarAppearance
    navigationController.navigationBar.scrollEdgeAppearance = navBarAppearance
}
    

