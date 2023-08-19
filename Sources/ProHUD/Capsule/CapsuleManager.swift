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
        let isNew: Bool
        let window: CapsuleWindow
        let position = vm?.position ?? .top
        
        if let w = AppContext.current?.capsuleWindows[position] {
            isNew = false
            window = w
        } else {
            window = CapsuleWindow(capsule: self)
            isNew = true
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
        if let s = AppContext.windowScene {
            if AppContext.capsuleWindows[s] == nil {
                AppContext.capsuleWindows[s] = [:]
            }
            AppContext.capsuleWindows[s]?[position] = window
        }
        navEvents[.onViewWillAppear]?(self)
        
        // 更新toast防止重叠
        ToastWindow.updateToastWindowsLayout()
        
        if isNew {
            window.isHidden = false
            func completion() {
                self.navEvents[.onViewDidAppear]?(self)
            }
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
                    let d0 = duration * 0.2
                    let d1 = duration
                    window.transform = .init(scaleX: 0.001, y: 0.001)
                    window.alpha = 0
                    UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
                        window.transform = .identity
                    } completion: { done in
                        completion()
                    }
                    UIView.animate(withDuration: duration * 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1) {
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
                self.navEvents[.onViewDidAppear]?(self)
            }
        }
        
    }
    
    @objc open func pop() {
        guard let window = attachedWindow, let windowScene = windowScene else { return }
        AppContext.capsuleWindows[windowScene]?[vm?.position ?? .top] = nil
        navEvents[.onViewWillDisappear]?(self)
        // 更新toast防止重叠
        ToastWindow.updateToastWindowsLayout()
        
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
            switch vm?.position {
            case .top, .none:
                UIView.animateEaseOut(duration: duration) {
                    window.transform = .init(translationX: 0, y: -oldFrame.maxY - 20)
                } completion: { done in
                    completion()
                }
            case .middle:
                UIView.animate(withDuration: duration * 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5) {
                    window.transform = .init(scaleX: 0.001, y: 0.001)
                } completion: { done in
                    completion()
                }
                UIView.animate(withDuration: duration * 0.4, delay: duration * 0.2, usingSpringWithDamping: 1, initialSpringVelocity: 0.5) {
                    window.alpha = 0
                }
            case .bottom:
                let offsetY = AppContext.appBounds.height - oldFrame.maxY + 100
                UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0) {
                    window.transform = .init(translationX: 0, y: offsetY)
                } completion: { done in
                    completion()
                }
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
    
}
