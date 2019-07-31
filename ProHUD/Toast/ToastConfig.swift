//
//  ToastConfig.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/31.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import SnapKit

public extension ProHUD.Configuration {
    struct Toast {
        /// 最大宽度（用于优化横屏或者iPad显示）
        public var maxWidth = CGFloat(500)
        /// 标题字体
        public var titleFont = UIFont.boldSystemFont(ofSize: 18)
        /// 正文字体
        public var bodyFont = UIFont.systemFont(ofSize: 16)
        /// 标题最多行数（0代表不限制）
        public var titleMaxLines = Int(0)
        /// 正文最多行数（0代表不限制）
        public var bodyMaxLines = Int(0)
        /// 圆角半径
        public var cornerRadius = CGFloat(16)
        
        public var margin = CGFloat(8)
        
        public var padding = CGFloat(16)
        
        public var iconSize = CGSize(width: 48, height: 48)
        
        /// 加载视图
        lazy var loadSubviews: (ProHUD.Toast) -> Void = {
            return { (vc) in
                debugPrint(vc, "loadSubviews")
                let config = toastConfig
                vc.view.addSubview(vc.contentView)
                vc.contentView.contentView.addSubview(vc.contentStack)
                vc.contentStack.spacing = config.margin
                
                vc.contentView.layer.masksToBounds = true
                vc.contentView.layer.cornerRadius = config.cornerRadius
                
                vc.contentView.snp.makeConstraints { (mk) in
                    mk.leading.trailing.top.equalToSuperview()
                }
                vc.contentStack.snp.makeConstraints { (mk) in
                    mk.top.equalToSuperview().offset(config.padding)
                    mk.bottom.equalToSuperview().offset(-config.padding)
                    mk.leading.equalToSuperview().offset(config.padding)
                    mk.trailing.equalToSuperview().offset(-config.padding)
                }
                
            }
        }()
        
        /// 更新视图
        lazy var updateFrame: (ProHUD.Toast) -> Void = {
            return { (vc) in
                debugPrint(vc, "updateFrame")
                let config = toastConfig
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
//                    icon.snp.makeConstraints { (mk) in
//                        mk.top.greaterThanOrEqualTo(vc.contentView).offset(config.padding+config.margin)
//                        mk.bottom.lessThanOrEqualTo(vc.contentView).offset(-config.padding-config.margin)
//                        mk.leading.greaterThanOrEqualTo(vc.contentView).offset(config.padding+config.margin)
//                        mk.trailing.lessThanOrEqualTo(vc.contentView).offset(-config.padding-config.margin)
//                    }
                    vc.imageView = icon
                }
                
                // text
                if vc.vm.title?.count ?? 0 > 0 || vc.vm.message?.count ?? 0 > 0 {
                    vc.contentStack.addArrangedSubview(vc.textStack)
//                    vc.textStack.snp.makeConstraints { (mk) in
//                        mk.top.greaterThanOrEqualTo(vc.contentView).offset(config.padding*1.5)
//                        mk.bottom.lessThanOrEqualTo(vc.contentView).offset(-config.padding*1.5)
//                        mk.leading.greaterThanOrEqualTo(vc.contentView).offset(config.padding*2)
//                        mk.trailing.lessThanOrEqualTo(vc.contentView).offset(-config.padding*2)
//                    }
                    if vc.vm.title?.count ?? 0 > 0 {
                        if let lb = vc.titleLabel {
                            lb.text = vc.vm.title
                        } else {
                            let title = UILabel()
                            title.textAlignment = .justified
                            title.numberOfLines = config.titleMaxLines
                            title.textColor = UIColor.init(white: 0.2, alpha: 1)
                            title.font = config.titleFont
                            title.text = vc.vm.title
                            vc.textStack.addArrangedSubview(title)
                            vc.titleLabel = title
                        }
                    } else {
                        vc.titleLabel?.removeFromSuperview()
                    }
                    if vc.vm.message?.count ?? 0 > 0 {
                        if let lb = vc.messageLabel {
                            lb.text = vc.vm.message
                        } else {
                            let body = UILabel()
                            body.textAlignment = .justified
                            body.font = config.bodyFont
                            body.numberOfLines = config.bodyMaxLines
                            body.textColor = UIColor.darkGray
                            body.font = config.bodyFont
                            body.text = vc.vm.message
                            vc.textStack.addArrangedSubview(body)
                            vc.messageLabel = body
                        }
                    } else {
                        vc.messageLabel?.removeFromSuperview()
                    }
                } else {
                    vc.textStack.removeFromSuperview()
                }
                
                if isFirstLayout {
                    vc.view.layoutIfNeeded()
                    vc.updateFrame()
                    vc.imageView?.transform = .init(scaleX: 0.75, y: 0.75)
                } else {
                    
                }
                
                UIView.animateFastEaseOut(delay: 0, animations: {
                    vc.imageView?.transform = .identity
                    vc.view.layoutIfNeeded()
                    vc.updateFrame()
                    
                }) { (done) in
                }
            }
        }()
        
        /// 加载视图
        /// - Parameter callback: 回调代码
        public mutating func loadSubviews(_ callback: @escaping (ProHUD.Toast) -> Void) {
            loadSubviews = callback
        }
        
        /// 更新视图
        /// - Parameter callback: 回调代码
        public mutating func updateFrame(_ callback: @escaping (ProHUD.Toast) -> Void) {
            updateFrame = callback
        }
        
    }
}

internal var toastConfig = ProHUD.Configuration.Toast()

public extension ProHUD {
    static func configToast(_ config: (inout Configuration.Toast) -> Void) {
        config(&toastConfig)
    }
}
