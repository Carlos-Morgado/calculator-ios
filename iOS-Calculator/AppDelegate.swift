//
//  AppDelegate.swift
//  iOS-Calculator
//
//  Created by Carlos Morgado on 7/2/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // SETUP
        setupView()
        
        return true
    }
    
    // PRIVATE METHODS
    private func setupView() { // Le vamos a indicar cuál será la primera vista de la app
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = HomeViewController() // Pantalla raíz, la primera pantalla
        window?.makeKeyAndVisible()
    }

}

