//
//  ToastManager.swift
//  
//
//  Created by xaoxuu on 2022/9/3.
//

import UIKit

extension Toast: HUD {
    
    private func calcHeight() -> CGFloat {
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
        let cardEdgeInsets = config.cardEdgeInsetsByDefault
        height += cardEdgeInsets.top + cardEdgeInsets.bottom
        return height
    }
    @objc open func push() {
        guard Configuration.isEnabled else { return }
        let isNew: Bool
        let window: ToastWindow
        var windows = AppContext.current?.toastWindows ?? []
        if let w = windows.first(where: { $0.toast == self }) {
            isNew = false
            window = w
        } else {
            window = ToastWindow(toast: self)
            isNew = true
        }
        
        // frame
        let cardEdgeInsets = config.cardEdgeInsetsByDefault
        let width = CGFloat.minimum(AppContext.appBounds.width - config.windowEdgeInsetByDefault - config.windowEdgeInsetByDefault, config.cardMaxWidthByDefault)
        view.frame.size = CGSize(width: width, height: config.cardMaxHeightByDefault)
        titleLabel.sizeToFit()
        bodyLabel.sizeToFit()
        view.layoutIfNeeded()
        // 更新子视图之后获取正确的高度
        let height = calcHeight()
        view.frame.size = CGSize(width: width, height: height)
        // 应用到frame
        window.frame = CGRect(x: (AppContext.appBounds.width - width) / 2, y: 0, width: width, height: height)
        window.rootViewController = self // 此时toast.view.frame.size会自动更新为window.frame.size
        if windows.contains(window) == false {
            windows.append(window)
            setContextWindows(windows)
        }
        ToastWindow.updateToastWindowsLayout(windows: windows)
        if isNew {
            window.transform = .init(translationX: 0, y: -window.frame.maxY)
            UIView.animateEaseOut(duration: config.animateDurationForBuildInByDefault) {
                window.transform = .identity
            } completion: { done in
                self.navEvents[.onViewDidAppear]?(self)
            }
        } else {
            view.layoutIfNeeded()
            self.navEvents[.onViewDidAppear]?(self)
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
        vm.duration = nil
        setContextWindows(windows)
        UIView.animateEaseOut(duration: config.animateDurationForBuildOutByDefault) {
            window.transform = .init(translationX: 0, y: 0-20-window.maxY)
        } completion: { done in
            self.view.removeFromSuperview()
            self.removeFromParent()
            self.navEvents[.onViewDidDisappear]?(self)
            // 这里设置一下window属性，会使window的生命周期被延长到此处，即动画执行过程中window不会被提前释放
            window.isHidden = true
        }
    }
    
}

public extension Toast {
    
    /// 如果不存在就创建并弹出一个HUD实例，如果存在就更新实例
    /// - Parameters:
    ///   - identifier: 实例唯一标识符（如果为空，则以代码位置为唯一标识符）
    ///   - handler: 实例创建代码
    static func lazyPush(identifier: String? = nil, file: String = #file, line: Int = #line, handler: @escaping (_ toast: Toast) -> Void, onExists: ((_ toast: Toast) -> Void)? = nil) {
        let id = identifier ?? (file + "#\(line)")
        if let vc = find(identifier: id).last {
            vc.update(handler: onExists ?? handler)
        } else {
            Toast { toast in
                toast.identifier = id
                handler(toast)
            }
        }
    }
    
    /// 更新HUD实例
    /// - Parameter handler: 实例更新代码
    func update(handler: @escaping (_ toast: Toast) -> Void) {
        handler(self)
        reloadData()
        UIView.animateEaseOut(duration: config.animateDurationForReloadByDefault) {
            self.view.layoutIfNeeded()
        }
    }
    
    /// 查找HUD实例
    /// - Parameter identifier: 唯一标识符
    /// - Returns: HUD实例
    @discardableResult static func find(identifier: String, update handler: ((_ toast: Toast) -> Void)? = nil) -> [Toast] {
        let arr = AppContext.toastWindows.values.flatMap({ $0 }).compactMap({ $0.toast }).filter({ $0.identifier == identifier })
        if let handler = handler {
            arr.forEach({ $0.update(handler: handler) })
        }
        return arr
    }
    
}

// MARK: - layout

fileprivate var updateToastsLayoutWorkItem: DispatchWorkItem?

fileprivate extension ToastWindow {
    
    static func setToastWindowsLayout(windows: [ToastWindow]) {
        for (i, window) in windows.enumerated() {
            let config = window.toast.config
            var y = window.frame.origin.y
            if i == 0 {
                let topLayoutMargins = AppContext.appWindow?.layoutMargins.top ?? config.margin
                y = max(topLayoutMargins - config.margin, config.margin)
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
            updateToastsLayoutWorkItem = nil
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.001, execute: updateToastsLayoutWorkItem!)
    }
    
}
