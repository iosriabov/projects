//
//  AppDelegate.swift
//  LanguagesMemoCards
//
//  Created by Владимир Рябов on 23.03.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        
        let mainScreenViewController = MainScreenViewController()
        let cardViewController = CardViewController()
        let allWordsViewController = AllWordsViewController()
        let settingsViewController = SettingsViewController()
        
        mainScreenViewController.tabBarItem = UITabBarItem(title: "Title", image: UIImage(systemName: "house"), tag: 1)
        allWordsViewController.tabBarItem = UITabBarItem(title: "Список изученных", image: UIImage(systemName: "list.dash"), tag: 2)
        settingsViewController.tabBarItem = UITabBarItem(title: "Настройки", image: UIImage(systemName: "gear"), tag: 2)
        
        let scanNC = UINavigationController(rootViewController: mainScreenViewController)
        scanNC.navigationBar.tintColor = kBlueColor
        let orderNC = UINavigationController(rootViewController: cardViewController)
        orderNC.navigationBar.tintColor = kBlueColor
        let giftNC = UINavigationController(rootViewController: allWordsViewController)
        giftNC.navigationBar.tintColor = kBlueColor
        let settingsNC = UINavigationController(rootViewController: settingsViewController)
        settingsNC.navigationBar.tintColor = kBlueColor
        let tabBarController = UITabBarController()
        
        tabBarController.tabBar.tintColor = kBlueColor
        tabBarController.viewControllers = [scanNC, giftNC, settingsNC]
        window?.rootViewController = tabBarController
        return true
    }
}



