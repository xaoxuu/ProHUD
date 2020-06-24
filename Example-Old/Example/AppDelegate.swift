//
//  AppDelegate.swift
//  Example
//
//  Created by xaoxuu on 2018/6/15.
//  Copyright © 2018 Titan Studio. All rights reserved.
//

import UIKit
import ProHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
 
        let vc = RootVC()
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        ProHUD.config { (cfg) in
            // 可自动获取根控制器，如果获取失败请主动设置此值
            // cfg.rootViewController = vc
            cfg.alert { (a) in
//                a.titleFont = .bold(22)
//                a.bodyFont = .regular(17)
//                a.boldTextFont = .bold(18)
//                a.buttonFont = .bold(18)
                a.forceQuitTimer = 5 // 多少秒后可以强制关闭弹窗（为了方便测试，一般不要设置这么小）
            }
//            cfg.toast { (t) in
//                t.titleFont = .bold(18)
//                t.bodyFont = .regular(16)
//                t.iconSize = .init(width: 42, height: 42)
//            }
//            cfg.guard { (g) in
//                g.titleFont = .bold(22)
//                g.subTitleFont = .bold(20)
//                g.bodyFont = .regular(17)
//                g.buttonFont = .bold(18)
//            }
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        NotificationCenter.default.post(name: NSNotification.Name.init("applicationDidEnterBackground"), object: nil)
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
