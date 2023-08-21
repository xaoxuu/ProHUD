//
//  AppContext.swift
//
//
//  Created by xaoxuu on 2023/8/5.
//

import UIKit

public protocol Workspace {}

extension UIWindowScene: Workspace {}
extension UIView: Workspace {}
extension UIViewController: Workspace {}

extension Workspace {
    var windowScene: UIWindowScene? {
        if let self = self as? UIWindowScene {
            return self
        } else if let self = self as? UIWindow {
            return self.windowScene
        } else if let self = self as? UIView {
            return self.window?.windowScene
        } else if let self = self as? UIViewController {
            return self.view.window?.windowScene
        }
        return nil
    }
}

public struct AppContext {
    
    private static var storedAppWindowScene: UIWindowScene?
    
    /// 一个scene关联一个toast
    static var toastWindows: [UIWindowScene: [ToastWindow]] = [:]
    static var alertWindow: [UIWindowScene: AlertWindow] = [:]
    static var sheetWindows: [UIWindowScene: [SheetWindow]] = [:]
    static var capsuleWindows: [UIWindowScene: [CapsuleViewModel.Position: CapsuleWindow]] = [:]
    static var capsuleInQueue: [CapsuleTarget] = []
    
    static var current: AppContext? {
        guard let windowScene = windowScene else { return nil }
        if let ctx = allContexts[windowScene] {
            return ctx
        } else {
            let ctx: AppContext = .init(windowScene: windowScene)
            allContexts[windowScene] = ctx
            return ctx
        }
    }
    static var allContexts = [UIWindowScene: AppContext]()
    private let windowScene: UIWindowScene
    
    private init(windowScene: UIWindowScene) {
        self.windowScene = windowScene
    }
    
    /// 单窗口应用无需设置，多窗口应用需要指定显示到哪个windowScene上
    /// workspace可以是windowScene/window/view/viewController
    public static var workspace: Workspace? {
        get { windowScene }
        set {
            windowScene = newValue?.windowScene
        }
    }
    
}

extension AppContext {
    
    static var foregroundActiveWindowScenes: [UIWindowScene] {
        return UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).filter({ $0.activationState == .foregroundActive })
    }
    
    /// 如果设置了workspace，就是workspace所对应的windowScene，否则就是最后一个打开的应用程序窗口的windowScene
    static var windowScene: UIWindowScene? {
        set { storedAppWindowScene = newValue }
        get {
            if let ws = storedAppWindowScene {
                return ws
            } else {
                return foregroundActiveWindowScenes.last
            }
        }
    }
    
    /// 所有的窗口
    static var windows: [UIWindow] {
        windowScene?.windows ?? UIApplication.shared.windows
    }
    
    /// 可见的窗口
    static var visibleWindows: [UIWindow] {
        windows.filter { $0.isHidden == false }
    }
    
    /// App主程序窗口
    static var appWindow: UIWindow? {
        visibleWindows.filter { window in
            return "\(type(of: window))" == "UIWindow" && window.windowLevel == .normal
        }.first
    }
    
    /// App主程序窗口的尺寸
    static var appBounds: CGRect {
        appWindow?.bounds ?? UIScreen.main.bounds
    }
    
    /// App主程序窗口的安全边距
    static var safeAreaInsets: UIEdgeInsets { appWindow?.safeAreaInsets ?? .zero }
    
}

// MARK: - instance manage

extension AppContext {
    var sheetWindows: [SheetWindow] {
        Self.sheetWindows[windowScene] ?? []
    }
    var toastWindows: [ToastWindow] {
        Self.toastWindows[windowScene] ?? []
    }
    var capsuleWindows: [CapsuleViewModel.Position: CapsuleWindow] {
        Self.capsuleWindows[windowScene] ?? [:]
    }
    var alertWindow: AlertWindow? {
        Self.alertWindow[windowScene]
    }
}
 
