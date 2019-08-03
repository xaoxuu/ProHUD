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
            lb.textColor = cfg.primaryLabelColor
            lb.font = cfg.toast.titleFont
            lb.textAlignment = .justified
            lb.numberOfLines = cfg.toast.titleMaxLines
            return lb
        }()
        
        /// 正文
        internal lazy var bodyLabel: UILabel = {
            let lb = UILabel()
            lb.textColor = cfg.secondaryLabelColor
            lb.font = cfg.toast.bodyFont
            lb.textAlignment = .justified
            lb.numberOfLines = cfg.toast.bodyMaxLines
            return lb
        }()
        
        /// 背景层
        var backgroundView: UIVisualEffectView = {
            let vev = UIVisualEffectView()
            if #available(iOS 13.0, *) {
                vev.effect = UIBlurEffect.init(style: .systemMaterial)
            } else {
                vev.effect = UIBlurEffect.init(style: .extraLight)
            }
            vev.layer.masksToBounds = true
            vev.layer.cornerRadius = cfg.toast.cornerRadius
            return vev
        }()
        
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
            cfg.toast.loadSubviews(self)
            cfg.toast.reloadData(self)
            
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
        public func pop() {
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
        
        
        // MARK: 设置函数
        
        /// 设置超时时间
        /// - Parameter timeout: 超时时间
        @discardableResult public func timeout(_ timeout: TimeInterval?) -> Toast {
            self.timeout = timeout
            // 超时
            timeoutBlock?.cancel()
            if let t = timeout, t > 0 {
                timeoutBlock = DispatchWorkItem(block: { [weak self] in
                    self?.pop()
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
            cfg.toast.reloadData(self)
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
                self.pop()
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
    func push(_ toast: Toast) -> Toast {
        let config = cfg.toast
        let isNew: Bool
        if toast.window == nil {
            let w = ToastWindow(frame: .zero)
            toast.window = w
            w.windowLevel = UIWindow.Level(5000)
            w.backgroundColor = .clear
            w.layer.shadowRadius = 8
            w.layer.shadowOffset = .init(width: 0, height: 5)
            w.layer.shadowOpacity = 0.2
            w.isHidden = false
            isNew = true
        } else {
            isNew = false
        }
        
        let window = toast.window!
        // background & frame
        // 设定正确的宽度，更新子视图
        let width = CGFloat.minimum(UIScreen.main.bounds.width - 2*config.margin, config.maxWidth)
        toast.view.frame.size = CGSize(width: width, height: 800)
        toast.titleLabel.sizeToFit()
        toast.bodyLabel.sizeToFit()
        toast.view.layoutIfNeeded()
        // 更新子视图之后获取正确的高度
        var height = CGFloat(0)
        for v in toast.view.subviews {
            height = CGFloat.maximum(v.frame.maxY, height)
        }
        height += config.padding
        // 应用到frame
        window.frame = CGRect(x: (UIScreen.main.bounds.width - width) / 2, y: 0, width: width, height: height)
        toast.backgroundView.frame.size = window.frame.size
        window.insertSubview(toast.backgroundView, at: 0)
        window.rootViewController = toast // 此时toast.view.frame.size会自动更新为window.frame.size
        // 根据在屏幕中的顺序，确定y坐标
        if toasts.contains(toast) == false {
            toasts.append(toast)
        }
        updateToastsLayout()
        if isNew {
            window.transform = .init(translationX: 0, y: -window.frame.maxY)
            UIView.animateForToast {
                window.transform = .identity
            }
        } else {
            toast.view.layoutIfNeeded()
        }
        return toast
    }
    
    @discardableResult
    func push(toast: Toast.Scene, title: String? = nil, message: String? = nil, icon: UIImage? = nil) -> Toast {
        return push(Toast(scene: toast, title: title, message: message, icon: icon))
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
    
    func pop(toast: Toast) {
        for t in toasts {
            if t == toast {
                t.pop()
            }
        }
    }
    
    func pop(toast identifier: String?) {
        for t in toasts {
            if t.identifier == identifier {
                t.pop()
            }
        }
    }
}


// MARK: AlertHUD public class func

public extension ProHUD {
    
    @discardableResult
    class func push(_ toast: Toast) -> Toast {
        return shared.push(toast)
    }
    
    @discardableResult
    class func show(toast: Toast.Scene, title: String? = nil, message: String? = nil, icon: UIImage? = nil) -> Toast {
        return shared.push(toast: toast, title: title, message: message, icon: icon)
    }
    
    class func toast(identifier: String?) -> [Toast] {
        return shared.toasts(identifier: identifier)
    }
    
    class func pop(toast: Toast) {
        shared.pop(toast: toast)
    }
    
    class func pop(toast identifier: String?) {
        shared.pop(toast: identifier)
    }
    
}

// MARK: AlertHUD private func

fileprivate var willUpdateToastsLayout: DispatchWorkItem?

internal extension ProHUD {
    func updateToastsLayout() {
        func f() {
            let top = Inspire.shared.screen.updatedSafeAreaInsets.top
            for (i, e) in toasts.enumerated() {
                let config = cfg.toast
                if let window = e.window {
                    var y = window.frame.origin.y
                    if i == 0 {
                        if isPortrait {
                            y = top
                        } else {
                            y = config.margin
                        }
                    } else {
                        let lastY = toasts[i-1].window?.frame.maxY ?? .zero
                        y = lastY + config.margin
                    }
                    UIView.animateForToast {
                        e.window?.frame.origin.y = y
                    }
                }
            }
        }
        willUpdateToastsLayout?.cancel()
        willUpdateToastsLayout = DispatchWorkItem(block: {
            f()
        })
        DispatchQueue.main.asyncAfter(deadline: .now()+0.001, execute: willUpdateToastsLayout!)
    }
    
}

internal extension ProHUD {
    
    
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
            debug("漏洞：已经没有toast了")
        }
    }
    
}


