//
//  SceneDelegate.swift
//  Clique
//
//  Created by Infinum on 30.10.2022..
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options
    connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        var storyboard = UIStoryboard(name: "Initial" , bundle: nil)
        var viewController = storyboard.instantiateInitialViewController()
        if UserStorage.token != nil {
            storyboard = UIStoryboard(name: "Profile" , bundle:nil)
            viewController = storyboard.instantiateInitialViewController()
        }else if UserStorage.token == nil {
            storyboard = UIStoryboard(name: "Initial" , bundle:nil)
            viewController = storyboard.instantiateInitialViewController()
        }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }

}

