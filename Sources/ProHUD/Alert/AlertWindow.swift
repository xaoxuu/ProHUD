//
//  AlertWindow.swift
//  
//
//  Created by xaoxuu on 2022/9/8.
//

import UIKit

extension Alert {
    var window: AlertWindow? {
        get {
            guard let windowScene = windowScene else {
                return nil
            }
            return AppContext.alertWindow[windowScene]
        }
        set {
            guard let windowScene = windowScene else {
                return
            }
            AppContext.alertWindow[windowScene] = newValue
        }
    }
}

class AlertWindow: Window {
    
    var alerts: [Alert] = []
    
    override var usingBackground: Bool { true }
    
    static func createAttachedWindowIfNotExists(config: Configuration) -> AlertWindow {
        let windowScene = AppContext.windowScene
        if let windowScene = windowScene, let w = AppContext.alertWindow[windowScene] {
            return w
        }
        let w: AlertWindow
        if let scene = windowScene {
            w = .init(windowScene: scene)
        } else {
            w = .init(frame: AppContext.appBounds)
        }
        if let windowScene = windowScene {
            AppContext.alertWindow[windowScene] = w
        }
        // 比原生alert层级低一点
        w.windowLevel = .init(rawValue: UIWindow.Level.alert.rawValue - 1)
        return w
    }
    
}
