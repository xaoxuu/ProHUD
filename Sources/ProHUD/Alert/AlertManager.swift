//
//  AlertManager.swift
//  
//
//  Created by xaoxuu on 2022/8/31.
//

import UIKit

extension Alert: HUD {
    
    public func push() {
        guard AlertWindow.alerts.contains(self) == false else {
            return
        }
        let window = attachedWindow
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
        AlertWindow.alerts.append(self)
        Alert.updateAlertsLayout()
    }
    
    public func pop() {
        navEvents[.onViewWillDisappear]?(self)
        let window = attachedWindow
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
        let count = AlertWindow.alerts.count
        if count == 0 && AlertWindow.current != nil {
            UIView.animateEaseOut(duration: duration) {
                window.backgroundView.alpha = 0
            } completion: { done in
                if AlertWindow.alerts.count == 0 {
                    AlertWindow.current = nil
                }
            }
        }
    }
    
}

public extension Alert {
    
    /// 如果不存在就创建并弹出一个HUD实例，如果存在就更新实例
    /// - Parameters:
    ///   - identifier: 实例唯一标识符（如果为空，则以代码位置为唯一标识符）
    ///   - handler: 实例创建代码
    static func lazyPush(identifier: String? = nil, file: String = #file, line: Int = #line, handler: @escaping (_ alert: Alert) -> Void) {
        let id = identifier ?? (file + "#\(line)")
        if let vc = AlertWindow.alerts.last(where: { $0.identifier == id }) {
            handler(vc)
            vc.reloadData()
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
        let arr = AlertWindow.alerts.filter({ $0.identifier == identifier })
        if let handler = handler {
            arr.forEach({ $0.update(handler: handler) })
        }
        return arr
    }
    
}

fileprivate extension Alert {
    static func updateAlertsLayout() {
        for (i, a) in AlertWindow.alerts.reversed().enumerated() {
            let scale = CGFloat(pow(0.9, CGFloat(i)))
            UIView.animate(withDuration: 1.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: [.allowUserInteraction, .curveEaseInOut], animations: {
                let y = 0 - a.config.stackDepth * CGFloat(i) * CGFloat(pow(0.85, CGFloat(i)))
                a.view.transform = CGAffineTransform.init(translationX: 0, y: y).scaledBy(x: scale, y: scale)
            }) { (done) in
                
            }
        }
    }
    
    var attachedWindow: AlertWindow {
        AlertWindow.attachedWindow(config: config)
    }
    
    static func removeAlert(alert: Alert) {
        if AlertWindow.alerts.count > 1 {
            for (i, a) in AlertWindow.alerts.enumerated() {
                if a == alert {
                    if i < AlertWindow.alerts.count {
                        AlertWindow.alerts.remove(at: i)
                    }
                }
            }
            updateAlertsLayout()
        } else if AlertWindow.alerts.count == 1 {
            AlertWindow.alerts.removeAll()
        } else {
            print("‼️代码漏洞：已经没有alert了")
        }
    }
    
}

