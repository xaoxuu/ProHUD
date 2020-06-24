//
//  cfg.toast.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/31.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit
import SnapKit

public extension UIWindow.Level {
    static let proToast = UIWindow.Level.alert + 1000
}

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
        /// 行间距
        public var lineSpace = CGFloat(4)
        // MARK: 图标样式
        /// 图标尺寸
        public var iconSize = CGSize(width: 44, height: 44)
        
        // MARK: 文本样式
        /// 标题字体
        public var titleFont = UIFont.boldSystemFont(ofSize: 18)
        /// 标题最多行数
        public var titleMaxLines = Int(5)
        
        /// 正文字体
        public var bodyFont = UIFont.systemFont(ofSize: 16)
        /// 正文最多行数
        public var bodyMaxLines = Int(20)
        
        /// 更新视图
        /// - Parameter callback: 回调代码
        public mutating func reloadData(_ callback: @escaping (ProHUD.Toast) -> Void) {
            privReloadData = callback
        }
        
        
    }
}


// MARK: - 内部调用
internal extension ProHUD.Configuration.Toast {
    
    var reloadData: (ProHUD.Toast) -> Void {
        return privReloadData
    }
    
    
}

// MARK: - 默认实现
fileprivate var privReloadData: (ProHUD.Toast) -> Void = {
    return { (vc) in
        debug(vc, "reloadData")
        let config = cfg.toast
        let scene = vc.vm.scene
        if vc.imageView.superview == nil {
            vc.view.addSubview(vc.imageView)
        }
        if vc.textStack.superview == nil {
            vc.view.addSubview(vc.textStack)
            vc.textStack.addArrangedSubview(vc.titleLabel)
            vc.textStack.addArrangedSubview(vc.bodyLabel)
        }
        
        // 设置数据
        vc.imageView.image = vc.vm.icon ?? vc.vm.scene.image
        vc.imageView.layer.removeAllAnimations()
        vc.titleLabel.textColor = cfg.primaryLabelColor
        vc.titleLabel.text = vc.vm.title ?? vc.vm.scene.title
        vc.bodyLabel.textColor = cfg.secondaryLabelColor
        vc.bodyLabel.text = vc.vm.message ?? vc.vm.scene.message
        
        if let count = vc.titleLabel.text?.count, count > 0 {
            vc.textStack.insertArrangedSubview(vc.titleLabel, at: 0)
        } else {
            vc.titleLabel.removeFromSuperview()
        }
        if let count = vc.bodyLabel.text?.count, count > 0 {
            vc.textStack.addArrangedSubview(vc.bodyLabel)
        } else {
            vc.bodyLabel.removeFromSuperview()
        }
        
        // 更新布局
        vc.imageView.snp.makeConstraints { (mk) in
            mk.top.equalToSuperview().offset(config.padding)
            mk.leading.equalToSuperview().offset(config.padding)
            mk.bottom.lessThanOrEqualToSuperview().offset(-config.padding)
            mk.width.height.equalTo(config.iconSize)
        }
        vc.textStack.snp.makeConstraints { (mk) in
            mk.top.equalToSuperview().offset(config.padding)
            mk.leading.equalTo(vc.imageView.snp.trailing).offset(config.padding - 4)
            mk.leading.greaterThanOrEqualToSuperview().offset(config.padding)
            mk.trailing.equalToSuperview().offset(-config.padding)
            mk.bottom.lessThanOrEqualToSuperview().offset(-config.padding)
        }
        
        vc.view.layoutIfNeeded()
        
        // 设置持续时间
        vc.vm.updateDuration()
        
        // id 包含 .rotate 的会自动旋转
        if vc.vm.scene.identifier.contains(".rotate") {
            vc.startRotate()
        }
        // 移除进度
        vc.progressView?.removeFromSuperview()
        
    }
    
}()
