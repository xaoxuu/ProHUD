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
        
        /// 内容容器
        public var contentView = BlurView()
        
        /// 正文（包括icon、textStack、actionStack)
        internal var contentStack: StackContainer = {
            let stack = StackContainer()
            stack.spacing = cfg.alert.margin
            return stack
        }()
        
        /// 文本区域
        internal var textStack: StackContainer = {
            let stack = StackContainer()
            stack.spacing = cfg.alert.margin
            return stack
        }()
        internal var imageView: UIImageView?
        internal var titleLabel: UILabel?
        internal var messageLabel: UILabel?
        /// 操作区域
        internal var actionStack: StackContainer = {
            let stack = StackContainer()
            stack.alignment = .fill
            stack.spacing = cfg.alert.margin
            return stack
        }()
        
        /// 视图模型
        public var vm = ViewModel()
        
        /// 显示顶部按钮（最小化）
        internal var showNavButtonsBlock: DispatchWorkItem?
        
        internal var minimizeCallback: (() -> Void)?
        
        // MARK: 生命周期
        
        /// 实例化
        /// - Parameter scene: 场景
        /// - Parameter title: 标题
        /// - Parameter message: 内容
        /// - Parameter icon: 图标
        public convenience init(scene: Scene = .default, title: String? = nil, message: String? = nil, icon: UIImage? = nil) {
            self.init()
            view.tintColor = cfg.alert.tintColor
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
            
            willLayoutSubviews()
            
        }
        
        public override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            disappearCallback?()
        }
        
        
        /// 移除
        public func pop() {
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
        
        /// 设置超时时间
        /// - Parameter timeout: 超时时间
        @discardableResult public func timeout(_ timeout: TimeInterval?) -> Alert {
            self.timeout = timeout
            willLayoutSubviews()
            return self
        }
        
        /// 添加按钮
        /// - Parameter style: 样式
        /// - Parameter text: 标题
        /// - Parameter action: 事件
        @discardableResult public func addAction(style: UIAlertAction.Style, title: String?, action: (() -> Void)?) -> Alert {
            if let btn = privAddButton(custom: Button.actionButton(title: title), action: action) as? Button {
                btn.update(style: style)
            }
            return self
        }
        
        /// 添加按钮
        /// - Parameter button: 按钮
        /// - Parameter action: 事件
        @discardableResult public func addAction(custom button: UIButton, action: (() -> Void)?) -> Alert {
            privAddButton(custom: button, action: action)
            return self
        }
        
        /// 最小化事件
        /// - Parameter callback: 事件回调
        @discardableResult public func didMinimize(_ callback: (() -> Void)?) -> Alert {
            minimizeCallback = callback
            return self
        }
        
        /// 消失事件
        /// - Parameter callback: 事件回调
        @discardableResult public func didDisappear(_ callback: (() -> Void)?) -> Alert {
            disappearCallback = callback
            return self
        }
        
        /// 更新标题
        /// - Parameter title: 标题
        @discardableResult public func updateContent(scene: Scene, title: String? = nil, message: String? = nil, icon: UIImage? = nil) -> Alert {
            vm.title = title
            vm.message = message
            vm.scene = scene
            vm.icon = icon
            cfg.alert.reloadData(self)
            return self
        }
        
        
        /// 更新按钮
        /// - Parameter index: 索引
        /// - Parameter style: 样式
        /// - Parameter title: 标题
        /// - Parameter action: 事件
        @discardableResult public func updateAction(index: Int, style: UIAlertAction.Style, title: String?, action: (() -> Void)?) -> Alert {
            return updateAction(index: index, button: { (btn) in
                btn.setTitle(title, for: .normal)
                if let b = btn as? Button {
                    b.update(style: style)
                }
                btn.layoutIfNeeded()
            }, action: action)
        }
        
        
        @discardableResult public func updateAction(index: Int, button: (UIButton) -> Void, action: (() -> Void)? = nil) -> Alert {
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
        
        @discardableResult public func removeAction(index: Int) -> Alert {
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
        
    }
    
}

fileprivate extension ProHUD.Alert {
    func willLayoutSubviews() {
        willLayout?.cancel()
        timeoutBlock?.cancel()
        showNavButtonsBlock?.cancel()
        willLayout = DispatchWorkItem(block: { [weak self] in
            if let a = self {
                // 布局
                cfg.alert.loadSubviews(a)
                cfg.alert.reloadData(a)
                // 超时
                if let t = a.timeout, t > 0 {
                    a.timeoutBlock = DispatchWorkItem(block: { [weak self] in
                        self?.pop()
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now()+t, execute: a.timeoutBlock!)
                } else {
                    a.timeoutBlock = nil
                }
                // 顶部按钮
                if cfg.alert.forceQuitTimer > 0 && self?.actionStack.superview == nil {
                    a.showNavButtonsBlock = DispatchWorkItem(block: { [weak self] in
                        if let s = self {
                            cfg.alert.loadForceQuitButton(s)
                        }
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now()+cfg.alert.forceQuitTimer, execute: a.showNavButtonsBlock!)
                }
            }
        })
        DispatchQueue.main.asyncAfter(deadline: .now()+0.001, execute: willLayout!)
    }
    
    @discardableResult private func privAddButton(custom button: UIButton, action: (() -> Void)?) -> UIButton {
        timeout = nil
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


// MARK: - AlertHUD public func

public extension ProHUD {
    
    @discardableResult
    func push(_ alert: Alert) -> Alert {
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
        updateAlertsLayout()
        // setup timeout
        if let _ = alert.timeout, alert.timeoutBlock == nil {
            alert.timeout(alert.timeout)
        }
        return alert
    }
    
    @discardableResult
    func push(alert: Alert.Scene, title: String? = nil, message: String? = nil, icon: UIImage? = nil) -> Alert {
        return push(Alert(scene: alert, title: title, message: message, icon: icon))
    }
    
    func alerts(identifier: String?) -> [Alert] {
        var aa = [Alert]()
        for a in alerts {
            if a.identifier == identifier {
                aa.append(a)
            }
        }
        return aa
    }
    
    func pop(alert: Alert) {
        for a in alerts {
            if a == alert {
                a.pop()
            }
        }
    }
    
    func pop(alert identifier: String?) {
        for a in alerts {
            if a.identifier == identifier {
                a.pop()
            }
        }
    }
}


// MARK: AlertHUD public class func

public extension ProHUD {
    
    @discardableResult
    class func push(_ alert: Alert) -> Alert {
        return shared.push(alert)
    }
    
    @discardableResult
    class func push(alert: Alert.Scene, title: String? = nil, message: String? = nil, icon: UIImage? = nil) -> Alert {
        return shared.push(alert: alert, title: title, message: message, icon: icon)
    }
    
    class func alert(identifier: String?) -> [Alert] {
        return shared.alerts(identifier: identifier)
    }
    
    class func pop(alert: Alert) {
        shared.pop(alert: alert)
    }
    
    class func pop(alert identifier: String?) {
        shared.pop(alert: identifier)
    }
    
}

// MARK: AlertHUD private func
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
                    alerts.remove(at: i)
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

