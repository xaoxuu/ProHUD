//
//  Alert.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/23.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit
import SnapKit

public typealias Alert = ProHUD.Alert

public extension ProHUD {
    class Alert: HUDController {
        
        internal static var alerts = [Alert]()
        
        internal static var alertWindow: UIWindow?
        
        /// 内容视图
        public var contentView = BlurView()
        
        /// 内容容器（包括icon、textStack、actionStack)
        public var contentStack: StackContainer = {
            let stack = StackContainer()
            stack.spacing = cfg.alert.margin
            return stack
        }()
        
        /// 文本区容器
        public var textStack: StackContainer = {
            let stack = StackContainer()
            stack.spacing = cfg.alert.margin
            return stack
        }()
        
        /// 图片
        public var imageView: UIImageView?
        
        /// 标题
        public var titleLabel: UILabel?
        
        /// 正文
        public var bodyLabel: UILabel?
        
        /// 操作区域
        public var actionStack: StackContainer = {
            let stack = StackContainer()
            stack.alignment = .fill
            stack.spacing = cfg.alert.margin
            return stack
        }()
        
        /// 视图模型
        public var vm = ViewModel()
        
        // MARK: 生命周期
        internal var isLoadFinished = false
        
        /// 实例化
        /// - Parameter scene: 场景
        /// - Parameter title: 标题
        /// - Parameter message: 内容
        /// - Parameter icon: 图标
        public convenience init(scene: Scene = .default, title: String? = nil, message: String? = nil, icon: UIImage? = nil, actions: ((inout ViewModel) -> Void)? = nil) {
            self.init()
            vm.vc = self
            vm.scene = scene
            vm.title = title
            vm.message = message
            vm.icon = icon
            actions?(&vm)
        }
        
        public override func viewDidLoad() {
            super.viewDidLoad()
            view.tintColor = cfg.alert.tintColor
            cfg.alert.reloadData(self)
            isLoadFinished = true
        }
        
    }
    
}

// MARK: - 实例函数

public extension Alert {
    
    // MARK: 生命周期函数
    
    /// 推入屏幕
    @discardableResult func push() -> Alert {
        if Alert.alerts.contains(self) == false {
            let window = Alert.getAlertWindow(self)
            window.makeKeyAndVisible()
            window.resignKey()
            window.addSubview(view)
            view.transform = .init(scaleX: 1.2, y: 1.2)
            view.alpha = 0
            UIView.animateForAlertBuildIn {
                self.view.transform = .identity
                self.view.alpha = 1
                window.backgroundColor = window.backgroundColor?.withAlphaComponent(0.6)
            }
            Alert.alerts.append(self)
        }
        Alert.updateAlertsLayout()
        return self
    }
    
    /// 弹出屏幕
    func pop() {
        let window = Alert.getAlertWindow(self)
        Alert.removeItemFromArray(alert: self)
        UIView.animateForAlertBuildOut(animations: {
            self.view.alpha = 0
            self.view.transform = .init(scaleX: 1.08, y: 1.08)
        }) { (done) in
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
        // hide window
        let count = Alert.alerts.count
        if count == 0 && Alert.alertWindow != nil {
            UIView.animateForAlertBuildOut(animations: {
                window.backgroundColor = window.backgroundColor?.withAlphaComponent(0)
            }) { (done) in
                Alert.alertWindow = nil
            }
        }
    }
    
    
    // MARK: 设置函数
    
    
    /// 最小化事件
    /// - Parameter callback: 事件回调
    @discardableResult func didForceQuit(_ callback: (() -> Void)?) -> Alert {
        vm.forceQuitCallback = callback
        return self
    }
    
    /// 消失事件
    /// - Parameter callback: 事件回调
    @discardableResult func didDisappear(_ callback: (() -> Void)?) -> Alert {
        disappearCallback = callback
        return self
    }
    
    /// 更新
    /// - Parameter callback: 回调
    func update(_ callback: ((inout Alert.ViewModel) -> Void)? = nil) {
        callback?(&vm)
        cfg.alert.reloadData(self)
    }
    
    func animate(rotate: Bool) {
        if rotate {
            DispatchQueue.main.async {
                let ani = CABasicAnimation(keyPath: "transform.rotation.z")
                ani.toValue = Double.pi * 2.0
                ani.duration = 3
                ani.repeatCount = 10000
                self.imageView?.layer.add(ani, forKey: "rotationAnimation")
            }
        } else {
            imageView?.layer.removeAllAnimations()
        }
    }
    
    
    
    
}


// MARK: 类函数

public extension Alert {
    
