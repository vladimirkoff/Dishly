//
//  ThemeManager.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 26.07.2023.
//

import UIKit

struct ThemeManager {
    
    enum Theme {
        case light
        case dark
    }
    
    // MARK: - Properties
    
    static var currentTheme: Theme {
        get {
            return isDarkModeEnabled() ? .dark : .light
        }
        set {
            UserDefaults.standard.set(newValue == .dark, forKey: "isDarkMode")
            applyTheme(newValue)
        }
    }
    
    // MARK: - Private Methods
    
    private static func isDarkModeEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: "isDarkMode")
    }
    
    private static func applyTheme(_ theme: Theme) {
        switch theme {
        case .light:
            setLightModeAppearance()
        case .dark:
            setDarkModeAppearance()
        }
    }
    
    private static func setLightModeAppearance() {
        UIApplication.shared.statusBarStyle = .default
        
        UINavigationBar.appearance().barStyle = .default
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        UINavigationBar.appearance().backgroundColor = AppColors.customLight.color
        UINavigationBar.appearance().tintColor = .black
        
        UIBarButtonItem.appearance().tintColor = AppColors.customBrown.color
        CustomUIViewBackground.appearance().backgroundColor = AppColors.customLight.color
        CustomButton.appearance().backgroundColor = AppColors.customBrown.color
        CustomButton.appearance().tintColor = .white
        CustomButton.appearance().setTitleColor(.white, for: .normal)
        CollectionLabel.appearance().textColor = .black
        CustomUICollectionViewCellBackground.appearance().backgroundColor = AppColors.customBrown.color
        UIButton.appearance().setTitleColor(.black, for: .normal)
        UIButton.appearance().tintColor = AppColors.customBrown.color
        TableLabel.appearance().textColor = .black
        UIScrollView.appearance().backgroundColor = .clear
        UITableView.appearance().backgroundColor = AppColors.customLight.color
        UICollectionView.appearance().backgroundColor = AppColors.customLight.color
        UISearchBar.appearance().backgroundColor = AppColors.customLight.color
        
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance()
            appearance.backgroundColor = .white
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
            UITabBar.appearance().tintColor = AppColors.customBrown.color
            UITabBar.appearance().isTranslucent = false
        } else {
            UITabBar.appearance().barTintColor = UIColor.red
            UITabBar.appearance().isTranslucent = false
        }
        
        UITabBar.appearance().backgroundColor = .white
        UITabBar.appearance().tintColor = AppColors.customBrown.color
        UITabBar.appearance().barTintColor = .yellow
        
        UISearchBar.appearance().barTintColor = AppColors.customLight.color
        
        CustomUIViewBackground.appearance().backgroundColor = AppColors.customLight.color
        
        UINavigationBar.appearance().barStyle = .default
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navBarAppearance.backgroundColor = AppColors.customLight.color
        
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        
        UICollectionViewCell.appearance().backgroundColor = AppColors.customBrown.color
        UICollectionView.appearance().backgroundColor = AppColors.customLight.color
        
        UICollectionReusableView.appearance().backgroundColor = AppColors.customLight.color
        
        UINavigationBar.appearance().tintColor = AppColors.customBrown.color
        
        UISearchBar.appearance().backgroundColor = AppColors.customLight.color

        
    }
    
    private static func setDarkModeAppearance() {
        UIApplication.shared.statusBarStyle = .lightContent
        
        CustomUIViewBackground.appearance().backgroundColor = AppColors.customGrey.color
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance()
            appearance.backgroundColor =  AppColors.customGrey.color
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
            UITabBar.appearance().tintColor = .white
            UITabBar.appearance().isTranslucent = false
        } else {
            UITabBar.appearance().barTintColor = .white
            UITabBar.appearance().isTranslucent = false
        }
        
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().backgroundColor = AppColors.customGrey.color
        UINavigationBar.appearance().tintColor = .white
        UIBarButtonItem.appearance().tintColor = .white
        CustomButton.appearance().backgroundColor = .white
        CustomButton.appearance().tintColor = .black
        CustomButton.appearance().setTitleColor(.black, for: .normal)
        CollectionLabel.appearance().textColor = .white
        CustomUICollectionViewCellBackground.appearance().backgroundColor = AppColors.customLightGrey.color
        UIButton.appearance().setTitleColor(.white, for: .normal)
        UIButton.appearance().tintColor = .white
        TableLabel.appearance().textColor = .white
        UIScrollView.appearance().backgroundColor = .clear
        UITableView.appearance().backgroundColor = AppColors.customGrey.color
        UICollectionView.appearance().backgroundColor = AppColors.customGrey.color
        UISearchBar.appearance().backgroundColor = AppColors.customGrey.color
        
        UITabBar.appearance().backgroundColor = AppColors.customGrey.color
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().barTintColor = .yellow
        
        UISearchBar.appearance().backgroundColor = AppColors.customGrey.color
        UISearchBar.appearance().barTintColor = AppColors.customGrey.color
        
        
        UICollectionViewCell.appearance().backgroundColor = AppColors.customLightGrey.color
        UICollectionView.appearance().backgroundColor = AppColors.customGrey.color
        UICollectionReusableView.appearance().backgroundColor = AppColors.customGrey.color
        UICollectionView.appearance().backgroundColor = AppColors.customGrey.color
        
        UINavigationBar.appearance().barStyle = .black
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = AppColors.customGrey.color
        
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        
        UINavigationBar.appearance().tintColor = .white
        UIBarButtonItem.appearance().tintColor = .white
    }
    
    static func applyCurrentTheme() {
        applyTheme(currentTheme)
    }
}


