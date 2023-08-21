//
//  SheetConfiguration.swift
//  
//
//  Created by xaoxuu on 2022/9/8.
//

import UIKit

public class SheetConfiguration: CommonConfiguration {
    
    /// 堆叠效果
    public var stackDepthEffect: Bool = false
    
    /// 卡片距离屏幕的间距
    public var windowEdgeInset: CGFloat = 16
    
    /// 是否是全屏的页面
    public var isFullScreen = false
    
    /// 副标题字体
    
    var customSubtitleLabel: ((_ label: UILabel) -> Void)?
    
    public func customSubtitleLabel(handler: @escaping (_ label: UILabel) -> Void) {
        customSubtitleLabel = handler
    }
    
    static var customGlobalConfig: ((_ config: SheetConfiguration) -> Void)?
    
    /// 全局共享配置（只能设置一次，影响所有实例）
    /// - Parameter callback: 配置代码
    public static func global(_ callback: @escaping (_ config: SheetConfiguration) -> Void) {
        customGlobalConfig = callback
    }
    
    var customBackgroundViewMask: ((_ mask: UIView) -> Void)?

    /// 设置背景蒙版
    /// - Parameter callback: 自定义内容卡片蒙版代码
    public func backgroundViewMask(_ callback: @escaping (_ mask: UIView) -> Void) {
        customBackgroundViewMask = callback
    }
    
    override var cardEdgeInsetsByDefault: UIEdgeInsets {
        cardEdgeInsets ?? .init(top: 24, left: 24, bottom: 24, right: 24)
    }
    
    override var cardMaxWidthByDefault: CGFloat { cardMaxWidth ?? 500 }
    
    override var cardMaxHeightByDefault: CGFloat { cardMaxHeight ?? (AppContext.appBounds.height - 50) }
    
    override var animateDurationForBuildInByDefault: CGFloat {
        animateDurationForBuildIn ?? 0.38
    }
    
    override var animateDurationForBuildOutByDefault: CGFloat {
        animateDurationForBuildOut ?? 0.24
    }
    
    override var cardCornerRadiusByDefault: CGFloat { cardCornerRadius ?? 32 }
    
}
