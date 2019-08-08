//
//  ToastController.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/31.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit
import Inspire

public typealias Toast = ProHUD.Toast

public extension ProHUD {
    class Toast: HUDController {
        
        internal static var toasts = [Toast]()
        
        public var window: UIWindow?
        
        /// 图标
        public lazy var imageView: UIImageView = {
            let imgv = UIImageView()
            imgv.contentMode = .scaleAspectFit
            return imgv
        }()
        
        /// 标题
        public lazy var titleLabel: UILabel = {
            let lb = UILabel()
            lb.textColor = cfg.primaryLabelColor
            lb.font = cfg.toast.titleFont
            lb.textAlignment = .justified
            lb.numberOfLines = cfg.toast.titleMaxLines
            return lb
        }()
        
        /// 正文
        public lazy var bodyLabel: UILabel = {
            let lb = UILabel()
            lb.textColor = cfg.secondaryLabelColor
            lb.font = cfg.toast.bodyFont
            lb.textAlignment = .justified
            lb.numberOfLines = cfg.toast.bodyMaxLines
            return lb
        }()
        
        /// 背景层
        public var backgroundView: UIVisualEffectView = {
            let vev = UIVisualEffectView()
            if #available(iOS 13.0, *) {
//                vev.effect = UIBlurEffect.init(style: .systemMaterial))
                vev.effect = UIBlurEffect.init(style: .extraLight)
            } else if #available(iOS 11.0, *) {
                vev.effect = UIBlurEffect.init(style: .extraLight)
            } else {
                vev.effect = .none
                vev.backgroundColor = .white
            }
            vev.layer.masksToBounds = true
            vev.layer.cornerRadius = cfg.toast.cornerRadius
            return vev
        }()
        
        /// 视图模型
        public var model = ViewModel()
        
        // MARK: 生命周期
        
        /// 实例化
        /// - Parameter scene: 场景
        /// - Parameter title: 标题
        /// - Parameter message: 内容
        /// - Parameter icon: 图标
        public convenience init(scene: Scene = .default, title: String? = nil, message: String? = nil, icon: UIImage? = nil, actions: ((Toast) -> Void)? = nil) {
            self.init()
            
            model.scene = scene
            model.title = title
            model.message = message
            model.icon = icon
            actions?(self)
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
        
        
    }
    
}

// MARK: - 实例函数

public extension Toast {
    
    // MARK: 生命周期函数
    
