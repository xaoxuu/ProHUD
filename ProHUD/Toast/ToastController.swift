//
//  ToastController.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/31.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit
import SnapKit

public extension ProHUD {
    class Toast: HUDController {
        
        public var window: UIWindow?
        /// 内容容器
        public var contentView = BlurView()
        internal var contentStack: StackContainer = {
            let stack = StackContainer()
            stack.axis = .horizontal
            stack.alignment = .top
            stack.spacing = toastConfig.margin
            return stack
        }()
        
        /// 图标
        internal var imageView: UIImageView?
        /// 文本区域
        internal var textStack: StackContainer = {
            let stack = StackContainer()
            stack.spacing = toastConfig.margin
            stack.alignment = .leading
            return stack
        }()
        internal var titleLabel: UILabel?
        internal var messageLabel: UILabel?
        
        /// 视图模型
        public var vm = ViewModel()
        
        public var removable = true
        
        internal var tapCallback: (() -> Void)?
        
        // MARK: 生命周期
        
        /// 实例化
        /// - Parameter scene: 场景
        /// - Parameter title: 标题
        /// - Parameter message: 内容
        /// - Parameter icon: 图标
        public convenience init(scene: Scene = .default, title: String? = nil, message: String? = nil, icon: UIImage? = nil) {
            self.init()
            vm.scene = scene
            vm.title = title
            vm.message = message
            vm.icon = icon
            switch scene {
            case .loading:
                timeout = nil
            default:
                timeout = 2
            }
            
            willLayout()
            
            // 点击
            let tap = UITapGestureRecognizer(target: self, action: #selector(privDidTapped(_:)))
            view.addGestureRecognizer(tap)
            // 拖动
            let pan = UIPanGestureRecognizer(target: self, action: #selector(privDidPan(_:)))
            view.addGestureRecognizer(pan)
            
        }
        
        public override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            disappearCallback?()
        }
        
        
        /// 移除
        public func remove() {
            hud.removeItemFromArray(toast: self)
            UIView.animateForToast(animations: {
                let frame = self.window?.frame ?? .zero
                self.window?.transform = .init(translationX: 0, y: -200-frame.maxY)
            }) { (done) in
                self.view.removeFromSuperview()
                self.removeFromParent()
                self.window = nil
            }
        }
        
        internal func updateFrame() {
            let newSize = contentView.frame.size
            view.frame.size = newSize
            window?.frame.size = newSize
            hud.updateToastsLayout()
        }
        
        // MARK: 设置函数
        
        /// 设置超时时间
        /// - Parameter timeout: 超时时间
        @discardableResult public func timeout(_ timeout: TimeInterval?) -> Toast {
            self.timeout = timeout
            willLayout()
            return self
        }
        
        /// 点击事件
        /// - Parameter callback: 事件回调
        @discardableResult public func didTapped(_ callback: (() -> Void)?) -> Toast {
            tapCallback = callback
            return self
        }
        
        /// 消失事件
        /// - Parameter callback: 事件回调
        @discardableResult public func didDisappear(_ callback: (() -> Void)?) -> Toast {
            disappearCallback = callback
            return self
        }
        
        /// 更新标题
        /// - Parameter title: 标题
        @discardableResult public func update(scene: Scene, title: String? = nil, message: String? = nil, icon: UIImage? = nil) -> Toast {
            vm.scene = scene
            vm.title = title
            vm.message = message
            vm.icon = icon
            toastConfig.updateFrame(self)
            return self
        }
        
        
        
    }
    
}

fileprivate extension ProHUD.Toast {
    func willLayout() {
        willLayout?.cancel()
        willLayout = DispatchWorkItem(block: { [weak self] in
            if let a = self {
                // 布局
                toastConfig.loadSubviews(a)
                toastConfig.updateFrame(a)
                // 超时
                a.timeoutBlock?.cancel()
                if let t = a.timeout, t > 0 {
                    a.timeoutBlock = DispatchWorkItem(block: { [weak self] in
                        self?.remove()
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now()+t, execute: a.timeoutBlock!)
                } else {
                    a.timeoutBlock = nil
                }
            }
        })
        DispatchQueue.main.asyncAfter(deadline: .now()+0.001, execute: willLayout!)
    }
    
    func willUpdateToastsLayout() {
        
    }
    
    
    /// 点击事件
    /// - Parameter sender: 手势
    @objc func privDidTapped(_ sender: UITapGestureRecognizer) {
        tapCallback?()
    }
    
    /// 拖拽事件
    /// - Parameter sender: 手势
    @objc func privDidPan(_ sender: UIPanGestureRecognizer) {
        timeoutBlock?.cancel()
        let point = sender.translation(in: sender.view)
        window?.transform = .init(translationX: 0, y: point.y)
        if sender.state == .recognized {
            let v = sender.velocity(in: sender.view)
            if removable == true && (((window?.frame.origin.y ?? 0) < 0 && v.y < 0) || v.y < -1200) {
                // 移除
                self.remove()
            } else {
                UIView.animateForToast(animations: {
                    self.window?.transform = .identity
                }) { (done) in
                    // 重置计时器
                    
                }
            }
        }
    }
}


// MARK: - AlertHUD public func

public extension ProHUD {
    
    @discardableResult
    func show(_ toast: Toast) -> Toast {
        let config = toastConfig
        if toast.window == nil {
            let w = UIWindow(frame: .init(x: config.margin, y: config.margin, width: UIScreen.main.bounds.width - 2*config.margin, height: 500))
            toast.window = w
            w.rootViewController = toast
            w.windowLevel = UIWindow.Level(5000)
            w.backgroundColor = .clear
            w.layer.shadowRadius = 8
            w.layer.shadowOffset = .init(width: 0, height: 5)
            w.layer.shadowOpacity = 0.2
        }
        
        let window = toast.window!
        window.makeKeyAndVisible()
        window.transform = .init(translationX: 0, y: -window.frame.maxY)
        
        toasts.append(toast)
        
        UIView.animateForToast {
            window.transform = .identity
        }
        return toast
    }
    
    @discardableResult
    func show(toast: Toast.Scene, title: String? = nil, message: String? = nil, icon: UIImage? = nil) -> Toast {
        return show(Toast(scene: toast, title: title, message: message, icon: icon))
    }
    
    func toasts(identifier: String?) -> [Toast] {
        var tt = [Toast]()
        for t in toasts {
            if t.identifier == identifier {
                tt.append(t)
            }
        }
        return tt
    }
    
    func remove(toast: Toast) {
        for t in toasts {
            if t == toast {
                t.remove()
            }
        }
    }
    
    func remove(toast identifier: String?) {
        for t in toasts {
            if t.identifier == identifier {
                t.remove()
            }
        }
    }
}


// MARK: AlertHUD public class func

public extension ProHUD {
    
    @discardableResult
    class func show(_ toast: Toast) -> Toast {
        return shared.show(toast)
    }
    
    @discardableResult
    class func show(toast: Toast.Scene, title: String? = nil, message: String? = nil, icon: UIImage? = nil) -> Toast {
        return shared.show(toast: toast, title: title, message: message, icon: icon)
    }
    
    class func alert(identifier: String?) -> [Toast] {
        return shared.toasts(identifier: identifier)
    }
    
    class func remove(toast: Toast) {
        shared.remove(toast: toast)
    }
    
    class func remove(toast identifier: String?) {
        shared.remove(toast: identifier)
    }
    
}

// MARK: AlertHUD private func

fileprivate extension ProHUD {
    
    func updateToastsLayout() {
        for (i, e) in toasts.enumerated() {
            let config = toastConfig
            var frame = e.window?.frame ?? .zero
            if i == 0 {
                frame.origin.y = 44
            } else {
                let lastY = toasts[i-1].window?.frame.maxY ?? .zero
                frame.origin.y = lastY + config.margin
            }
            UIView.animateForToast(animations: {
                e.window?.frame = frame
            }) { (done) in
                
            }
        }
    }
    
    func removeItemFromArray(toast: Toast) {
        if toasts.count > 1 {
            for (i, t) in toasts.enumerated() {
                if t == toast {
                    toasts.remove(at: i)
                }
            }
            updateToastsLayout()
        } else if toasts.count == 1 {
            toasts.removeAll()
        } else {
            debugPrint("漏洞：已经没有toast了")
        }
    }
    
}


