//
//  AlertConfig.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/29.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit
import SnapKit

public extension ProHUD.Configuration {
    struct Alert {
        /// 最大宽度（用于优化横屏或者iPad显示）
        public var maxWidth = CGFloat(400)
        /// 大标题字体
        public var largeTitleFont = UIFont.boldSystemFont(ofSize: 22)
        /// 标题字体
        public var titleFont = UIFont.boldSystemFont(ofSize: 18)
        /// 正文字体
        public var bodyFont = UIFont.systemFont(ofSize: 17)
        /// 按钮字体
        public var buttonFont = UIFont.boldSystemFont(ofSize: 18)
        /// 标题最多行数（0代表不限制）
        public var titleMaxLines = Int(0)
        /// 正文最多行数（0代表不限制）
        public var bodyMaxLines = Int(0)
        /// 圆角半径
        public var cornerRadius = CGFloat(16)
        
        public var margin = CGFloat(8)
        
        public var padding = CGFloat(16)
        
        public var iconSize = CGSize(width: 48, height: 48)
        
        public var tintColor = UIColor.init(red: 3/255, green: 169/255, blue: 244/255, alpha: 1)
        /// 多少秒后显示强制退出的按钮【终止/隐藏】
        public var forceQuitTimeout = TimeInterval(2)
        
        /// 加载视图
        lazy var loadSubviews: (ProHUD.Alert) -> Void = {
            return { (vc) in
                debugPrint(vc, "loadSubviews")
                vc.view.addSubview(vc.contentView)
                vc.contentView.contentView.addSubview(vc.contentStack)
                
                let config = hud.config.alert
                vc.contentStack.spacing = config.margin + config.padding
                
                vc.contentView.layer.masksToBounds = true
                vc.contentView.layer.cornerRadius = config.cornerRadius
                
                vc.contentView.snp.makeConstraints { (mk) in
                    mk.center.equalToSuperview()
                    mk.width.lessThanOrEqualTo(CGFloat.minimum(UIScreen.main.bounds.width * 0.68, config.maxWidth))
                }
                vc.contentStack.snp.makeConstraints { (mk) in
                    mk.centerX.equalToSuperview()
                    mk.top.equalToSuperview().offset(config.padding)
                    mk.bottom.equalToSuperview().offset(-config.padding)
                    mk.leading.equalToSuperview().offset(config.padding)
                    mk.trailing.equalToSuperview().offset(-config.padding)
                }
                
            }
        }()
        
