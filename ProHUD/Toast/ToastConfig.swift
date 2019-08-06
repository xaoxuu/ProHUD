//
//  cfg.toast.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/31.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import SnapKit

public extension ProHUD.Configuration {
    struct Toast {
        // MARK: 卡片样式
        /// 最大宽度（用于优化横屏或者iPad显示）
        public var maxWidth = CGFloat(556)
        /// 圆角半径
        public var cornerRadius = CGFloat(12)
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
        public var titleFont = UIFont.boldSystemFont(ofSize: 18)
        /// 标题最多行数
        public var titleMaxLines = Int(1)
        
        /// 正文字体
        public var bodyFont = UIFont.systemFont(ofSize: 16)
        /// 正文最多行数
        public var bodyMaxLines = Int(10)
        
        /// 加载视图（如果需要完全自定义整个View，可以重写这个）
        /// - Parameter callback: 回调代码
        public mutating func loadSubviews(_ callback: @escaping (ProHUD.Toast) -> Void) {
            privLoadSubviews = callback
        }
        
        /// 更新视图
        /// - Parameter callback: 回调代码
        public mutating func reloadData(_ callback: @escaping (ProHUD.Toast) -> Void) {
            privReloadData = callback
        }
        
    }
}

// MARK: - 默认实现

internal extension ProHUD.Configuration.Toast {
    var loadSubviews: (ProHUD.Toast) -> Void {
        return privLoadSubviews
    }
    var reloadData: (ProHUD.Toast) -> Void {
        return privReloadData
    }
}

fileprivate var privLoadSubviews: (ProHUD.Toast) -> Void = {
    return { (vc) in
        debug(vc, "loadSubviews")
        vc.view.tintColor = cfg.toast.tintColor
        vc.view.addSubview(vc.titleLabel)
        vc.view.addSubview(vc.bodyLabel)
        vc.view.addSubview(vc.imageView)
    }
}()

fileprivate var privReloadData: (ProHUD.Toast) -> Void = {
    return { (vc) in
        debug(vc, "reloadData")
        let config = cfg.toast
        let scene = vc.model.scene
        // 设置数据
        let imgStr: String
        switch vc.model.scene {
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
        let img = vc.model.icon ?? ProHUD.image(named: imgStr)
        vc.imageView.image = img
        vc.titleLabel.textColor = cfg.primaryLabelColor
        vc.titleLabel.text = vc.model.title
        vc.bodyLabel.textColor = cfg.secondaryLabelColor
        vc.bodyLabel.text = vc.model.message
        
        // 更新布局
        vc.imageView.snp.makeConstraints { (mk) in
            mk.top.equalToSuperview().offset(config.padding)
            mk.leading.equalToSuperview().offset(config.padding)
            mk.bottom.lessThanOrEqualToSuperview().offset(-config.padding)
            mk.width.height.equalTo(config.iconSize)
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
        
        vc.view.layoutIfNeeded()
        switch vc.model.scene {
        case .loading:
            vc.model.duration = nil
        default:
            vc.model.duration = 3
        }
        
    }
    
}()
