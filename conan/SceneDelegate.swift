//
//  SceneDelegate.swift
//  conan
//
//  Created by iFable on 2025/6/27.
//  Copyright © 2025 iFable. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var coordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        let appCoordinator = AppCoordinator(incidentService: IncidentService())
        self.coordinator = appCoordinator
        let rootVC = CaseBookListViewController(caseBookService: CaseBookService(), coordinator: appCoordinator)
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
        self.window = window
    }

}
