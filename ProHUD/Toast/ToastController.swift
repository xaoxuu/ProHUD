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
                vev.effect = UIBlurEffect.init(style: .systemMaterial)
            } else {
                vev.effect = UIBlurEffect.init(style: .extraLight)
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
        public convenience init(scene: Scene = .default, title: String? = nil, message: String? = nil, icon: UIImage? = nil) {
            self.init()
            
            model.scene = scene
            model.title = title
            model.message = message
            model.icon = icon
            switch scene {
            case .loading:
                model.duration = nil
            default:
                model.duration = 2
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
        
    }
    
}

// MARK: - 实例函数

public extension ProHUD.Toast {
    
    // MARK: 生命周期函数
    
    /// 推入屏幕
    func push() {
        ProHUD.push(self)
    }
    
    /// 弹出屏幕
    func pop() {
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
    
    // MARK: 设置函数
    
    /// 设置持续时间
    /// - Parameter duration: 持续时间
    @discardableResult func duration(_ duration: TimeInterval?) -> ProHUD.Toast {
        model.duration = duration
        // 持续时间
        model.durationBlock?.cancel()
        if let t = duration, t > 0 {
            model.durationBlock = DispatchWorkItem(block: { [weak self] in
                self?.pop()
            })
            DispatchQueue.main.asyncAfter(deadline: .now()+t, execute: model.durationBlock!)
        } else {
            model.durationBlock = nil
        }
        return self
    }
    
    /// 点击事件
    /// - Parameter callback: 事件回调
    @discardableResult func didTapped(_ callback: (() -> Void)?) -> ProHUD.Toast {
        model.tapCallback = callback
        return self
    }
    
    /// 消失事件
    /// - Parameter callback: 事件回调
    @discardableResult func didDisappear(_ callback: (() -> Void)?) -> ProHUD.Toast {
        disappearCallback = callback
        return self
    }
    
    /// 更新
    /// - Parameter scene: 场景
    /// - Parameter title: 标题
    /// - Parameter message: 内容
    /// - Parameter icon: 图标
    @discardableResult func update(scene: Scene, title: String? = nil, message: String? = nil, icon: UIImage? = nil) -> ProHUD.Toast {
        model.scene = scene
        model.title = title
        model.message = message
        model.icon = icon
        cfg.toast.reloadData(self)
        return self
    }
    
    /// 更新标题
    /// - Parameter title: 标题
    @discardableResult func update(title: String?) -> ProHUD.Toast {
        model.title = title
        titleLabel.text = title
        return self
    }
    
    /// 更新文本
    /// - Parameter message: 消息
    @discardableResult func update(message: String?) -> ProHUD.Toast {
        model.message = message
        bodyLabel.text = message
        return self
    }
    
    /// 更新图标
    /// - Parameter icon: 图标
    @discardableResult func update(icon: UIImage?) -> ProHUD.Toast {
        model.icon = icon
        imageView.image = icon
        return self
    }
    
}

fileprivate extension ProHUD.Toast {
    
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
}


// MARK: - 实例函数

public extension ProHUD {
    
    /// Toast推入屏幕
    /// - Parameter toast: 实例
    @discardableResult func push(_ toast: Toast) -> Toast {
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
    
    /// Toast推入屏幕
    /// - Parameter toast: 场景
    /// - Parameter title: 标题
    /// - Parameter message: 内容
    /// - Parameter icon: 图标
    @discardableResult func push(toast scene: Toast.Scene, title: String? = nil, message: String? = nil, icon: UIImage? = nil) -> Toast {
        return push(Toast(scene: scene, title: title, message: message, icon: icon))
    }
    
    /// 获取指定的toast
    /// - Parameter identifier: 标识
    func toasts(identifier: String?) -> [Toast] {
        var tt = [Toast]()
        for t in toasts {
            if t.identifier == identifier {
                tt.append(t)
            }
        }
        return tt
    }
    
    /// Toast弹出屏幕
    /// - Parameter toast: 实例
    func pop(toast: Toast) {
        for t in toasts {
            if t == toast {
                t.pop()
            }
        }
    }
    
    /// Toast弹出屏幕
    /// - Parameter identifier: 需要弹出的Toast的标识
    func pop(toast identifier: String?) {
        for t in toasts {
            if t.identifier == identifier {
                t.pop()
            }
        }
    }
    
}


// MARK: 类函数

public extension ProHUD {
    
    /// Toast推入屏幕
    /// - Parameter toast: 实例
    @discardableResult class func push(_ toast: Toast) -> Toast {
        return shared.push(toast)
    }
    
    /// Toast推入屏幕
    /// - Parameter toast: 场景
    /// - Parameter title: 标题
    /// - Parameter message: 内容
    /// - Parameter icon: 图标
    @discardableResult class func push(toast: Toast.Scene, title: String? = nil, message: String? = nil, icon: UIImage? = nil) -> Toast {
        return shared.push(toast: toast, title: title, message: message, icon: icon)
    }
    
    /// 获取指定的toast
    /// - Parameter identifier: 标识
    class func toast(identifier: String?) -> [Toast] {
        return shared.toasts(identifier: identifier)
    }
    
    /// Toast弹出屏幕
    /// - Parameter toast: 实例
    class func pop(toast: Toast) {
        shared.pop(toast: toast)
    }
    
    /// Toast弹出屏幕
    /// - Parameter identifier: 需要弹出的Toast的标识
    class func pop(toast identifier: String?) {
        shared.pop(toast: identifier)
    }
    
}

// MARK: 私有

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
    
    /// 从数组中移除
    /// - Parameter toast: 实例
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


