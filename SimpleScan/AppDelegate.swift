//
//  AppDelegate.swift
//  BarcodeScannerExample
//
//  Created by Amelia While on 27/12/2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let entry = ViewController(nibName: nil, bundle: nil)
        let navVC = UINavigationController(rootViewController: entry)
        self.window?.rootViewController = navVC
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

