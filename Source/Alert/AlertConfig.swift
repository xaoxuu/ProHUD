//
//  cfg.alert.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/29.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit
import SnapKit

public extension UIWindow.Level {
    static let proAlert = UIWindow.Level.alert - 1
}

public extension ProHUD.Configuration {
    struct Alert {
        // MARK: 卡片样式
        /// 最大宽度（用于优化横屏或者iPad显示）
        public var maxWidth = CGFloat(400)
        /// 圆角半径
        public var cornerRadius = CGFloat(16)
        /// 余量：元素与元素之间的距离
        public var margin = CGFloat(8)
        /// 填充：元素内部控件距离元素边界的距离
        public var padding = CGFloat(16)
        
        /// 颜色
        public var tintColor: UIColor?
        
        // MARK: 图标样式
        /// 图标尺寸
        public var iconSize = CGSize(width: 48, height: 48)
        
        // MARK: 文本样式
        /// 标题字体
        public var titleFont = UIFont.boldSystemFont(ofSize: 22)
        /// 标题最多行数
        public var titleMaxLines = Int(5)
        
        /// 加粗字体（如果只有标题或者只有正文，则显示这种字体）
        public var boldTextFont = UIFont.boldSystemFont(ofSize: 18)
        
        /// 正文字体
        public var bodyFont = UIFont.systemFont(ofSize: 17)
        /// 正文最多行数
        public var bodyMaxLines = Int(20)
        
        // MARK: 按钮样式
        /// 按钮字体
        public var buttonFont = UIFont.boldSystemFont(ofSize: 18)
        
        // MARK: 生命周期
        
        /// 刷新数据和布局
        public func reloadData(_ callback: @escaping (ProHUD.Alert) -> Void) {
            privReloadData = callback
        }
        
        /// 多少秒后显示强制退出的按钮（只有无按钮的弹窗才会出现）
        public var forceQuitTimer = TimeInterval(30)
        
        /// 强制退出按钮标题
        public var forceQuitTitle = "隐藏窗口"
        
        /// 加载强制退出按钮
        /// - Parameter callback: 回调代码
        public func loadHideButton(_ callback: @escaping (ProHUD.Alert) -> Void) {
            privLoadHideButton = callback
        }
        
        
    }
}


// MARK: - 内部调用
internal extension ProHUD.Configuration.Alert {
    
    var reloadData: (ProHUD.Alert) -> Void {
        return privReloadData
    }
    
}


// MARK: - 默认实现
fileprivate var privLayoutContentView: (ProHUD.Alert) -> Void = {
    return { (vc) in
        if vc.contentView.superview == nil {
            vc.view.addSubview(vc.contentView)
            vc.contentView.layer.masksToBounds = true
            vc.contentView.layer.cornerRadius = cfg.alert.cornerRadius
            let maxWidth = CGFloat.maximum(CGFloat.minimum(UIScreen.main.bounds.width * 0.68, cfg.alert.maxWidth), 268)
            vc.contentView.snp.makeConstraints { (mk) in
                mk.center.equalToSuperview()
                mk.width.lessThanOrEqualTo(maxWidth)
            }
        }
        if vc.contentStack.superview == nil {
            vc.contentView.contentView.addSubview(vc.contentStack)
            vc.contentStack.spacing = cfg.alert.margin + cfg.alert.padding
            vc.contentStack.snp.makeConstraints { (mk) in
                mk.centerX.equalToSuperview()
                mk.top.equalToSuperview().offset(cfg.alert.padding)
                mk.bottom.equalToSuperview().offset(-cfg.alert.padding)
                mk.leading.equalToSuperview().offset(cfg.alert.padding)
                mk.trailing.equalToSuperview().offset(-cfg.alert.padding)
            }
        }
    }
}()

