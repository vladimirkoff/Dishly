//
//  AppDelegate.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 14.06.2023.
//

import UIKit
import FirebaseCore
import RealmSwift
import FacebookCore
import FirebaseAuth
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
 
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        isDark = isDarkMode
        
        FirebaseApp.configure()
        
        if isDarkMode {
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
        } else {
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
        }
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        let config = Realm.Configuration(
            schemaVersion: 8,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 8 {
                    migration.enumerateObjects(ofType: UserRealm.className()) { _, newObject in
                        newObject?["isCurrentUser"] = nil
                    }
                }
            }
        )

        Realm.Configuration.defaultConfiguration = config
        
        do {
            let realm = try Realm()
        } catch {
            print("Failed to initialize Realm: \(error)")
        }
        
//        if let realmURL = Realm.Configuration.defaultConfiguration.fileURL {
//            print("Realm file path: \(realmURL.path)")
//
//        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

