//
//  Alert.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/23.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit
import SnapKit

public extension ProHUD {
    class Alert: HUDController {
        
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
        public var model = ViewModel()
        
        
        // MARK: 生命周期
        
        /// 实例化
        /// - Parameter scene: 场景
        /// - Parameter title: 标题
        /// - Parameter message: 内容
        /// - Parameter icon: 图标
        public convenience init(scene: Scene = .default, title: String? = nil, message: String? = nil, icon: UIImage? = nil) {
            self.init()
            view.tintColor = cfg.alert.tintColor
            model.scene = scene
            model.title = title
            model.message = message
            model.icon = icon
            
            willLayoutSubviews()
            
        }
        
        
    }
    
}

// MARK: - 实例函数

public extension ProHUD.Alert {
    
    // MARK: 生命周期函数
    
    /// 推入屏幕
    @discardableResult func push() -> ProHUD.Alert {
        return ProHUD.push(self)
    }
    
    /// 弹出屏幕
    func pop() {
        let hud = ProHUD.shared
        let window = hud.getAlertWindow(self)
        hud.removeItemFromArray(alert: self)
        UIView.animateForAlertBuildOut(animations: {
            self.view.alpha = 0
            self.view.transform = .init(scaleX: 1.08, y: 1.08)
        }) { (done) in
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
        // hide window
        let count = hud.alerts.count
        if count == 0 && hud.alertWindow != nil {
            UIView.animateForAlertBuildOut(animations: {
                window.backgroundColor = window.backgroundColor?.withAlphaComponent(0)
            }) { (done) in
                hud.alertWindow = nil
            }
        }
    }
    
    
    // MARK: 设置函数
    
    /// 添加按钮
    /// - Parameter style: 样式
    /// - Parameter text: 标题
    /// - Parameter action: 事件
    @discardableResult func add(action style: UIAlertAction.Style, title: String?, handler: (() -> Void)?) -> ProHUD.Alert {
        if let btn = privAddButton(custom: Button.actionButton(title: title), action: handler) as? Button {
            btn.update(style: style)
        }
        return self
    }
    
    /// 添加按钮
    /// - Parameter button: 按钮
    /// - Parameter action: 事件
    @discardableResult func add(button: UIButton, action: (() -> Void)?) -> ProHUD.Alert {
        privAddButton(custom: button, action: action)
        return self
    }
    
    /// 最小化事件
    /// - Parameter callback: 事件回调
    @discardableResult func didForceQuit(_ callback: (() -> Void)?) -> ProHUD.Alert {
        model.forceQuitCallback = callback
        return self
    }
    
    /// 消失事件
    /// - Parameter callback: 事件回调
    @discardableResult func didDisappear(_ callback: (() -> Void)?) -> ProHUD.Alert {
        disappearCallback = callback
        return self
    }
    
    /// 设置持续时间
    /// - Parameter duration: 持续时间
    @discardableResult func duration(_ duration: TimeInterval?) -> ProHUD.Alert {
        model.setupDuration(duration: duration) { [weak self] in
            self?.pop()
        }
        return self
    }
    
    /// 更新
    /// - Parameter scene: 场景
    /// - Parameter title: 标题
    /// - Parameter message: 正文
    @discardableResult func update(scene: Scene, title: String?, message: String?) -> ProHUD.Alert {
        model.scene = scene
        model.title = title
        model.message = message
        willLayoutSubviews()
        return self
    }
    
    /// 更新图标
    /// - Parameter icon: 图标
    @discardableResult func update(icon: UIImage?) -> ProHUD.Alert {
        model.icon = icon
        cfg.alert.reloadData(self)
        imageView?.layer.removeAllAnimations()
        return self
    }
    
    /// 更新按钮
    /// - Parameter index: 索引
    /// - Parameter style: 样式
    /// - Parameter title: 标题
    /// - Parameter action: 事件
    @discardableResult func update(action index: Int, style: UIAlertAction.Style, title: String?, action: (() -> Void)?) -> ProHUD.Alert {
        return update(action: index, button: { (btn) in
            btn.setTitle(title, for: .normal)
            if let b = btn as? Button {
                b.update(style: style)
            }
            btn.layoutIfNeeded()
        }, action: action)
    }
    
    /// 更新按钮
    /// - Parameter index: 索引
    /// - Parameter button: 按钮
    /// - Parameter action: 事件
    @discardableResult func update(action index: Int, button: (UIButton) -> Void, action: (() -> Void)? = nil) -> ProHUD.Alert {
        if index < self.actionStack.arrangedSubviews.count, let btn = self.actionStack.arrangedSubviews[index] as? UIButton {
            button(btn)
            if let ac = action {
                addTouchUpAction(for: btn, action: ac)
            }
        }
        UIView.animateForAlert {
            self.view.layoutIfNeeded()
        }
        return self
    }
    
    /// 移除按钮
    /// - Parameter index: 索引
    @discardableResult func remove(action index: Int...) -> ProHUD.Alert {
        for (i, idx) in index.enumerated() {
            privRemoveAction(index: idx-i)
        }
        return self
    }
    
}



// MARK: - 实例函数

public extension ProHUD {
    
