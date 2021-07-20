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
    
    public var config: Configuration { cfg }
    
    
}

// MARK: - Scene
public extension ProHUD {
    
    struct Scene {
        public let identifier: String
        public var image: UIImage?
        public var alertDuration: TimeInterval?
        public var toastDuration: TimeInterval? = 3
        public var title: String?
        public var message: String?
        public init(identifier: String) {
            self.identifier = identifier
        }
    }
    
}

// 默认场景，可直接在项目工程中覆写场景参数
public extension ProHUD.Scene {
    static var `default`: ProHUD.Scene {
        var scene = ProHUD.Scene.init(identifier: "prohud.default")
        scene.image = ProHUD.image(named: "prohud.note")
        return scene
    }
    static var message: ProHUD.Scene {
        var scene = ProHUD.Scene.init(identifier: "prohud.message")
        scene.image = ProHUD.image(named: "prohud.message")
        scene.alertDuration = 2
        scene.toastDuration = 5
        return scene
    }
    static var loading: ProHUD.Scene {
        var scene = ProHUD.Scene.init(identifier: "prohud.loading.rotate")
        scene.image = ProHUD.image(named: "prohud.rainbow.circle")
        scene.title = "Loading"
        scene.alertDuration = 0
        scene.toastDuration = 0
        return scene
    }
    static var success: ProHUD.Scene {
        var scene = ProHUD.Scene.init(identifier: "prohud.success")
        scene.image = ProHUD.image(named: "prohud.checkmark")
        scene.title = "Success"
        scene.alertDuration = 2
        return scene
    }
    static var warning: ProHUD.Scene {
        var scene = ProHUD.Scene.init(identifier: "prohud.warning")
        scene.image = ProHUD.image(named: "prohud.exclamationmark")
        scene.title = "Warning"
        scene.message = "Something happened."
        scene.alertDuration = 2
        scene.toastDuration = 5
        return scene
    }
    static var error: ProHUD.Scene {
        var scene = ProHUD.Scene.init(identifier: "prohud.error")
        scene.image = ProHUD.image(named: "prohud.xmark")
        scene.title = "Error"
        scene.message = "Please try again later."
        scene.alertDuration = 2
        scene.toastDuration = 5
        return scene
    }
    static var failure: ProHUD.Scene {
        var scene = ProHUD.Scene.init(identifier: "prohud.failure")
        scene.image = ProHUD.image(named: "prohud.xmark")
        scene.title = "Failure"
        scene.message = "Please try again later."
        scene.alertDuration = 2
        scene.toastDuration = 5
        return scene
    }
    static var confirm: ProHUD.Scene {
        var scene = ProHUD.Scene.init(identifier: "prohud.confirm")
        scene.image = ProHUD.image(named: "prohud.questionmark")
        scene.alertDuration = 2
        scene.toastDuration = 5
        return scene
    }
    static var privacy: ProHUD.Scene {
        var scene = ProHUD.Scene.init(identifier: "prohud.privacy")
        scene.image = ProHUD.image(named: "prohud.privacy")
        scene.alertDuration = 2
        scene.toastDuration = 5
        return scene
    }
    static var delete: ProHUD.Scene {
        var scene = ProHUD.Scene.init(identifier: "prohud.delete")
        scene.image = ProHUD.image(named: "prohud.trash")
        scene.alertDuration = 2
        scene.toastDuration = 5
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

