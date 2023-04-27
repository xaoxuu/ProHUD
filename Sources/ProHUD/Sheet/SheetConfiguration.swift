//
//  SheetConfiguration.swift
//  
//
//  Created by xaoxuu on 2022/9/8.
//

import UIKit

public extension Sheet {
    
    class Configuration: ProHUD.Configuration {
        
        /// 卡片距离屏幕的间距
        public var screenEdgeInset: CGFloat = 4
        
        /// 是否是全屏的页面
        public var isFullScreen = false
        
        /// 副标题字体
        
        var customSubtitleLabel: ((_ label: UILabel) -> Void)?
        
        public func customSubtitleLabel(handler: @escaping (_ label: UILabel) -> Void) {
            customSubtitleLabel = handler
        }
        
        static var customShared: ((_ config: Configuration) -> Void)?
        
        /// 共享配置（只能设置一次，影响所有实例）
        /// - Parameter callback: 配置代码
        public static func shared(_ callback: @escaping (_ config: Configuration) -> Void) {
            customShared = callback
        }
        
        var customBackgroundViewMask: ((_ mask: UIView) -> Void)?

        /// 设置背景蒙版
        /// - Parameter callback: 自定义内容卡片蒙版代码
        public func backgroundViewMask(_ callback: @escaping (_ mask: UIView) -> Void) {
            customBackgroundViewMask = callback
        }
        
        override var cardMaxWidthByDefault: CGFloat { cardMaxWidth ?? 500 }
        
        override var cardMaxHeightByDefault: CGFloat { cardMaxHeight ?? (UIScreen.main.bounds.height - 50) }
        
        override var animateDurationForBuildInByDefault: CGFloat {
            animateDurationForBuildIn ?? 0.5
        }
        
        override var animateDurationForBuildOutByDefault: CGFloat {
            animateDurationForBuildOut ?? 0.5
        }
        
        override var cardCornerRadiusByDefault: CGFloat { cardCornerRadius ?? 40 }
        
    }
    
}