fileprivate var privUpdateImage: (ProHUD.Alert) -> Void = {
    return { (vc) in
        let config = cfg.alert
        let img = vc.vm.icon ?? vc.vm.scene.image
        vc.imageView.image = img
        vc.contentStack.addArrangedSubview(vc.imageView)
        vc.imageView.contentMode = .scaleAspectFit
        vc.imageView.snp.makeConstraints { (mk) in
            mk.top.greaterThanOrEqualTo(vc.contentView).offset(config.padding*2.25)
            mk.bottom.lessThanOrEqualTo(vc.contentView).offset(-config.padding*2.25)
            mk.leading.greaterThanOrEqualTo(vc.contentView).offset(config.padding*4)
            mk.trailing.lessThanOrEqualTo(vc.contentView).offset(-config.padding*4)
            mk.width.equalTo(config.iconSize.width)
            mk.height.equalTo(config.iconSize.height)
        }
        vc.imageView.layer.removeAllAnimations()
        vc.animateLayer = nil
        vc.animation = nil
    }
}()

fileprivate var privUpdateTextStack: (ProHUD.Alert) -> Void = {
    return { (vc) in
        let config = cfg.alert
        if vc.vm.title == nil {
            vc.vm.title = vc.vm.scene.title
        }
        if vc.vm.message == nil {
            vc.vm.message = vc.vm.scene.message
        }
        if vc.vm.title?.count ?? 0 > 0 || vc.vm.message?.count ?? 0 > 0 {
            vc.contentStack.addArrangedSubview(vc.textStack)
            vc.textStack.snp.makeConstraints { (mk) in
                mk.top.greaterThanOrEqualTo(vc.contentView).offset(config.padding*1.75)
                mk.bottom.lessThanOrEqualTo(vc.contentView).offset(-config.padding*1.75)
                if UIScreen.main.bounds.width < 414 {
                    mk.leading.greaterThanOrEqualTo(vc.contentView).offset(config.padding*1.5)
                    mk.trailing.lessThanOrEqualTo(vc.contentView).offset(-config.padding*1.5)
                } else {
                    mk.leading.greaterThanOrEqualTo(vc.contentView).offset(config.padding*2)
                    mk.trailing.lessThanOrEqualTo(vc.contentView).offset(-config.padding*2)
                }
            }
            if vc.vm.title?.count ?? 0 > 0 {
                if let lb = vc.titleLabel {
                    lb.text = vc.vm.title
                } else {
                    let title = UILabel()
                    title.textAlignment = .center
                    title.numberOfLines = config.titleMaxLines
                    title.textColor = cfg.primaryLabelColor
                    title.text = vc.vm.title
                    vc.textStack.addArrangedSubview(title)
                    vc.titleLabel = title
                }
                if vc.vm.message?.count ?? 0 > 0 {
                    // 有message
                    vc.titleLabel?.font = config.titleFont
                } else {
                    // 没有message
                    vc.titleLabel?.font = config.boldTextFont
                }
            } else {
                vc.titleLabel?.removeFromSuperview()
            }
            if vc.vm.message?.count ?? 0 > 0 {
                if let lb = vc.bodyLabel {
                    lb.text = vc.vm.message
                } else {
                    let body = UILabel()
                    body.textAlignment = .center
                    body.font = config.bodyFont
                    body.numberOfLines = config.bodyMaxLines
                    body.textColor = cfg.secondaryLabelColor
                    body.text = vc.vm.message
                    vc.textStack.addArrangedSubview(body)
                    vc.bodyLabel = body
                }
                if vc.vm.title?.count ?? 0 > 0 {
                    // 有title
                    vc.bodyLabel?.font = config.bodyFont
                } else {
                    // 没有title
                    vc.bodyLabel?.font = config.boldTextFont
                }
            } else {
                vc.bodyLabel?.removeFromSuperview()
            }
        } else {
            vc.textStack.removeFromSuperview()
        }
        vc.textStack.layoutIfNeeded()
    }
}()


