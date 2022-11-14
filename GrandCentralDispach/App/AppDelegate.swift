//
//  AppDelegate.swift
//  GrandCentralDispach
//
//  Created by Александр Коробицын on 10.11.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let navVC = UINavigationController(rootViewController: ViewController())
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        return true
    }

}

