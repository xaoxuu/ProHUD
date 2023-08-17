//
//  CapsuleManager.swift
//  
//
//  Created by xaoxuu on 2022/9/8.
//

import UIKit

extension Capsule: HUD {
    
    @objc open func push() {
        guard Configuration.isEnabled else { return }
        let isNew: Bool
        let window: CapsuleWindow
        let position = vm.position
        
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
        switch vm.position {
        case .top:
            let topLayoutMargins = AppContext.appWindow?.layoutMargins.top ?? 8
            let y = max(topLayoutMargins - 8, 8)
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
        AppContext.capsuleWindows[windowScene]?[vm.position] = nil
        navEvents[.onViewWillDisappear]?(self)
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
            switch vm.position {
            case .top:
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
    
    
}

public extension Capsule {
    
    /// 如果不存在就创建并弹出一个HUD实例，如果存在就更新实例
    /// - Parameters:
    ///   - identifier: 实例唯一标识符（如果为空，则以代码位置为唯一标识符）
    ///   - handler: 实例创建代码
    static func lazyPush(identifier: String? = nil, file: String = #file, line: Int = #line, handler: @escaping (_ capsule: Capsule) -> Void, onExists: ((_ capsule: Capsule) -> Void)? = nil) {
        let id = identifier ?? (file + "#\(line)")
        if let vc = find(identifier: id).last {
            vc.update(handler: onExists ?? handler)
        } else {
            Capsule { capsule in
                capsule.identifier = id
                handler(capsule)
            }
        }
    }
    
    /// 更新HUD实例
    /// - Parameter handler: 实例更新代码
    func update(handler: @escaping (_ capsule: Capsule) -> Void) {
        handler(self)
        reloadData()
        UIView.animateEaseOut(duration: config.animateDurationForReloadByDefault) {
            self.view.layoutIfNeeded()
        }
    }
    
    /// 查找HUD实例
    /// - Parameter identifier: 唯一标识符
    /// - Returns: HUD实例
    @discardableResult static func find(identifier: String, update handler: ((_ capsule: Capsule) -> Void)? = nil) -> [Capsule] {
        let arr = AppContext.capsuleWindows.values.flatMap({ $0.values }).compactMap({ $0.capsule }).filter({ $0.identifier == identifier })
        if let handler = handler {
            arr.forEach({ $0.update(handler: handler) })
        }
        return arr
    }
    
}


//extension Capsule {
//    
//    func translateIn(completion: (() -> Void)?) {
//        UIView.animateEaseOut(duration: config.animateDurationForBuildInByDefault) {
//            if self.config.stackDepthEffect {
//                if isPhonePortrait {
//                    AppContext.appWindow?.transform = .init(translationX: 0, y: 8).scaledBy(x: 0.9, y: 0.9)
//                } else {
//                    AppContext.appWindow?.transform = .init(scaleX: 0.92, y: 0.92)
//                }
//                AppContext.appWindow?.layer.cornerRadiusWithContinuous = 16
//                AppContext.appWindow?.layer.masksToBounds = true
//            }
//        } completion: { done in
//            completion?()
//        }
//    }
//    
//    func translateOut(completion: (() -> Void)?) {
//        UIView.animateEaseOut(duration: config.animateDurationForBuildOutByDefault) {
//            if self.config.stackDepthEffect {
//                AppContext.appWindow?.transform = .identity
//                AppContext.appWindow?.layer.cornerRadius = 0
//            }
//        } completion: { done in
//            completion?()
//        }
//    }
//    
//}