fileprivate var privUpdateActionStack: (ProHUD.Alert) -> Void = {
    return { (vc) in
        let config = cfg.alert
        if vc.actionStack.arrangedSubviews.count > 0 {
            // 有按钮
            vc.contentStack.addArrangedSubview(vc.actionStack)
            // 适配横竖屏和iPad
            if isPortrait == false && vc.actionStack.arrangedSubviews.count < 4 {
                vc.actionStack.axis = .horizontal
                vc.actionStack.alignment = .fill
                vc.actionStack.distribution = .fillEqually
            }
            vc.actionStack.snp.makeConstraints {  (mk) in
                mk.width.greaterThanOrEqualTo(200)
                mk.leading.trailing.equalToSuperview()
            }
        } else {
            // 无按钮
            for v in vc.actionStack.arrangedSubviews {
                v.removeFromSuperview()
            }
            vc.actionStack.removeFromSuperview()
        }
        vc.actionStack.layoutIfNeeded()
    }
}()

fileprivate var privLoadHideButton: (ProHUD.Alert) -> Void = {
    return { (vc) in
        debug(vc, "showNavButtons")
        let config = cfg.alert
        let btn = ProHUD.Alert.Button.createHideButton()
        btn.setTitle(cfg.alert.forceQuitTitle, for: .normal)
        let bg = createBlurView()
        bg.layer.masksToBounds = true
        bg.layer.cornerRadius = config.cornerRadius
        if let last = vc.view.subviews.last {
            vc.view.insertSubview(bg, belowSubview: last)
        } else {
            vc.view.addSubview(bg)
        }
        bg.snp.makeConstraints { (mk) in
            mk.leading.trailing.equalTo(vc.contentView)
            mk.top.equalTo(vc.contentView.snp.bottom).offset(config.margin)
        }
        bg.contentView.addSubview(btn)
        btn.snp.makeConstraints { (mk) in
            mk.edges.equalToSuperview()
        }
        bg.alpha = 0
        bg.layoutIfNeeded()
        bg.transform = .init(translationX: 0, y: -2*(config.margin+bg.frame.size.height))
        UIView.animateForAlert {
            bg.alpha = 1
            bg.transform = .identity
        }
        vc.addTouchUpAction(for: btn) { [weak vc] in
            debug("点击了【\(config.forceQuitTitle)】")
            vc?.vm.forceQuitCallback?()
            vc?.pop()
        }
    }
}()

/// 刷新数据和布局
fileprivate var privReloadData: (ProHUD.Alert) -> Void = {
    return { (vc) in
        debug(vc, "reloadData")
        let config = cfg.alert
        let isFirstLayout: Bool
        if vc.contentView.superview == nil {
            isFirstLayout = true
            // 布局主容器视图
            privLayoutContentView(vc)
        } else {
            isFirstLayout = false
        }
        // 更新图片
        privUpdateImage(vc)
        
        // 更新文本容器
        privUpdateTextStack(vc)
        
        // 更新操作容器
        privUpdateActionStack(vc)
        vc.contentStack.layoutIfNeeded()
        vc.contentView.layoutIfNeeded()
        
        // 动画
        if isFirstLayout {
            vc.view.layoutIfNeeded()
            vc.imageView.transform = .init(scaleX: 0.75, y: 0.75)
            UIView.animateForAlert {
                vc.view.layoutIfNeeded()
                vc.imageView.transform = .identity
            }
        } else {
            UIView.animateForAlert {
                vc.view.layoutIfNeeded()
            }
        }
        
        // 设置持续时间
        vc.vm.updateDuration()
        
        // 「隐藏」按钮出现的时间
        vc.vm.hideTimerBlock?.cancel()
        if vc.buttonEvents.count == 0 {
            vc.vm.hideTimerBlock = DispatchWorkItem(block: { [weak vc] in
                if let vc = vc {
                    if vc.buttonEvents.count == 0 {
                        privLoadHideButton(vc)
                    }
                }
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + config.forceQuitTimer, execute: vc.vm.hideTimerBlock!)
        } else {
            vc.vm.hideTimerBlock = nil
        }
        
    }
}()
