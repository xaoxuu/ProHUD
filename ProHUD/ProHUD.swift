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
    
    internal var toasts = [Toast]()
    internal var alerts = [Alert]()
    
    internal var alertWindow: UIWindow?
    
    
}

// MARK: - Utilities

internal extension ProHUD {
    
    /// 获取Bundle
    static var bundle: Bundle {
        var b = Bundle.init(for: ProHUD.Alert.self)
        let p = b.path(forResource: "ProHUD", ofType: "bundle")
        if let bb = Bundle.init(path: p ?? "") {
            b = bb
        }
        return b
    }
    
    /// 获取Image
    static func image(named: String) -> UIImage? {
        return UIImage.init(named: named, in: bundle, compatibleWith: nil)
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
    if cfg.enableDebugPrint {
        debugPrint(items, separator: separator, terminator: terminator)
    }
}

