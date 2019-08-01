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
        /// 标题最多行数
        public var titleMaxLines = Int(1)
        /// 正文最多行数
        public var bodyMaxLines = Int(10)
        /// 圆角半径
        public var cornerRadius = CGFloat(12)
        
        public var margin = CGFloat(8)
        
        public var padding = CGFloat(16)
        
        public var iconSize = CGSize(width: 48, height: 48)
        
        /// 加载视图
        lazy var loadSubviews: (ProHUD.Toast) -> Void = {
            return { (vc) in
                debugPrint(vc, "loadSubviews")
                vc.view.addSubview(vc.titleLabel)
                vc.view.addSubview(vc.bodyLabel)
                vc.view.addSubview(vc.imageView)
                
            }
        }()
        
        /// 更新视图
        lazy var reloadData: (ProHUD.Toast) -> Void = {
            return { (vc) in
                debugPrint(vc, "reloadData")
                // 设置数据
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
                vc.imageView.image = img
                vc.titleLabel.text = vc.vm.title
                vc.bodyLabel.text = vc.vm.message
                
                vc.tintColor = vc.vm.scene.tintColor
                
            }
        }()
        
        /// 更新视图
        lazy var layoutSubviews: (ProHUD.Toast) -> Void = {
            return { (vc) in
                debugPrint(vc, "layoutSubviews")
                let config = toastConfig
                
                let scene = vc.vm.scene
                
                vc.imageView.snp.makeConstraints { (mk) in
                    mk.top.equalToSuperview().offset(config.padding)
                    mk.leading.equalToSuperview().offset(config.padding)
                    mk.bottom.lessThanOrEqualToSuperview().offset(-config.padding)
                }
                vc.titleLabel.snp.makeConstraints { (mk) in
                    mk.top.equalToSuperview().offset(config.padding)
                    mk.leading.equalTo(vc.imageView.snp.trailing).offset(config.margin)
                    mk.leading.greaterThanOrEqualToSuperview().offset(config.padding)
                    mk.trailing.equalToSuperview().offset(-config.padding)
                }
                vc.bodyLabel.snp.makeConstraints { (mk) in
                    mk.top.equalTo(vc.titleLabel.snp.bottom).offset(config.margin)
                    mk.leading.trailing.equalTo(vc.titleLabel)
                    mk.bottom.lessThanOrEqualToSuperview().offset(-config.padding)
                }
                if [.default, .loading].contains(vc.vm.scene) {
                    vc.blurMask(.extraLight)
                } else {
                    vc.blurMask(nil)
                }
                if let bv = vc.blurView {
                    vc.backgroundView = bv
                } else {
                    vc.backgroundView.backgroundColor = vc.vm.scene.backgroundColor
                }
                vc.view.layoutIfNeeded()
            }
        }()
        /// 加载视图
        /// - Parameter callback: 回调代码
        public mutating func loadSubviews(_ callback: @escaping (ProHUD.Toast) -> Void) {
            loadSubviews = callback
        }
        
        /// 更新视图
        /// - Parameter callback: 回调代码
        public mutating func reloadData(_ callback: @escaping (ProHUD.Toast) -> Void) {
            reloadData = callback
        }
        
    }
}

internal var toastConfig = ProHUD.Configuration.Toast()

public extension ProHUD {
    static func configToast(_ config: (inout Configuration.Toast) -> Void) {
        config(&toastConfig)
    }
}
