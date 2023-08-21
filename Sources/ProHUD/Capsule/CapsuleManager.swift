//
//  CapsuleManager.swift
//  
//
//  Created by xaoxuu on 2022/9/8.
//

import UIKit

extension CapsuleTarget {
    
    @objc open func push() {
        guard CapsuleConfiguration.isEnabled else { return }
        guard let windowScene = preferredWindowScene ?? AppContext.windowScene else { return }
        if windowScene != AppContext.windowScene {
            AppContext.windowScene = windowScene
        }
        
        let isNew: Bool
        let window: CapsuleWindow
        let position = vm?.position ?? .top
        
        if AppContext.capsuleWindows[windowScene] == nil {
            AppContext.capsuleWindows[windowScene] = [:]
        }
        var windows = AppContext.capsuleWindows[windowScene] ?? [:]
        if let w = windows[position], w.isHidden == false {
            // 此时同一位置已有capsule在显示
            if vm?.queuedPush == true {
                // 加入队列
                self.preferredWindowScene = windowScene
                AppContext.capsuleInQueue.append(self)
                return
            } else {
                // 直接覆盖
                isNew = false
                window = w
            }
        } else {
            // 空闲状态下推送一个新的
            isNew = true
            window = CapsuleWindow(capsule: self)
            windows[position] = nil
        }
        
        // frame
        let cardEdgeInsetsByDefault = config.cardEdgeInsetsByDefault
        view.layoutIfNeeded()
        var size = contentStack.frame.size
        size = CGSize(width: min(config.cardMaxWidthByDefault, size.width + cardEdgeInsetsByDefault.left + cardEdgeInsetsByDefault.right), height: min(config.cardMaxHeightByDefault, size.height + cardEdgeInsetsByDefault.top + cardEdgeInsetsByDefault.bottom))
        
        // 应用到frame
        let newFrame: CGRect
        switch vm?.position {
        case .top, .none:
            let topLayoutMargins = AppContext.appWindow?.safeAreaInsets.top ?? 8
            let y = max(topLayoutMargins, 8)
            newFrame = .init(x: (AppContext.appBounds.width - size.width) / 2, y: y, width: size.width, height: size.height)
        case .middle:
            newFrame = .init(x: (AppContext.appBounds.width - size.width) / 2, y: (AppContext.appBounds.height - size.height) / 2 - 20, width: size.width, height: size.height)
        case .bottom:
            let bottomLayoutMargins = AppContext.appWindow?.layoutMargins.bottom ?? 8
            let y = AppContext.appBounds.height - bottomLayoutMargins - size.height - 60
            newFrame = .init(x: (AppContext.appBounds.width - size.width) / 2, y: y, width: size.width, height: size.height)
        }
        
        window.transform = .identity
        if isNew {
            window.frame = newFrame
        }
        
        config.cardCornerRadius = min(size.height / 2, config.cardCornerRadiusByDefault)
        contentView.layer.cornerRadiusWithContinuous = config.cardCornerRadiusByDefault
        view.layer.cornerRadiusWithContinuous = config.cardCornerRadiusByDefault
        
        window.rootViewController = self // 此时toast.view.frame.size会自动更新为window.frame.size
        
        AppContext.capsuleWindows[windowScene]?[position] = window
        
        navEvents[.onViewWillAppear]?(self)
        
        if position == .top {
            // 更新toast防止重叠
            ToastWindow.updateToastWindowsLayout()
        }
        
        func completion() {
            self.navEvents[.onViewDidAppear]?(self)
            self.updateTimeoutDuration()
        }
        if isNew {
            window.isHidden = false
            if let animateBuildIn = config.animateBuildIn {
                animateBuildIn(window, completion)
            } else {
                let duration = config.animateDurationForBuildInByDefault
                switch position {
                case .top:
                    window.transform = .init(translationX: 0, y: -window.frame.maxY - 20)
                    UIView.animateEaseOut(duration: duration) {
                        window.transform = .identity
                    } completion: { done in
                        completion()
                    }
                case .middle:
                    window.transform = .init(translationX: 0, y: 24)
                    UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5) {
                        window.transform = .identity
                    } completion: { done in
                        completion()
                    }
                    window.alpha = 0
                    UIView.animateLinear(duration: duration * 0.5) {
                        window.alpha = 1
                    }
                case .bottom:
                    let offsetY = AppContext.appBounds.height - newFrame.maxY + 100
                    window.transform = .init(translationX: 0, y: offsetY)
                    UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.5) {
                        window.transform = .identity
                    } completion: { done in
                        completion()
                    }
                }
            }
        } else {
            view.layoutIfNeeded()
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
                window.frame = newFrame
                window.layoutIfNeeded()
            } completion: { done in
                completion()
            }
        }
        
    }
    
    @objc open func pop() {
        guard let window = attachedWindow, let windowScene = windowScene else { return }
        let position = vm?.position ?? .top
        AppContext.capsuleWindows[windowScene]?[position] = nil
        navEvents[.onViewWillDisappear]?(self)
        if position == .top {
            // 更新toast防止重叠
            ToastWindow.updateToastWindowsLayout()
        }
        func completion() {
            window.isHidden = true
            window.transform = .identity
            self.navEvents[.onViewDidDisappear]?(self)
        }
        if let animateBuildOut = config.animateBuildOut {
            animateBuildOut(window, completion)
        } else {
            let duration = config.animateDurationForBuildOutByDefault
            let oldFrame = window.frame
            switch position {
            case .top:
                UIView.animateEaseIn(duration: duration) {
                    window.transform = .init(translationX: 0, y: -oldFrame.maxY - 20)
                } completion: { done in
                    completion()
                }
            case .middle:
                let duration = config.animateDurationForBuildInByDefault * 1
                UIView.animateEaseIn(duration: duration) {
                    window.transform = .init(translationX: 0, y: -24)
                } completion: { done in
                    completion()
                }
                UIView.animateLinear(duration: duration * 0.5, delay: duration * 0.3) {
                    window.alpha = 0
                }
            case .bottom:
                let offsetY = AppContext.appBounds.height - oldFrame.maxY + 100
                UIView.animateEaseIn(duration: duration) {
                    window.transform = .init(translationX: 0, y: offsetY)
                } completion: { done in
                    completion()
                }
            }
        }
        if let next = AppContext.capsuleInQueue.first(where: { $0.preferredWindowScene == windowScene && $0.vm?.position == position }) {
            AppContext.capsuleInQueue.removeAll(where: { $0 == next })
            DispatchQueue.main.asyncAfter(deadline: .now() + config.animateDurationForBuildOutByDefault * 0.8) {
                next.push()
            }
        }
    }
    
    /// 更新HUD实例
    /// - Parameter handler: 实例更新代码
    @objc open func update(handler: @escaping (_ capsule: CapsuleTarget) -> Void) {
        handler(self)
        
        reloadData()
        UIView.animateEaseOut(duration: config.animateDurationForReloadByDefault) {
            self.view.layoutIfNeeded()
        }
    }
    
    func updateTimeoutDuration() {
        // 为空时使用默认规则
        if vm?.duration == nil {
            vm?.duration = config.defaultDuration
        }
        // 设置持续时间
        vm?.timeoutHandler = DispatchWorkItem(block: { [weak self] in
            self?.pop()
        })
    }
    
}