    /// 推入屏幕
    /// - Parameter alert: 实例
    @discardableResult func push(_ alert: Alert) -> Alert {
        if alerts.contains(alert) == false {
            let window = getAlertWindow(alert)
            window.makeKeyAndVisible()
            window.resignKey()
            window.addSubview(alert.view)
            alert.view.transform = .init(scaleX: 1.2, y: 1.2)
            alert.view.alpha = 0
            UIView.animateForAlertBuildIn {
                alert.view.transform = .identity
                alert.view.alpha = 1
                window.backgroundColor = window.backgroundColor?.withAlphaComponent(0.6)
            }
            alerts.append(alert)
        }
        updateAlertsLayout()
        
        // setup duration
        if let _ = alert.model.duration, alert.model.durationBlock == nil {
            alert.duration(alert.model.duration)
        }
        return alert
    }
    
    /// 推入屏幕
    /// - Parameter alert: 场景
    /// - Parameter title: 标题
    /// - Parameter message: 正文
    /// - Parameter icon: 图标
    @discardableResult func push(alert scene: Alert.Scene, title: String? = nil, message: String? = nil, actions: ((Alert) -> Void)? = nil) -> Alert {
        let a = Alert(scene: scene, title: title, message: message)
        actions?(a)
        a.view.layoutIfNeeded()
        return push(a)
    }
    
    /// 获取指定的实例
    /// - Parameter identifier: 指定实例的标识
    func alert(_ identifier: String?) -> Alert? {
        var aa = [Alert]()
        for a in alerts {
            if a.identifier == identifier {
                aa.append(a)
            }
        }
        return aa.last
    }
    
    /// 弹出屏幕
    /// - Parameter alert: 实例
    func pop(_ alert: Alert) {
        for a in alerts {
            if a == alert {
                a.pop()
            }
        }
    }
    
    /// 弹出实例
    /// - Parameter identifier: 指定实例的标识
    func pop(alert identifier: String?) {
        for a in alerts {
            if a.identifier == identifier {
                a.pop()
            }
        }
    }
    
}


// MARK: 类函数

public extension ProHUD {
    
    /// 推入屏幕
    /// - Parameter alert: 实例
    @discardableResult class func push(_ alert: Alert) -> Alert {
        return shared.push(alert)
    }
    
    /// 推入屏幕
    /// - Parameter alert: 场景
    /// - Parameter title: 标题
    /// - Parameter message: 正文
    /// - Parameter icon: 图标
    @discardableResult class func push(alert: Alert.Scene, title: String? = nil, message: String? = nil, actions: ((Alert) -> Void)? = nil) -> Alert {
        return shared.push(alert: alert, title: title, message: message, actions: actions)
    }
    
    /// 获取指定的实例
    /// - Parameter identifier: 指定实例的标识
    class func alert(_ identifier: String?) -> Alert? {
        return shared.alert(identifier)
    }
    
    /// 弹出屏幕
    /// - Parameter alert: 实例
    class func pop(_ alert: Alert) {
        shared.pop(alert)
    }
    
    /// 弹出实例
    /// - Parameter identifier: 指定实例的标识
    class func pop(alert identifier: String?) {
        shared.pop(alert: identifier)
    }
    
}

// MARK: - 私有

fileprivate extension ProHUD.Alert {
    
    /// 移除按钮
    /// - Parameter index: 索引
    @discardableResult func privRemoveAction(index: Int) -> ProHUD.Alert {
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
        willLayoutSubviews()
        UIView.animateForAlert {
            self.view.layoutIfNeeded()
        }
        return self
    }
    
    func willLayoutSubviews() {
        model.setupWillLayout(duration: 0.001) { [weak self] in
            if let a = self {
                // 布局
                cfg.alert.loadSubviews(a)
                cfg.alert.reloadData(a)
                // 强制退出按钮
                a.model.setupForceQuit(duration: cfg.alert.forceQuitTimer) { [weak self] in
                    if let aa = self, aa.actionStack.superview == nil {
                        cfg.alert.loadForceQuitButton(aa)
                    }
                }
            }
        }
    }
    
    @discardableResult func privAddButton(custom button: UIButton, action: (() -> Void)?) -> UIButton {
        model.duration = nil
        if actionStack.superview == nil {
            contentStack.addArrangedSubview(actionStack)
        }
        self.view.layoutIfNeeded()
        button.transform = .init(scaleX: 1, y: 0.001)
        actionStack.addArrangedSubview(button)
        UIView.animateForAlert {
            button.transform = .identity
            self.view.layoutIfNeeded()
        }
        addTouchUpAction(for: button) { [weak self] in
            action?()
            if button.tag == UIAlertAction.Style.cancel.rawValue {
                self?.pop()
            }
        }
        willLayoutSubviews()
        return button
    }
    
}

internal extension ProHUD {
    
    func updateAlertsLayout() {
        for (i, a) in alerts.reversed().enumerated() {
            let scale = CGFloat(pow(0.7, CGFloat(i)))
            UIView.animate(withDuration: 1.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: [.allowUserInteraction, .curveEaseInOut], animations: {
                let y = -50 * CGFloat(i) * CGFloat(pow(0.8, CGFloat(i)))
                a.view.transform = CGAffineTransform.init(translationX: 0, y: y).scaledBy(x: scale, y: scale)
            }) { (done) in
                
            }
        }
    }
}

fileprivate extension ProHUD {
    
    func getAlertWindow(_ vc: UIViewController) -> UIWindow {
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
    
    func removeItemFromArray(alert: Alert) {
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

