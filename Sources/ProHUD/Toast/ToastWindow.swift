//
//  ToastWindow.swift
//  
//
//  Created by xaoxuu on 2022/9/3.
//

import UIKit

private extension Toast {
    func getContextWindows() -> [ToastWindow] {
        guard let windowScene = windowScene else {
            return []
        }
        return AppContext.toastWindows[windowScene] ?? []
    }
    func setContextWindows(_ windows: [ToastWindow]) {
        guard let windowScene = windowScene else {
            return
        }
        AppContext.toastWindows[windowScene] = windows
    }
}

class ToastWindow: Window {
    
    var toast: Toast
    
    var maxY = CGFloat(0)
    
    init(toast: Toast) {
        self.toast = toast
        super.init(frame: .zero)
        windowScene = AppContext.windowScene
        toast.window = self
        windowLevel = .init(rawValue: UIWindow.Level.alert.rawValue + 1000)
        layer.shadowRadius = 8
        layer.shadowOffset = .init(width: 0, height: 5)
        layer.shadowOpacity = 0.2
        isHidden = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath.init(rect: bounds).cgPath
    }
    
    static func push(toast: Toast) {
        let isNew: Bool
        let window: ToastWindow
        var windows = AppContext.current?.toastWindows ?? []
        if let w = windows.first(where: { $0.toast == toast }) {
            isNew = false
            window = w
        } else {
            window = ToastWindow(toast: toast)
            isNew = true
        }
        let config = toast.config
        
        // frame
        let width = CGFloat.minimum(AppContext.appBounds.width - config.cardEdgeInsets.left - config.cardEdgeInsets.right, config.cardMaxWidthByDefault)
        toast.view.frame.size = CGSize(width: width, height: config.cardMaxHeightByDefault)
        toast.titleLabel.sizeToFit()
        toast.bodyLabel.sizeToFit()
        toast.view.layoutIfNeeded()
        // 更新子视图之后获取正确的高度
        let height = toast.calcHeight()
        toast.view.frame.size = CGSize(width: width, height: height)
        // 应用到frame
        window.frame = CGRect(x: (AppContext.appBounds.width - width) / 2, y: 0, width: width, height: height)
        window.rootViewController = toast // 此时toast.view.frame.size会自动更新为window.frame.size
        if windows.contains(window) == false {
            windows.append(window)
            toast.setContextWindows(windows)
        }
        updateToastWindowsLayout(windows: windows)
        if isNew {
            window.transform = .init(translationX: 0, y: -window.frame.maxY)
            UIView.animateEaseOut(duration: config.animateDurationForBuildInByDefault) {
                window.transform = .identity
            } completion: { done in
                toast.navEvents[.onViewDidAppear]?(toast)
            }
        } else {
            toast.view.layoutIfNeeded()
            toast.navEvents[.onViewDidAppear]?(toast)
        }
    }
    
    static func pop(toast: Toast) {
        var windows = toast.getContextWindows()
        guard let window = windows.first(where: { $0.toast == toast }) else {
            return
        }
        if windows.count > 1 {
            windows.removeAll { $0 == window }
            updateToastWindowsLayout(windows: windows)
        } else if windows.count == 1 {
            windows.removeAll()
        } else {
            consolePrint("‼️代码漏洞：已经没有toast了")
        }
        toast.vm.duration = nil
        toast.setContextWindows(windows)
        UIView.animateEaseOut(duration: toast.config.animateDurationForBuildOutByDefault) {
            window.transform = .init(translationX: 0, y: 0-20-window.maxY)
        } completion: { done in
            toast.view.removeFromSuperview()
            toast.removeFromParent()
            toast.navEvents[.onViewDidDisappear]?(toast)
        }
    }
    
    
}

fileprivate var updateToastsLayoutWorkItem: DispatchWorkItem?

fileprivate extension ToastWindow {
    
    static func setToastWindowsLayout(windows: [ToastWindow]) {
        for (i, window) in windows.enumerated() {
            let config = window.toast.config
            var y = window.frame.origin.y
            if i == 0 {
                y = max(AppContext.appWindow?.layoutMargins.top ?? config.margin, config.margin)
            } else {
                if i - 1 < windows.count && i > 0 {
                    y = config.margin + windows[i-1].frame.maxY
                } else {
                    y = config.margin
                }
            }
            window.maxY = y + window.frame.size.height
            UIView.animateEaseOut(duration: config.animateDurationForReloadByDefault) {
                window.frame.origin.y = y
            }
        }
    }
    
    static func updateToastWindowsLayout(windows: [ToastWindow]) {
        updateToastsLayoutWorkItem?.cancel()
        updateToastsLayoutWorkItem = DispatchWorkItem {
            setToastWindowsLayout(windows: windows)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.001, execute: updateToastsLayoutWorkItem!)
    }
    
}

fileprivate extension Toast {
    func calcHeight() -> CGFloat {
        var height = CGFloat(0)
        for v in infoStack.arrangedSubviews {
            // 图片或者文本最大高度
            height = CGFloat.maximum(v.frame.maxY, height)
        }
        if actionStack.arrangedSubviews.count > 0 {
            height += actionStack.frame.height + contentStack.spacing
        }
        contentView.subviews.filter { v in
            if v == contentMaskView {
                return false
            }
            if v == contentStack {
                return false
            }
            return true
        } .forEach { v in
            height = CGFloat.maximum(v.frame.maxY, height)
        }
        // 上下边间距
        height += config.cardEdgeInsets.top + config.cardEdgeInsets.bottom
        return height
    }
}