    /// 推入屏幕
    @discardableResult func push() -> Toast {
        let config = cfg.toast
        let isNew: Bool
        if self.window == nil {
            let w = UIWindow(frame: .zero)
            self.window = w
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
        
        let window = self.window!
        // background & frame
        // 设定正确的宽度，更新子视图
        let width = CGFloat.minimum(UIScreen.main.bounds.width - 2*config.margin, config.maxWidth)
        view.frame.size = CGSize(width: width, height: 800)
        titleLabel.sizeToFit()
        bodyLabel.sizeToFit()
        view.layoutIfNeeded()
        // 更新子视图之后获取正确的高度
        var height = CGFloat(0)
        for v in self.view.subviews {
            height = CGFloat.maximum(v.frame.maxY, height)
        }
        height += config.padding
        // 应用到frame
        window.frame = CGRect(x: (UIScreen.main.bounds.width - width) / 2, y: 0, width: width, height: height)
        backgroundView.frame.size = window.frame.size
        window.insertSubview(backgroundView, at: 0)
        window.rootViewController = self // 此时toast.view.frame.size会自动更新为window.frame.size
        // 根据在屏幕中的顺序，确定y坐标
        if Toast.toasts.contains(self) == false {
             Toast.toasts.append(self)
        }
        Toast.updateToastsLayout()
        if isNew {
            window.transform = .init(translationX: 0, y: -window.frame.maxY)
            UIView.animateForToast {
                window.transform = .identity
            }
        } else {
            view.layoutIfNeeded()
        }
        return self
    }
    
    /// 弹出屏幕
    func pop() {
        Toast.removeItemFromArray(toast: self)
        UIView.animateForToast(animations: {
            let frame = self.window?.frame ?? .zero
            self.window?.transform = .init(translationX: 0, y: -200-frame.maxY)
        }) { (done) in
            self.view.removeFromSuperview()
            self.removeFromParent()
            self.window = nil
        }
    }
    
    // MARK: 设置函数
    
    /// 设置持续时间
    /// - Parameter duration: 持续时间
    @discardableResult func duration(_ duration: TimeInterval?) -> Toast {
        model.setupDuration(duration: duration) { [weak self] in
            self?.pop()
        }
        return self
    }
    
    /// 点击事件
    /// - Parameter callback: 事件回调
    @discardableResult func didTapped(_ callback: (() -> Void)?) -> Toast {
        model.tapCallback = callback
        return self
    }
    
    /// 消失事件
    /// - Parameter callback: 事件回调
    @discardableResult func didDisappear(_ callback: (() -> Void)?) -> Toast {
        disappearCallback = callback
        return self
    }
    
    /// 更新
    /// - Parameter scene: 场景
    /// - Parameter title: 标题
    /// - Parameter message: 内容
    @discardableResult func update(scene: Scene, title: String?, message: String?) -> Toast {
        model.scene = scene
        model.title = title
        model.message = message
        cfg.toast.reloadData(self)
        return self
    }
    
    /// 更新标题
    /// - Parameter title: 标题
    @discardableResult func update(title: String?) -> Toast {
        model.title = title
        cfg.toast.reloadData(self)
        return self
    }
    
    /// 更新文本
    /// - Parameter message: 消息
    @discardableResult func update(message: String?) -> Toast {
        model.message = message
        cfg.toast.reloadData(self)
        return self
    }
    
    /// 更新图标
    /// - Parameter icon: 图标
    @discardableResult func update(icon: UIImage?) -> Toast {
        model.icon = icon
        cfg.toast.reloadData(self)
        return self
    }
    
}


// MARK: 类函数

public extension Toast {
    
    /// 推入屏幕
    /// - Parameter toast: 场景
    /// - Parameter title: 标题
    /// - Parameter message: 内容
    /// - Parameter actions: 更多操作
    @discardableResult class func push(toast scene: Toast.Scene, title: String? = nil, message: String? = nil, actions: ((Toast) -> Void)? = nil) -> Toast {
        return Toast(scene: scene, title: title, message: message, actions: actions).push()
    }
    
    /// 获取指定的toast
    /// - Parameter identifier: 标识
    class func toasts(_ identifier: String?) -> [Toast] {
        var tt = [Toast]()
        for t in toasts {
            if t.identifier == identifier {
                tt.append(t)
            }
        }
        return tt
    }
    
    /// 弹出屏幕
    /// - Parameter toast: 实例
    class func pop(_ toast: Toast) {
        toast.pop()
    }
    
    /// 弹出屏幕
    /// - Parameter identifier: 指定实例的标识
    class func pop(_ identifier: String?) {
        for t in toasts(identifier) {
            t.pop()
        }
    }
    
}

// MARK: 私有

fileprivate var willUpdateToastsLayout: DispatchWorkItem?

fileprivate extension Toast {
    
    /// 点击事件
    /// - Parameter sender: 手势
    @objc func privDidTapped(_ sender: UITapGestureRecognizer) {
        model.tapCallback?()
    }
    
    /// 拖拽事件
    /// - Parameter sender: 手势
    @objc func privDidPan(_ sender: UIPanGestureRecognizer) {
        model.durationBlock?.cancel()
        let point = sender.translation(in: sender.view)
        window?.transform = .init(translationX: 0, y: point.y)
        if sender.state == .recognized {
            let v = sender.velocity(in: sender.view)
            if model.removable == true && (((window?.frame.origin.y ?? 0) < 0 && v.y < 0) || v.y < -1200) {
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
    
    /// 从数组中移除
    /// - Parameter toast: 实例
    class func removeItemFromArray(toast: Toast) {
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
    class func updateToastsLayout() {
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


