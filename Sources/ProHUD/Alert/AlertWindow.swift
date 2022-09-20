//
//  AlertWindow.swift
//  
//
//  Created by xaoxuu on 2022/9/8.
//

import UIKit

class AlertWindow: Window {
    
    static var current: AlertWindow?
    
    static var alerts = [Alert]()
    
    override var usingBackground: Bool { true }
    
    static func attachedWindow(config: Configuration) -> AlertWindow {
        if let w = AlertWindow.current {
            return w
        }
        let w: AlertWindow
        if #available(iOS 13.0, *) {
            if let scene = config.windowScene ?? UIWindowScene.mainWindowScene {
                w = .init(windowScene: scene)
            } else {
                w = .init(frame: UIScreen.main.bounds)
            }
        } else {
            w = .init(frame: UIScreen.main.bounds)
        }
        AlertWindow.current = w
        // 比原生alert层级低一点
        w.windowLevel = .init(rawValue: UIWindow.Level.alert.rawValue - 1)
        return w
    }
    
}
