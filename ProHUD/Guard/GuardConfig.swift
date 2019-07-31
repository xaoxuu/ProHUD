//
//  GuardConfig.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/31.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import SnapKit

public extension ProHUD.Configuration {
    struct Guard {
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
        lazy var loadSubviews: (ProHUD.Alert) -> Void = {
            return { (vc) in
                debugPrint(vc, "loadSubviews")
                
            }
        }()
        
        /// 更新视图
        lazy var updateFrame: (ProHUD.Alert) -> Void = {
            return { (vc) in
                debugPrint(vc, "updateFrame")
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
