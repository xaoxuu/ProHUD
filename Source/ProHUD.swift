//
//  ProHUD.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/23.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit

public class ProHUD {
    
    public static let shared = ProHUD()
    
    public var config: Configuration {
        return cfg
    }
    
    public struct Scene {
        private var id = "unknown"
        public var identifier: String {
            return id
        }
        public var image: UIImage?
        public var alertDuration: TimeInterval?
        public var toastDuration: TimeInterval? = 3
        public var title: String?
        public var message: String?
        init() {
            
        }
    }
    
}

// 默认场景
public extension ProHUD.Scene {
    init(identifier: String) {
        self.init()
        id = identifier
    }
    
    static var `default`: ProHUD.Scene {
        var scene = ProHUD.Scene.init(identifier: "default")
        scene.image = ProHUD.image(named: "prohud.message")
        return scene
    }
    static var loading: ProHUD.Scene {
        var scene = ProHUD.Scene.init(identifier: "loading")
        scene.alertDuration = 0
        scene.toastDuration = 0
        scene.image = ProHUD.image(named: "prohud.loading")
        return scene
    }
    static var success: ProHUD.Scene {
        var scene = ProHUD.Scene.init(identifier: "success")
        scene.alertDuration = 2
        scene.image = ProHUD.image(named: "prohud.success")
        return scene
    }
    static var warning: ProHUD.Scene {
        var scene = ProHUD.Scene.init(identifier: "warning")
        scene.alertDuration = 2
        scene.toastDuration = 5
        scene.image = ProHUD.image(named: "prohud.warning")
        return scene
    }
    static var error: ProHUD.Scene {
        var scene = ProHUD.Scene.init(identifier: "error")
        scene.alertDuration = 2
        scene.toastDuration = 5
        scene.image = ProHUD.image(named: "prohud.error")
        return scene
    }
    
    
}


// MARK: - Utilities

internal extension ProHUD {
    
    /// 获取Bundle
    static var bundle: Bundle {
        let path = Bundle(for: HUDController.self).path(forResource: "ProHUD", ofType: "bundle")
        return Bundle(path: path ?? "") ?? Bundle.main
    }
    
    /// 获取Image
    static func image(named: String) -> UIImage? {
        return UIImage(named: named) ?? UIImage(named: named, in: bundle, compatibleWith: nil)
    }
    
    
}


/// 是否是手机竖屏模式
internal var isPortrait: Bool {
    if UIDevice.current.userInterfaceIdiom == .phone {
        if UIApplication.shared.statusBarOrientation.isPortrait {
            debug("当前是手机竖屏模式")
            return true
        } else {
            debug("当前是手机横屏模式")
        }
    } else {
        debug("非手机设备（unspecified、iPad、tv、carPlay）")
    }
    return false
}

/// 可控Debug输出
internal func debug(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    if cfg.enablePrint {
        print(items, separator: separator, terminator: terminator)
    }
}

