

import UIKit

var isDark = true

func changeAppearance(isDarkMode: Bool, navigationController: UINavigationController) {
    
    let navBarAppearance = UINavigationBarAppearance()
     
    if isDarkMode {
        isDark = true
        navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = AppColors.customGrey.color
        UserDefaults.standard.set(isDark, forKey: "isDarkMode")
        UILabel.appearance().textColor = .white
        UIButton.appearance().setTitleColor(.white, for: .normal)
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
        BlackLabel.appearance().textColor = .white
        CustomButton.appearance().backgroundColor = .white
        CustomButton.appearance().setTitleColor(.black, for: .normal)
        UITextField.appearance().textColor = .black
    } else {
        isDark = false

        navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navBarAppearance.backgroundColor = AppColors.customLight.color
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        UISearchBar.appearance().barTintColor = AppColors.customLight.color
        UserDefaults.standard.set(isDark, forKey: "isDarkMode")
        UISearchBar.appearance().backgroundColor = .white
        UILabel.appearance().textColor = .black
        UIButton.appearance().setTitleColor(.white, for: .normal)
        UITextField.appearance().textColor = .white
        UITextField.appearance().backgroundColor = .white
        navigationController.navigationItem.rightBarButtonItem?.tintColor = AppColors.customPurple.color
        CustomButton.appearance().backgroundColor = AppColors.customPurple.color
        CustomUIViewBackground.appearance().backgroundColor = AppColors.customLight.color
        UICollectionView.appearance().backgroundColor = AppColors.customLight.color
        UICollectionViewCell.appearance().backgroundColor = AppColors.customPurple.color
        UICollectionReusableView.appearance().backgroundColor = AppColors.customLight.color
        UISearchBar.appearance().backgroundColor = AppColors.customLight.color
        navigationController.navigationItem.rightBarButtonItem?.tintColor = AppColors.customPurple.color
        navigationController.navigationBar.tintColor = AppColors.customPurple.color
        navigationController.navigationBar.backgroundColor = AppColors.customLight.color
        UITableView.appearance().backgroundColor = AppColors.customLight.color
        UIScrollView.appearance().backgroundColor = .clear
        CustomButton.appearance().setTitleColor(.black, for: .normal)
        BlackLabel.appearance().textColor = .black

    }
    navigationController.navigationBar.standardAppearance = navBarAppearance
    navigationController.navigationBar.scrollEdgeAppearance = navBarAppearance
}
    

