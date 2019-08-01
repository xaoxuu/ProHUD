//
//  ToastController.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/31.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit
import Inspire

public extension ProHUD {
    class Toast: HUDController {
        
        public var window: UIWindow?
        
        /// 图标
        internal lazy var imageView: UIImageView = {
            let imgv = UIImageView()
            imgv.contentMode = .scaleAspectFit
            return imgv
        }()
        
        /// 标题
        internal lazy var titleLabel: UILabel = {
            let lb = UILabel()
            lb.textColor = UIColor.init(white: 0.2, alpha: 1)
            lb.font = toastConfig.titleFont
            lb.textAlignment = .justified
            lb.numberOfLines = toastConfig.titleMaxLines
            return lb
        }()
        
        /// 正文
        internal lazy var bodyLabel: UILabel = {
            let lb = UILabel()
            lb.textColor = .darkGray
            lb.font = toastConfig.bodyFont
            lb.textAlignment = .justified
            lb.numberOfLines = toastConfig.bodyMaxLines
            return lb
        }()
        
        /// 毛玻璃层
        var blurView: UIVisualEffectView?
        
        /// 背景层（在iOS13之后window）
        var backgroundView = UIView()
        
        /// 设置颜色
        open var tintColor: UIColor!{
            didSet {
                imageView.tintColor = tintColor
                titleLabel.textColor = tintColor
                bodyLabel.textColor = tintColor
            }
        }
        
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
            
            // 布局
            toastConfig.loadSubviews(self)
            toastConfig.reloadData(self)
            toastConfig.layoutSubviews(self)
            
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
        
        @discardableResult
        func blurMask(_ blurEffectStyle: UIBlurEffect.Style?) -> Toast {
            if let s = blurEffectStyle {
                if let bv = blurView {
                    bv.effect = UIBlurEffect.init(style: s)
                } else {
                    blurView = UIVisualEffectView(effect: UIBlurEffect.init(style: s))
                    blurView?.layer.masksToBounds = true
                    blurView?.layer.cornerRadius = toastConfig.cornerRadius
                }
            } else {
                blurView?.removeFromSuperview()
                blurView = nil
            }
            return self
        }
        
        @discardableResult
        func update(title: String?) -> Toast {
            vm.title = title
            titleLabel.text = title
            return self
        }
        
        @discardableResult
        func update(message: String?) -> Toast {
            vm.message = message
            bodyLabel.text = message
            return self
        }
        
        @discardableResult
        func update(icon: UIImage?) -> Toast {
            vm.icon = icon
            imageView.image = icon
            return self
        }
        
//        internal func updateFrame() {
//            let config = toastConfig
//            var f = UIScreen.main.bounds
//            contentStack.frame.size.width = CGFloat.minimum(f.width - 4 * config.margin, config.maxWidth)
//            titleLabel?.sizeToFit()
//            messageLabel?.sizeToFit()
//            contentStack.layoutIfNeeded()
//            f.size.width = contentStack.frame.size.width
//            f.size.height = (textStack.arrangedSubviews.last?.frame.maxY ?? 0) + config.margin
//            debugPrint(f)
//            func updateFrame(_ frame: CGRect) -> CGRect {
//                return CGRect(origin: CGPoint(x: config.margin, y: config.margin), size: frame.size)
//            }
//            func superBounds(_ frame: CGRect) -> CGRect {
//                return CGRect(x: 0, y: 0, width: frame.width + 2 * config.margin, height: frame.height + 2 * config.margin)
//            }
//            contentStack.frame = updateFrame(f)
//            contentView.frame = superBounds(f)
//            view.frame = superBounds(f)
//            window?.frame = superBounds(f)
//            hud.updateToastsLayout()
//        }
        
        // MARK: 设置函数
        
        /// 设置超时时间
        /// - Parameter timeout: 超时时间
        @discardableResult public func timeout(_ timeout: TimeInterval?) -> Toast {
            self.timeout = timeout
            // 超时
            timeoutBlock?.cancel()
            if let t = timeout, t > 0 {
                timeoutBlock = DispatchWorkItem(block: { [weak self] in
                    self?.remove()
                })
                DispatchQueue.main.asyncAfter(deadline: .now()+t, execute: timeoutBlock!)
            } else {
                timeoutBlock = nil
            }
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
            toastConfig.reloadData(self)
            toastConfig.layoutSubviews(self)
            return self
        }
        
        
        
    }
    
}

fileprivate extension ProHUD.Toast {
    
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
                    // FIXME: 重置计时器
                    
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
            let width = CGFloat.minimum(UIScreen.main.bounds.width - 2*config.margin, config.maxWidth)
            let w = UIWindow(frame: .init(x: (UIScreen.main.bounds.width - width) / 2, y: config.margin, width: width, height: 400))
            toast.window = w
            w.windowLevel = UIWindow.Level(5000)
            w.backgroundColor = .clear
            w.layer.shadowRadius = 8
            w.layer.shadowOffset = .init(width: 0, height: 5)
            w.layer.shadowOpacity = 0.2
            w.rootViewController = toast
            
        }
        
        let window = toast.window!
        window.isHidden = false
        toasts.append(toast)
        
        // background & frame
        toast.view.layoutIfNeeded()
        toast.titleLabel.sizeToFit()
        toast.bodyLabel.sizeToFit()
        let width = toast.view.frame.width
        var height = CGFloat(0)
        for v in toast.view.subviews {
            height = CGFloat.maximum(v.frame.maxY, height)
        }
        height += config.padding
        toast.backgroundView.frame.size = CGSize(width: width, height: height)
        window.insertSubview(toast.backgroundView, at: 0)
        window.frame.size.height = height // 这里之后toast.view.frame.height会变成0
        toast.view.frame.size.height = height
        
        updateToastsLayout()
        window.transform = .init(translationX: 0, y: -window.frame.maxY)
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
            if let window = e.window {
                var frame = window.frame
                if i == 0 {
                    if isPortrait {
                        frame.origin.y = Inspire.shared.screen.updatedSafeAreaInsets.top
                    } else {
                        frame.origin.y = config.margin
                    }
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


