//
//  ToastManager.swift
//  
//
//  Created by xaoxuu on 2022/9/3.
//

import UIKit

extension ToastTarget {
    
    @objc open func push() {
        guard ToastConfiguration.isEnabled else { return }
        let isNew: Bool
        let window: ToastWindow
        var windows = AppContext.current?.toastWindows ?? []
        if let w = windows.first(where: { $0.toast == self }) {
            isNew = false
            window = w
            window.toast = self
        } else {
            window = ToastWindow(toast: self)
            isNew = true
        }
        
        if windows.contains(window) == false {
            windows.append(window)
            setContextWindows(windows)
        }
        let size = getWindowSize(window: window)
        window.frame = CGRect(x: (AppContext.appBounds.width - size.width) / 2, y: 0, width: size.width, height: size.height)
        window.rootViewController = self // 此时toast.view.frame.size会自动更新为window.frame.size
        
        ToastWindow.updateToastWindowsLayout(windows: windows)
        // 为了更连贯，从进入动画开始时就开始计时
        updateTimeoutDuration()
        func completion() {
            self.navEvents[.onViewDidAppear]?(self)
        }
        if isNew {
            window.transform = .init(translationX: 0, y: -window.frame.maxY)
            UIView.animateEaseOut(duration: config.animateDurationForBuildInByDefault) {
                window.transform = .identity
            } completion: { done in
                completion()
            }
        } else {
            view.layoutIfNeeded()
            completion()
        }
    }
    
    @objc open func pop() {
        var windows = getContextWindows()
        guard let window = windows.first(where: { $0.toast == self }) else {
            return
        }
        if windows.count > 1 {
            windows.removeAll { $0 == window }
            ToastWindow.updateToastWindowsLayout(windows: windows)
        } else if windows.count == 1 {
            windows.removeAll()
        } else {
            consolePrint("‼️代码漏洞：已经没有toast了")
        }
        vm?.duration = nil
        setContextWindows(windows)
        UIView.animateLinear(duration: config.animateDurationForBuildOutByDefault) {
            window.transform = .init(translationX: 0, y: 0-20-window.maxY)
        } completion: { done in
            self.view.removeFromSuperview()
            self.removeFromParent()
            self.navEvents[.onViewDidDisappear]?(self)
            // 这里设置一下window属性，会使window的生命周期被延长到此处，即动画执行过程中window不会被提前释放
            window.isHidden = true
        }
    }
    
    /// 更新VC
    /// - Parameter handler: 更新操作
    @objc open func reloadData(handler: @escaping (_ capsule: ToastTarget) -> Void) {
        handler(self)
        reloadData()
    }
    
    /// 更新vm并刷新UI
    /// - Parameter handler: 更新操作
    @objc open func vm(handler: @escaping (_ vm: ViewModel) -> ViewModel) {
        let new = handler(vm ?? .init())
        vm?.update(another: new)
        reloadData()
    }
    
    /// 重设vm并刷新UI
    /// - Parameter vm: 新的vm
    @objc open func vm(_ vm: ViewModel) {
        self.vm = vm
        reloadData()
    }
    
    func updateTimeoutDuration() {
        // 为空时使用默认规则
        if vm?.duration == nil {
            vm?.duration = config.defaultDuration
        }
        // 设置持续时间
        vm?.restartTimer()
    }
    
}

// MARK: - layout

fileprivate var updateToastsLayoutWorkItem: DispatchWorkItem?

fileprivate extension ToastWindow {
    
    static func setToastWindowsLayout(windows: [ToastWindow]) {
        var windows: [Window] = windows
        if let win = AppContext.current?.capsuleWindows[.top] {
            windows.insert(win, at: 0)
        }
        for (i, window) in windows.enumerated() {
            let margin: CGFloat
            if let window = window as? ToastWindow {
                margin = window.toast.config.marginY
            } else if let window = window as? CapsuleWindow {
                margin = window.safeAreaInsets.top
            } else {
                margin = 8
            }
            var y = window.frame.origin.y
            if i == 0 {
                let topLayoutMargins = AppContext.appWindow?.safeAreaInsets.top ?? margin
                y = max(topLayoutMargins, margin)
            } else {
                if i - 1 < windows.count && i > 0 {
                    y = margin + windows[i-1].frame.maxY
                } else {
                    y = margin
                }
            }
            if let window = window as? ToastWindow {
                window.maxY = y + window.frame.size.height
            }
            UIView.animateEaseOut(duration: 0.68) {
                window.frame.origin.y = y
            }
        }
    }
    
    static func updateToastWindowsLayout(windows: [ToastWindow]) {
        updateToastsLayoutWorkItem?.cancel()
        updateToastsLayoutWorkItem = DispatchWorkItem {
            setToastWindowsLayout(windows: windows)
            updateToastsLayoutWorkItem = nil
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.001, execute: updateToastsLayoutWorkItem!)
    }
    
}

extension ToastWindow {
    static func updateToastWindowsLayout() {
        let wins = AppContext.current?.toastWindows ?? []
        updateToastWindowsLayout(windows: wins)
    }
}

public class ToastManager: NSObject {
    
    /// 查找HUD实例
    /// - Parameter identifier: 唯一标识符
    /// - Returns: HUD实例
    @discardableResult public static func find(identifier: String, update handler: ((_ toast: ToastTarget) -> Void)? = nil) -> [ToastTarget] {
        let arr = AppContext.toastWindows.values.flatMap({ $0 }).compactMap({ $0.toast }).filter({ $0.identifier == identifier })
        if let handler = handler {
            arr.forEach({ $0.reloadData(handler: handler) })
        }
        return arr
    }
    
}
