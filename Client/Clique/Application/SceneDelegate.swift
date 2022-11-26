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
        let storyboard = UIStoryboard(name: "Register" , bundle:nil)
        let viewController = storyboard.instantiateInitialViewController()
        
        window = UIWindow(windowScene: windowScene)
        
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }

}

