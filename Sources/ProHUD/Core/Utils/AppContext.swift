//
//  AppContext.swift
//
//
//  Created by xaoxuu on 2023/8/5.
//

import UIKit

public struct AppContext {
    
    @available(iOS 13.0, *)
    private static var storedAppWindowScene: UIWindowScene?
    
    private static var storedAppWindow: UIWindow?
    
    private init() {}
    
}

public extension AppContext {
    
    @available(iOS 13.0, *)
    static var windowScene: UIWindowScene? {
        set { storedAppWindowScene = newValue }
        get {
            if let ws = storedAppWindowScene {
                return ws
            } else {
                return UIApplication.shared.connectedScenes.first(where: { scene in
                    guard let ws = scene as? UIWindowScene else { return false }
                    return ws.activationState == .foregroundActive
                }) as? UIWindowScene
            }
        }
    }
    
    /// 所有的窗口
    static var windows: [UIWindow] {
        if #available(iOS 13.0, *) {
            return windowScene?.windows ?? UIApplication.shared.windows
        } else {
            return UIApplication.shared.windows
        }
    }
    
    /// 可见的窗口
    static var visibleWindows: [UIWindow] {
        windows.filter { $0.isHidden == false }
    }
    
    /// App主程序窗口
    static var appWindow: UIWindow? {
        get {
            if let w = storedAppWindow {
                return w
            } else {
                return visibleWindows.filter { window in
                    return "\(type(of: window))" == "UIWindow" && window.windowLevel == .normal
                }.first
            }
        }
        set { storedAppWindow = newValue }
    }
    
    /// App主程序窗口的尺寸
    static var appBounds: CGRect {
        if #available(iOS 13.0, *) {
            return appWindow?.bounds ?? UIScreen.main.bounds
        } else {
            return UIScreen.main.bounds
        }
    }
    
    /// App主程序窗口的安全边距
    static var safeAreaInsets: UIEdgeInsets { appWindow?.safeAreaInsets ?? .zero }
    
}
