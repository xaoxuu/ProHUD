//
//  AlertWindow.swift
//  
//
//  Created by xaoxuu on 2022/9/8.
//

import UIKit

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
        w.windowLevel = .phAlert
        return w
    }
    
}

extension Alert {
    var attachedWindow: AlertWindow? {
        view.window as? AlertWindow
    }
}