    /// 推入屏幕
    /// - Parameter alert: 场景
    /// - Parameter title: 标题
    /// - Parameter message: 正文
    /// - Parameter actions: 更多操作
    @discardableResult class func push(scene: Alert.Scene, title: String? = nil, message: String? = nil, actions: ((inout Alert.ViewModel) -> Void)? = nil) -> Alert {
        return Alert(scene: scene, title: title, message: message, actions: actions).push()
    }
    
    /// 获取指定的实例
    /// - Parameter identifier: 指定实例的标识
    class func alerts(_ identifier: String?) -> [Alert] {
        var aa = [Alert]()
        for a in Alert.alerts {
            if a.vm.identifier == identifier {
                aa.append(a)
            }
        }
        return aa
    }
    
    /// 弹出屏幕
    /// - Parameter alert: 实例
    class func pop(_ alert: Alert) {
        alert.pop()
    }
    
    /// 弹出屏幕
    /// - Parameter identifier: 指定实例的标识
    class func pop(_ identifier: String?) {
        for a in alerts(identifier) {
            a.pop()
        }
    }
    
}

// MARK: - 私有

internal extension Alert {
    
    /// 移除按钮
    /// - Parameter index: 索引
    @discardableResult func privRemoveAction(index: Int) -> Alert {
        if index < 0 {
            for view in self.actionStack.arrangedSubviews {
                if let btn = view as? UIButton {
                    btn.removeFromSuperview()
                }
            }
        } else if index < self.actionStack.arrangedSubviews.count, let btn = self.actionStack.arrangedSubviews[index] as? UIButton {
            btn.removeFromSuperview()
        }
        if self.actionStack.arrangedSubviews.count == 0 {
            self.actionStack.removeFromSuperview()
        }
        UIView.animateForAlert {
            self.view.layoutIfNeeded()
        }
        return self
    }
    
    @discardableResult func privAddButton(custom button: UIButton, at index: Int? = nil, handler: (() -> Void)?) -> UIButton {
        if actionStack.superview == nil {
            contentStack.addArrangedSubview(actionStack)
            contentStack.layoutIfNeeded()
        }
        if let idx = index, idx < actionStack.arrangedSubviews.count {
            actionStack.insertArrangedSubview(button, at: idx)
        } else {
            actionStack.addArrangedSubview(button)
        }
        
        addTouchUpAction(for: button) { [weak self] in
            handler?()
            if button.tag == UIAlertAction.Style.cancel.rawValue {
                self?.pop()
            }
        }
        if isLoadFinished {
            actionStack.layoutIfNeeded()
            UIView.animateForAlert {
                self.view.layoutIfNeeded()
            }
        }
        return button
    }
    
    func privUpdateButton(action index: Int, style: UIAlertAction.Style, title: String?, _ handler: (() -> Void)?) {
        if index < self.actionStack.arrangedSubviews.count, let btn = self.actionStack.arrangedSubviews[index] as? UIButton {
            btn.setTitle(title, for: .normal)
            if let b = btn as? Button {
                b.update(style: style)
            }
            if let _ = buttonEvents[btn] {
                buttonEvents.removeValue(forKey: btn)
            }
            addTouchUpAction(for: btn) { [weak self] in
                handler?()
                if btn.tag == UIAlertAction.Style.cancel.rawValue {
                    self?.pop()
                }
            }
        }
    }
    
}

fileprivate extension Alert {
    class func updateAlertsLayout() {
        for (i, a) in alerts.reversed().enumerated() {
            let scale = CGFloat(pow(0.7, CGFloat(i)))
            UIView.animate(withDuration: 1.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: [.allowUserInteraction, .curveEaseInOut], animations: {
                let y = -50 * CGFloat(i) * CGFloat(pow(0.8, CGFloat(i)))
                a.view.transform = CGAffineTransform.init(translationX: 0, y: y).scaledBy(x: scale, y: scale)
            }) { (done) in
                
            }
        }
    }
    class func getAlertWindow(_ vc: UIViewController) -> UIWindow {
        if let w = alertWindow {
            return w
        }
        let w = UIWindow()
        alertWindow = w
        w.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        // 比原生alert层级低一点
        w.windowLevel = UIWindow.Level.alert - 1
        return w
    }
    
    class func removeItemFromArray(alert: Alert) {
        if alerts.count > 1 {
            for (i, a) in alerts.enumerated() {
                if a == alert {
                    if i < alerts.count {
                        alerts.remove(at: i)
                    }
                }
            }
            updateAlertsLayout()
        } else if alerts.count == 1 {
            alerts.removeAll()
        } else {
            debug("漏洞：已经没有alert了")
        }
    }
    
}

