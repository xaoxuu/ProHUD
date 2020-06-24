//
//  RootVC.swift
//  Example
//
//  Created by xaoxuu on 2019/8/12.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit
import ProHUD

class RootVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let vc = ViewController()
        let nav = UINavigationController(rootViewController: vc)
        addChild(nav)
        view.addSubview(nav.view)
        nav.view.frame = view.bounds
        if #available(iOS 11.0, *) {
            nav.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProHUD.Scene {
    
    static var delete: ProHUD.Scene {
        var scene = ProHUD.Scene(identifier: "prohud.delete")
        scene.image = UIImage(named: "prohud.trash")
        scene.title = "确认删除"
        scene.message = "此操作不可撤销"
        return scene
    }
    
    static var buy: ProHUD.Scene {
        var scene = ProHUD.Scene(identifier: "buy")
        scene.image = UIImage(named: "alert.buy")
        scene.title = "确认付款"
        scene.message = "一旦购买拒不退款"
        return scene
    }
    
    /// 重写的loading场景
    static var loading: ProHUD.Scene {
        var scene = ProHUD.Scene.init(identifier: "prohud.loading.rotate")
        scene.image = UIImage(named: "prohud.rainbow.circle")
        scene.title = "坐和放宽"
        scene.message = "正在处理一些事情"
        scene.alertDuration = 0
        scene.toastDuration = 0
        return scene
    }
    
    static var sync: ProHUD.Scene {
        var scene = ProHUD.Scene.init(identifier: "sync.rotate")
        scene.image = UIImage(named: "prohud.rainbow.circle")
        scene.title = "正在同步"
        scene.alertDuration = 0
        scene.toastDuration = 0
        return scene
    }
    static var sync2: ProHUD.Scene {
        var scene = ProHUD.Scene.init(identifier: "sync.rotate")
        scene.image = UIImage(named: "prohud.rainbow.circle")
        scene.alertDuration = 0
        scene.toastDuration = 0
        return scene
    }
    
}
