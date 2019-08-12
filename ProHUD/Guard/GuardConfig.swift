//
//  cfg.guard.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/31.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import SnapKit
import Inspire

public extension ProHUD.Configuration {
    struct Guard {
        // MARK: 卡片样式
        /// 最大宽度（用于优化横屏或者iPad显示）
        public var cardMaxWidth = CGFloat(460)
        /// 圆角半径（手机竖屏时为0）
        public var cardCornerRadius = CGFloat(16)
        
        /// 余量：元素与元素之间的距离
        public var margin = CGFloat(8)
        /// 填充：元素内部控件距离元素边界的距离
        public var padding = CGFloat(16)
        
        /// 颜色
        public var tintColor: UIColor?
        
        // MARK: 文本样式
        /// 标题字体
        public var titleFont = UIFont.boldSystemFont(ofSize: 22)
        /// 副标题字体
        public var subTitleFont = UIFont.boldSystemFont(ofSize: 20)
        /// 正文字体
        public var bodyFont = UIFont.systemFont(ofSize: 18)
        
        // MARK: 按钮样式
        /// 按钮字体
        public var buttonFont = UIFont.boldSystemFont(ofSize: 18)
        
        /// 按钮圆角半径
        public var buttonCornerRadius = CGFloat(12)
        
        /// 更新视图
        /// - Parameter callback: 回调代码
        public mutating func reloadData(_ callback: @escaping (ProHUD.Guard) -> Void) {
            privReloadData = callback
        }
        
    }
}


// MARK: - 内部调用
internal extension ProHUD.Configuration.Guard {
    
    var reloadData: (ProHUD.Guard) -> Void {
        return privReloadData
    }
    
    var reloadStack: (ProHUD.Guard) -> Void {
        return { (vc) in
            if vc.textStack.arrangedSubviews.count > 0 {
                vc.contentStack.addArrangedSubview(vc.textStack)
            } else {
                vc.textStack.removeFromSuperview()
            }
            if vc.actionStack.arrangedSubviews.count > 0 {
                vc.contentStack.addArrangedSubview(vc.actionStack)
            } else {
                vc.actionStack.removeFromSuperview()
            }
        }
    }
    
}

// MARK: - 默认实现
fileprivate var privReloadData: (ProHUD.Guard) -> Void = {
    return { (vc) in
        debug(vc, "reloadData")
        let config = cfg.guard
        // background
        vc.view.tintColor = config.tintColor
        vc.view.backgroundColor = UIColor(white: 0, alpha: 0)
        vc.view.addSubview(vc.contentView)
        vc.contentView.contentView.addSubview(vc.contentStack)
        // 更新布局
        var width = UIScreen.main.bounds.width
        if width > config.cardMaxWidth {
            // 横屏或者iPad
            width = config.cardMaxWidth
            vc.contentView.layer.masksToBounds = true
            vc.contentView.layer.cornerRadius = config.cardCornerRadius
        } else {
            vc.contentView.layer.shadowRadius = 4
            vc.contentView.layer.shadowOffset = .init(width: 0, height: 2)
            vc.contentView.layer.shadowOpacity = 0.12
        }
        vc.contentView.snp.makeConstraints { (mk) in
            mk.centerX.equalToSuperview()
            if UIDevice.current.userInterfaceIdiom == .phone {
                if width < config.cardMaxWidth {
                    mk.bottom.equalToSuperview()
                } else {
                    mk.bottom.equalToSuperview().offset(-Inspire.shared.screen.safeAreaInsets.bottom)
                }
            } else if UIDevice.current.userInterfaceIdiom == .pad {
                mk.centerY.equalToSuperview()
            }
            mk.width.equalTo(width)
        }
        // stack
        vc.contentStack.snp.makeConstraints { (mk) in
            mk.top.equalToSuperview().offset(config.padding)
            mk.centerX.equalToSuperview()
            if width < config.cardMaxWidth {
                let bottom = Inspire.shared.screen.safeAreaInsets.bottom
                if bottom == 0 {
                    mk.bottom.equalToSuperview().offset(-config.padding)
                } else {
                    mk.bottom.equalToSuperview().offset(-config.padding/2 - bottom)
                }
            } else {
                mk.bottom.equalToSuperview().offset(-config.padding)
            }
            if isPortrait {
                mk.width.equalToSuperview().offset(-config.padding * 2)
            } else {
                mk.width.equalToSuperview().offset(-config.padding * 4)
            }
        }
        config.reloadStack(vc)
    }
}()
