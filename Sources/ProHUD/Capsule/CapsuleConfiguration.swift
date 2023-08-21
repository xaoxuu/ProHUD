//
//  CapsuleConfiguration.swift
//  
//
//  Created by xaoxuu on 2022/9/8.
//

import UIKit

public class CapsuleConfiguration: CommonConfiguration {
    
    public typealias CustomAnimateHandler = ((_ window: UIWindow, _ completion: @escaping () -> Void) -> Void)
    
    private static var customGlobalConfig: ((_ config: CapsuleConfiguration) -> Void)?
    
    public override init() {
        super.init()
        Self.customGlobalConfig?(self)
    }
    
    /// 全局共享配置（只能设置一次，影响所有实例）
    /// - Parameter callback: 配置代码
    public static func global(_ callback: @escaping (_ config: CapsuleConfiguration) -> Void) {
        customGlobalConfig = callback
    }
    
    /// 默认的持续时间
    public var defaultDuration: TimeInterval = 3
    
    override var cardCornerRadiusByDefault: CGFloat {
        cardCornerRadius ?? 16
    }
    
    override var cardEdgeInsetsByDefault: UIEdgeInsets {
        cardEdgeInsets ?? .init(top: 12, left: 16, bottom: 12, right: 16)
    }
    
    override var cardMaxWidthByDefault: CGFloat { cardMaxWidth ?? 320 }
    
    override var cardMaxHeightByDefault: CGFloat { cardMaxHeight ?? 120 }
    
    override var animateDurationForBuildInByDefault: CGFloat {
        animateDurationForBuildIn ?? 0.64
    }
    
    override var animateDurationForBuildOutByDefault: CGFloat {
        animateDurationForBuildOut ?? 0.32
    }
    
    var animateBuildIn: CustomAnimateHandler?
    public func animateBuildIn(_ handler: CustomAnimateHandler?) {
        animateBuildIn = handler
    }
    
    var animateBuildOut: CustomAnimateHandler?
    public func animateBuildOut(_ handler: CustomAnimateHandler?) {
        animateBuildOut = handler
    }
    
    
}
