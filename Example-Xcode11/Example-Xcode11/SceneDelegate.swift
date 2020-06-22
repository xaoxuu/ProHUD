//
//  SceneDelegate.swift
//  Example-Xcode11
//
//  Created by xaoxuu on 2020/6/15.
//  Copyright © 2020 xaoxuu. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        
        
        let rootVC = RootVC()
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        print("root window \(window!)")
        ProHUD.config { (cfg) in
//            cfg.rootViewController = rootVC
//            cfg.windowScene = scene
            cfg.alert { (a) in
                a.titleFont = .bold(22)
                a.bodyFont = .regular(17)
                a.boldTextFont = .bold(18)
                a.buttonFont = .bold(18)
                a.forceQuitTimer = 3
            }
            cfg.toast { (t) in
                t.titleFont = .bold(18)
                t.bodyFont = .regular(16)
            }
            cfg.guard { (g) in
                g.titleFont = .bold(22)
                g.subTitleFont = .bold(20)
                g.bodyFont = .regular(17)
                g.buttonFont = .bold(18)
            }
        }
        
        let window = UIWindow()
        window.makeKeyAndVisible()
        window.resignKey()
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}


extension ProHUD.Scene {
    static var confirm: ProHUD.Scene {
        var scene = ProHUD.Scene(identifier: "confirm")
        scene.image = UIImage(named: "ProHUDMessage")
        return scene
    }
    static var delete: ProHUD.Scene {
        var scene = ProHUD.Scene(identifier: "delete")
        scene.image = UIImage(named: "ProHUDTrash")
        scene.title = "确认删除"
        scene.message = "此操作不可撤销"
        return scene
    }
    static var buy: ProHUD.Scene {
        var scene = ProHUD.Scene(identifier: "buy")
        scene.image = UIImage(named: "ProHUDBuy")
        scene.title = "确认付款"
        scene.message = "一旦购买拒不退款"
        return scene
    }
}