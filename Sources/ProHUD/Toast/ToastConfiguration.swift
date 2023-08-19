//
//  ToastConfiguration.swift
//  
//
//  Created by xaoxuu on 2022/9/3.
//

import UIKit

public class ToastConfiguration: CommonConfiguration {
    
    static var customGlobalConfig: ((_ config: ToastConfiguration) -> Void)?
    
    /// 全局共享配置（只能设置一次，影响所有实例）
    /// - Parameter callback: 配置代码
    public static func global(_ callback: @escaping (_ config: ToastConfiguration) -> Void) {
        customGlobalConfig = callback
    }
    
    /// 默认的持续时间
    public var defaultDuration: TimeInterval = 10
    
    /// 元素与左右屏幕之间的距离（在没有达到最大宽度的情况下）
    public var marginX = CGFloat(8)
    
    /// 元素与元素之间的纵向距离
    public var marginY = CGFloat(8)
    
    var customInfoStack: ((_ stack: StackView) -> Void)?
    public func customInfoStack(handler: @escaping (_ stack: StackView) -> Void) {
        customInfoStack = handler
    }
    /// 行间距
    public var lineSpace = CGFloat(4)
    
    override var cardMaxWidthByDefault: CGFloat {
        cardMaxWidth ?? 500
    }
    
    override var cardMaxHeightByDefault: CGFloat {
        cardMaxHeight ?? (AppContext.appBounds.height / 3)
    }
    
    override var animateDurationForBuildInByDefault: CGFloat {
        animateDurationForBuildIn ?? 0.8
    }
    
    override var animateDurationForBuildOutByDefault: CGFloat {
        animateDurationForBuildIn ?? 0.8
    }
    
}
