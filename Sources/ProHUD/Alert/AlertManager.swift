//
//  AlertManager.swift
//  
//
//  Created by xaoxuu on 2022/8/31.
//

import UIKit

extension AlertTarget {
    
    @objc open func push() {
        guard AlertConfiguration.isEnabled else { return }
        let window = createAttachedWindowIfNotExists()
        guard window.alerts.contains(self) == false else {
            return
        }
        setDefaultAxis()
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
        AlertTarget.updateAlertsLayout(alerts: window.alerts)
    }
    
    @objc open func pop() {
        navEvents[.onViewWillDisappear]?(self)
        AlertTarget.removeAlert(alert: self)
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
        guard let window = view.window as? AlertWindow, let windowScene = windowScene else { return }
        let count = window.alerts.count
        if count == 0 {
            AppContext.alertWindow[windowScene] = nil
            UIView.animateEaseOut(duration: duration) {
                window.backgroundView.alpha = 0
            } completion: { done in
                // 这里设置一下window属性，会使window的生命周期被延长到此处，即动画执行过程中window不会被提前释放
                window.isHidden = true
            }
        }
    }
    
    /// 更新HUD实例
    /// - Parameter callback: 实例更新代码
    @objc open func update(handler: @escaping (_ alert: AlertTarget) -> Void) {
        handler(self)
        reloadData()
        UIView.animateEaseOut(duration: config.animateDurationForReloadByDefault) {
            self.view.layoutIfNeeded()
        }
    }
    
}

// MARK: - layout

fileprivate extension AlertTarget {
    static func updateAlertsLayout(alerts: [AlertTarget]) {
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
    
    static func removeAlert(alert: AlertTarget) {
        guard var alerts = alert.attachedWindow?.alerts else {
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
        alert.attachedWindow?.alerts = alerts
    }
    
}

