//
//  AppDelegate.swift
//  GymondoTest
//
//  Created by Dmitry Shtryhel on 19.01.2024.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var mainCoordinator: BaseCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        mainCoordinator = MainCoordinator(window: window)
        
        mainCoordinator?.startFlow()
        
        return true
    }


}