        /// 更新视图
        lazy var updateFrame: (ProHUD.Alert) -> Void = {
            return { (vc) in
                debugPrint(vc, "updateFrame")
                let config = hud.config.alert
                let isFirstLayout: Bool
                // 图标和文字至少有一个，如果都没有添加到视图中，说明是第一次layout
                if vc.textStack.superview == nil && vc.imageView?.superview == nil {
                    isFirstLayout = true
                } else {
                    isFirstLayout = false
                }
                let imgStr: String
                switch vc.vm.scene {
                case .success:
                    imgStr = "ProHUDSuccess"
                case .warning:
                    imgStr = "ProHUDWarning"
                case .error:
                    imgStr = "ProHUDError"
                case .loading:
                    imgStr = "ProHUDLoading"
                case .confirm:
                    imgStr = "ProHUDMessage"
                case .delete:
                    imgStr = "ProHUDTrash"
                default:
                    imgStr = "ProHUDMessage"
                }
                let img = vc.vm.icon ?? ProHUD.image(named: imgStr)
                if let imgv = vc.imageView {
                    imgv.image = img
                } else {
                    let icon = UIImageView(image: img)
                    vc.contentStack.addArrangedSubview(icon)
                    icon.snp.makeConstraints { (mk) in
                        mk.top.greaterThanOrEqualTo(vc.contentView).offset(config.padding*2.5)
                        mk.bottom.lessThanOrEqualTo(vc.contentView).offset(-config.padding*2.5)
                        mk.leading.greaterThanOrEqualTo(vc.contentView).offset(config.padding*4)
                        mk.trailing.lessThanOrEqualTo(vc.contentView).offset(-config.padding*4)
                    }
                    vc.imageView = icon
                }
                
                // text
                if vc.vm.title?.count ?? 0 > 0 || vc.vm.message?.count ?? 0 > 0 {
                    vc.contentStack.addArrangedSubview(vc.textStack)
                    vc.textStack.snp.makeConstraints { (mk) in
                        mk.top.greaterThanOrEqualTo(vc.contentView).offset(config.padding*1.5)
                        mk.bottom.lessThanOrEqualTo(vc.contentView).offset(-config.padding*1.5)
                        mk.leading.greaterThanOrEqualTo(vc.contentView).offset(config.padding*2)
                        mk.trailing.lessThanOrEqualTo(vc.contentView).offset(-config.padding*2)
                    }
                    if vc.vm.title?.count ?? 0 > 0 {
                        if let lb = vc.titleLabel {
                            lb.text = vc.vm.title
                        } else {
                            let title = UILabel()
                            title.textAlignment = .center
                            title.numberOfLines = config.titleMaxLines
                            title.textColor = UIColor.init(white: 0.2, alpha: 1)
                            title.text = vc.vm.title
                            vc.textStack.addArrangedSubview(title)
                            vc.titleLabel = title
                        }
                        if vc.vm.message?.count ?? 0 > 0 {
                            // 有message
                            vc.titleLabel?.font = config.largeTitleFont
                        } else {
                            // 没有message
                            vc.titleLabel?.font = config.titleFont
                        }
                    } else {
                        vc.titleLabel?.removeFromSuperview()
                    }
                    if vc.vm.message?.count ?? 0 > 0 {
                        if let lb = vc.messageLabel {
                            lb.text = vc.vm.message
                        } else {
                            let body = UILabel()
                            body.textAlignment = .center
                            body.font = config.bodyFont
                            body.numberOfLines = config.bodyMaxLines
                            body.textColor = UIColor.darkGray
                            body.text = vc.vm.message
                            vc.textStack.addArrangedSubview(body)
                            vc.messageLabel = body
                        }
                        if vc.vm.title?.count ?? 0 > 0 {
                            // 有title
                            vc.messageLabel?.font = config.bodyFont
                        } else {
                            // 没有title
                            vc.messageLabel?.font = config.titleFont
                        }
                    } else {
                        vc.messageLabel?.removeFromSuperview()
                    }
                } else {
                    vc.textStack.removeFromSuperview()
                }
                if vc.actionStack.superview != nil {
                    vc.contentStack.addArrangedSubview(vc.actionStack)
                    // 适配横竖屏和iPad
                    if isPortrait == false {
                        vc.actionStack.axis = .horizontal
                        vc.actionStack.alignment = .fill
                        vc.actionStack.distribution = .fillEqually
                    }
                    vc.actionStack.snp.makeConstraints { (mk) in
                        mk.width.greaterThanOrEqualTo(200)
                        mk.leading.trailing.equalToSuperview()
                    }
                }
                if isFirstLayout {
                    vc.view.layoutIfNeeded()
                    vc.imageView?.transform = .init(scaleX: 0.75, y: 0.75)
                } else {
                    
                }
                
                UIView.animateFastEaseOut(delay: 0, animations: {
                    vc.imageView?.transform = .identity
                    vc.view.layoutIfNeeded()
                }) { (done) in
                }
            }
        }()
        
        /// 加载强制按钮
        lazy var showNavButtons: (ProHUD.Alert) -> Void = {
            return { (vc) in
                debugPrint(vc, "showNavButtons")
                let btn = UIButton.hideButton()
                vc.view.addSubview(btn)
                btn.snp.makeConstraints { (mk) in
                    mk.leading.top.equalTo(vc.contentView).offset(hud.config.alert.margin/2)
                }
                vc.addTouchUpAction(for: btn) { [weak vc] in
                    debugPrint("点击了隐藏")
                    vc?.remove()
                }
            }
        }()
        
        /// 加载视图
        /// - Parameter callback: 回调代码
        public mutating func loadSubviews(_ callback: @escaping (ProHUD.Alert) -> Void) {
            loadSubviews = callback
        }
        
        /// 更新视图
        /// - Parameter callback: 回调代码
        public mutating func updateFrame(_ callback: @escaping (ProHUD.Alert) -> Void) {
            updateFrame = callback
        }
        
    }
}
