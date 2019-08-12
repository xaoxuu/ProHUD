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
            let vev = createBlurView()
            vev.layer.masksToBounds = true
            vev.layer.cornerRadius = cfg.toast.cornerRadius
            return vev
        }()
        
        /// 视图模型
        public var vm = ViewModel()
        
        internal var maxY = CGFloat(0)
        
        // MARK: 生命周期
        
        /// 实例化
        /// - Parameter scene: 场景
        /// - Parameter title: 标题
        /// - Parameter message: 内容
        /// - Parameter icon: 图标
        public convenience init(scene: Scene = .default, title: String? = nil, message: String? = nil, icon: UIImage? = nil, duration: TimeInterval? = nil, actions: ((Toast) -> Void)? = nil) {
            self.init()
            vm.vc = self
            
            vm.scene = scene
            vm.title = title
            vm.message = message
            vm.icon = icon
            vm.duration = duration
            actions?(self)
            
            // 点击
            let tap = UITapGestureRecognizer(target: self, action: #selector(privDidTapped(_:)))
            view.addGestureRecognizer(tap)
            // 拖动
            let pan = UIPanGestureRecognizer(target: self, action: #selector(privDidPan(_:)))
            view.addGestureRecognizer(pan)
            
        }
        
        
        public override func viewDidLoad() {
            super.viewDidLoad()
            
            cfg.toast.reloadData(self)
            
        }
        
        
    }
    
}

// MARK: - 实例函数
public extension Toast {
    
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
        Toast.privUpdateToastsLayout()
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
        Toast.pop(self)
    }
    
    
    /// 更新
    /// - Parameter callback: 回调
    func update(_ callback: ((inout ViewModel) -> Void)? = nil) {
        callback?(&vm)
        cfg.toast.reloadData(self)
    }
    
    /// 点击事件
    /// - Parameter callback: 事件回调
    func didTapped(_ callback: (() -> Void)?) {
        vm.tapCallback = callback
    }
    
    func animate(rotate: Bool) {
        if rotate {
            DispatchQueue.main.async {
                let ani = CABasicAnimation(keyPath: "transform.rotation.z")
                ani.toValue = Double.pi * 2.0
                ani.duration = 3
                ani.repeatCount = 10000
                self.imageView.layer.add(ani, forKey: "rotationAnimation")
            }
        } else {
            imageView.layer.removeAllAnimations()
        }
    }
    
}


// MARK: - 实例管理器
public extension Toast {
    
    /// 推入屏幕
    /// - Parameter toast: 场景
    /// - Parameter title: 标题
    /// - Parameter message: 内容
    /// - Parameter actions: 更多操作
    @discardableResult class func push(scene: Toast.Scene = .default, title: String? = nil, message: String? = nil, duration: TimeInterval? = nil, _ actions: ((Toast) -> Void)? = nil) -> Toast {
        return Toast(scene: scene, title: title, message: message, duration: duration, actions: actions).push()
    }
    
    /// 获取指定的toast
    /// - Parameter identifier: 标识
    class func find(_ identifier: String?) -> [Toast] {
        var tt = [Toast]()
        for t in toasts {
            if t.identifier == identifier {
                tt.append(t)
            }
        }
        return tt
    }
    
    /// 查找指定的实例
    /// - Parameter identifier: 标识
    /// - Parameter last: 已经存在（获取最后一个）
    /// - Parameter none: 不存在
    class func find(_ identifier: String?, last: ((Toast) -> Void)? = nil, none: (() -> Void)? = nil) {
        if let t = find(identifier).last {
            last?(t)
        } else {
            none?()
        }
    }
    
    /// 弹出屏幕
    /// - Parameter toast: 实例
    class func pop(_ toast: Toast) {
        toast.willDisappearCallback?()
        if toasts.count > 1 {
            for (i, t) in toasts.enumerated() {
                if t == toast {
                    toasts.remove(at: i)
                }
            }
            privUpdateToastsLayout()
        } else if toasts.count == 1 {
            toasts.removeAll()
        } else {
            debug("漏洞：已经没有toast了")
        }
        UIView.animateForToast(animations: {
            toast.window?.transform = .init(translationX: 0, y: -20-toast.maxY)
        }) { (done) in
            toast.view.removeFromSuperview()
            toast.removeFromParent()
            toast.window = nil
        }
    }
    
    /// 弹出屏幕
    /// - Parameter identifier: 指定实例的标识
    class func pop(_ identifier: String?) {
        for t in find(identifier) {
            t.pop()
        }
    }
    
}

// MARK: - 创建和设置
fileprivate var willprivUpdateToastsLayout: DispatchWorkItem?

fileprivate extension Toast {
    
    /// 点击事件
    /// - Parameter sender: 手势
    @objc func privDidTapped(_ sender: UITapGestureRecognizer) {
        vm.tapCallback?()
    }
    
    /// 拖拽事件
    /// - Parameter sender: 手势
    @objc func privDidPan(_ sender: UIPanGestureRecognizer) {
        vm.durationBlock?.cancel()
        let point = sender.translation(in: sender.view)
        window?.transform = .init(translationX: 0, y: point.y)
        if sender.state == .recognized {
            let v = sender.velocity(in: sender.view)
            if vm.isRemovable == true && (((window?.frame.origin.y ?? 0) < 0 && v.y < 0) || v.y < -1200) {
                // 移除
                self.pop()
            } else {
                UIView.animateForToast(animations: {
                    self.window?.transform = .identity
                }) { (done) in
                    let d = self.vm.duration
                    self.vm.duration = d
                }
            }
        }
    }
    
    class func privUpdateToastsLayout() {
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
                    e.maxY = y + window.frame.size.height
                    UIView.animateForToast {
                        window.frame.origin.y = y
                    }
                }
            }
        }
        willprivUpdateToastsLayout?.cancel()
        willprivUpdateToastsLayout = DispatchWorkItem(block: {
            f()
        })
        DispatchQueue.main.asyncAfter(deadline: .now()+0.001, execute: willprivUpdateToastsLayout!)
    }
    
}


