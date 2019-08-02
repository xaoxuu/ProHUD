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
        // MARK: 卡片样式
        /// 最大宽度（用于优化横屏或者iPad显示）
        public var maxWidth = CGFloat(400)
        /// 圆角半径
        public var cornerRadius = CGFloat(16)
        /// 余量：元素与元素之间的距离
        public var margin = CGFloat(8)
        /// 填充：元素内部控件距离元素边界的距离
        public var padding = CGFloat(16)
        
        // MARK: 图标样式
        /// 图标、default按钮的颜色
        public var tintColor: UIColor?
        /// 图标尺寸
        public var iconSize = CGSize(width: 48, height: 48)
        
        // MARK: 文本样式
        /// 标题字体
        public var titleFont = UIFont.boldSystemFont(ofSize: 22)
        /// 标题颜色
        public var titleColor = UIColor(white: 0.2, alpha: 1)
        /// 标题最多行数
        public var titleMaxLines = Int(1)
        
        /// 加粗正文字体（如果只有标题或者只有正文，则显示这种字体）
        public var boldTextFont = UIFont.boldSystemFont(ofSize: 18)
        
        /// 正文字体
        public var bodyFont = UIFont.systemFont(ofSize: 17)
        /// 正文颜色
        public var bodyColor = UIColor.darkGray
        /// 正文最多行数
        public var bodyMaxLines = Int(5)
        
        // MARK: 按钮样式
        /// 按钮字体
        public var buttonFont = UIFont.boldSystemFont(ofSize: 18)
        
        // MARK: 逻辑
        /// 多少秒后显示强制退出的按钮（只有无按钮的弹窗才会出现）
        public var minimizeTimeout = TimeInterval(10)
        /// 最小化按钮标题
        public var minimizeTitle = String("隐藏窗口")
        
        // MARK: 生命周期
        /// 加载视图
        lazy var loadSubviews: (ProHUD.Alert, Alert) -> Void = {
            return { (vc, config) in
                debugPrint(vc, "loadSubviews")
                if vc.contentView.superview == nil {
                    vc.view.addSubview(vc.contentView)
                    vc.contentView.contentView.addSubview(vc.contentStack)
                    
                    vc.contentStack.spacing = alertConfig.margin + alertConfig.padding
                    
                    vc.contentView.layer.masksToBounds = true
                    vc.contentView.layer.cornerRadius = alertConfig.cornerRadius
                    
                    vc.contentView.snp.makeConstraints { (mk) in
                        mk.center.equalToSuperview()
                        mk.width.lessThanOrEqualTo(CGFloat.minimum(UIScreen.main.bounds.width * 0.68, alertConfig.maxWidth))
                    }
                    vc.contentStack.snp.makeConstraints { (mk) in
                        mk.centerX.equalToSuperview()
                        mk.top.equalToSuperview().offset(alertConfig.padding)
                        mk.bottom.equalToSuperview().offset(-alertConfig.padding)
                        mk.leading.equalToSuperview().offset(alertConfig.padding)
                        mk.trailing.equalToSuperview().offset(-alertConfig.padding)
                    }
                }
                
            }
        }()
        
        /// 更新视图
        lazy var updateFrame: (ProHUD.Alert, Alert) -> Void = {
            return { (vc, config) in
                debugPrint(vc, "updateFrame")
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
                        mk.top.greaterThanOrEqualTo(vc.contentView).offset(config.padding*2.25)
                        mk.bottom.lessThanOrEqualTo(vc.contentView).offset(-config.padding*2.25)
                        mk.leading.greaterThanOrEqualTo(vc.contentView).offset(config.padding*4)
                        mk.trailing.lessThanOrEqualTo(vc.contentView).offset(-config.padding*4)
                    }
                    vc.imageView = icon
                }
                
                // text
                if vc.vm.title?.count ?? 0 > 0 || vc.vm.message?.count ?? 0 > 0 {
                    vc.contentStack.addArrangedSubview(vc.textStack)
                    vc.textStack.snp.makeConstraints { (mk) in
                        mk.top.greaterThanOrEqualTo(vc.contentView).offset(config.padding*1.75)
                        mk.bottom.lessThanOrEqualTo(vc.contentView).offset(-config.padding*1.75)
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
                            title.textColor = config.titleColor
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
                        if let lb = vc.messageLabel {
                            lb.text = vc.vm.message
                        } else {
                            let body = UILabel()
                            body.textAlignment = .center
                            body.font = config.bodyFont
                            body.numberOfLines = config.bodyMaxLines
                            body.textColor = config.bodyColor
                            body.text = vc.vm.message
                            vc.textStack.addArrangedSubview(body)
                            vc.messageLabel = body
                        }
                        if vc.vm.title?.count ?? 0 > 0 {
                            // 有title
                            vc.messageLabel?.font = config.bodyFont
                        } else {
                            // 没有title
                            vc.messageLabel?.font = config.boldTextFont
                        }
                    } else {
                        vc.messageLabel?.removeFromSuperview()
                    }
                } else {
                    vc.textStack.removeFromSuperview()
                }
                if vc.actionStack.superview != nil {
                    if isFirstLayout {
                        vc.contentStack.addArrangedSubview(vc.actionStack)
                    } else {
                        vc.actionStack.transform = .init(scaleX: 1, y: 0.001)
                        UIView.animateForAlert {
                            vc.contentStack.addArrangedSubview(vc.actionStack)
                            vc.view.layoutIfNeeded()
                        }
                    }
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
                    if isFirstLayout == false {
                        UIView.animateForAlert {
                            vc.actionStack.transform = .identity
                        }
                    }
                    
                }
                
                if isFirstLayout {
                    vc.view.layoutIfNeeded()
                    vc.imageView?.transform = .init(scaleX: 0.75, y: 0.75)
                    UIView.animateForAlert {
                        vc.imageView?.transform = .identity
                        vc.view.layoutIfNeeded()
                    }
                } else {
                    UIView.animateForAlert {
                        vc.view.layoutIfNeeded()
                    }
                }
            }
        }()
        
        /// 加载强制按钮
        lazy var showNavButtons: (ProHUD.Alert, Alert) -> Void = {
            return { (vc, config) in
                debugPrint(vc, "showNavButtons")
                let btn = UIButton.minimizeButton()
                let bg = ProHUD.BlurView()
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
                    debugPrint("点击了隐藏")
                    vc?.minimizeCallback?()
                    vc?.remove()
                }
            }
        }()
        
        /// 加载视图
        /// - Parameter callback: 回调代码
        public mutating func loadSubviews(_ callback: @escaping (ProHUD.Alert, Alert) -> Void) {
            loadSubviews = callback
        }
        
        /// 更新视图
        /// - Parameter callback: 回调代码
        public mutating func updateFrame(_ callback: @escaping (ProHUD.Alert, Alert) -> Void) {
            updateFrame = callback
        }
        
    }
}

internal var alertConfig = ProHUD.Configuration.Alert()

public extension ProHUD {
    static func configAlert(_ config: (inout Configuration.Alert) -> Void) {
        config(&alertConfig)
    }
}
