//
//  AlertManager.swift
//  
//
//  Created by xaoxuu on 2022/8/31.
//

import UIKit

extension Alert: HUD {
    
    @objc open func push() {
        guard Configuration.isEnabled else { return }
        let window = createAttachedWindowIfNotExists()
        guard window.alerts.contains(self) == false else {
            return
        }
        view.transform = .init(scaleX: 1.2, y: 1.2)
        view.alpha = 0
        navEvents[.onViewWillAppear]?(self)
        window.vc.addChild(self)
        window.vc.view.addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        UIView.animateEaseOut(duration: config.animateDurationForBuildIn ?? config.animateDurationForBuildInByDefault) {
            self.view.transform = .identity
            self.view.alpha = 1
            if let f = self.config.customBackgroundViewMask {
                f(window.backgroundView)
            }
            window.backgroundView.alpha = 1
        } completion: { done in
            self.navEvents[.onViewDidAppear]?(self)
        }
        window.alerts.append(self)
        Alert.updateAlertsLayout(alerts: window.alerts)
    }
    
    @objc open func pop() {
        navEvents[.onViewWillDisappear]?(self)
        let window = window ?? createAttachedWindowIfNotExists()
        Alert.removeAlert(alert: self)
        let duration = config.animateDurationForBuildOut ?? config.animateDurationForBuildOutByDefault
        UIView.animateEaseOut(duration: duration) {
            self.view.alpha = 0
            self.view.transform = .init(scaleX: 1.08, y: 1.08)
        } completion: { done in
            self.view.removeFromSuperview()
            self.removeFromParent()
            self.navEvents[.onViewDidDisappear]?(self)
        }
        // hide window
        let count = window.alerts.count
        if count == 0 {
            self.window = nil
            UIView.animateEaseOut(duration: duration) {
                window.backgroundView.alpha = 0
            } completion: { done in
                // 这里设置一下window属性，会使window的生命周期被延长到此处，即动画执行过程中window不会被提前释放
                window.isHidden = true
            }
        }
    }
    
}

public extension Alert {
    
    /// 如果不存在就创建并弹出一个HUD实例，如果存在就更新实例
    /// - Parameters:
    ///   - identifier: 实例唯一标识符（如果为空，则以代码位置为唯一标识符）
    ///   - handler: 实例创建代码
    static func lazyPush(identifier: String? = nil, file: String = #file, line: Int = #line, handler: @escaping (_ alert: Alert) -> Void, onExists: ((_ alert: Alert) -> Void)? = nil) {
        let id = identifier ?? (file + "#\(line)")
        if let vc = find(identifier: id).last {
            vc.update(handler: onExists ?? handler)
        } else {
            Alert { alert in
                alert.identifier = id
                handler(alert)
            }
        }
    }
    
    /// 更新HUD实例
    /// - Parameter callback: 实例更新代码
    func update(handler: @escaping (_ alert: Alert) -> Void) {
        handler(self)
        reloadData()
        UIView.animateEaseOut(duration: config.animateDurationForReloadByDefault) {
            self.view.layoutIfNeeded()
        }
    }
    
    /// 查找HUD实例
    /// - Parameter identifier: 唯一标识符
    /// - Returns: HUD实例
    @discardableResult static func find(identifier: String, update handler: ((_ alert: Alert) -> Void)? = nil) -> [Alert] {
        let arr = AppContext.alertWindow.values.flatMap({ $0.alerts }).filter({ $0.identifier == identifier })
        if let handler = handler {
            arr.forEach({ $0.update(handler: handler) })
        }
        return arr
    }
    
}

fileprivate extension Alert {
    static func updateAlertsLayout(alerts: [Alert]) {
        for (i, a) in alerts.reversed().enumerated() {
            let scale = CGFloat(pow(0.9, CGFloat(i)))
            UIView.animate(withDuration: 1.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: [.allowUserInteraction, .curveEaseInOut], animations: {
                let y = 0 - a.config.stackDepth * CGFloat(i) * CGFloat(pow(0.85, CGFloat(i)))
                a.view.transform = CGAffineTransform.init(translationX: 0, y: y).scaledBy(x: scale, y: scale)
            }) { (done) in
                
            }
        }
    }
    
    func createAttachedWindowIfNotExists() -> AlertWindow {
        AlertWindow.createAttachedWindowIfNotExists(config: config)
    }
    
    static func removeAlert(alert: Alert) {
        guard var alerts = alert.window?.alerts else {
            return
        }
        if alerts.count > 1 {
            for (i, a) in alerts.enumerated() {
                if a == alert {
                    if i < alerts.count {
                        alerts.remove(at: i)
                    }
                }
            }
            updateAlertsLayout(alerts: alerts)
        } else if alerts.count == 1 {
            alerts.removeAll()
        } else {
            print("‼️代码漏洞：已经没有alert了")
        }
        alert.window?.alerts = alerts
    }
    
}

