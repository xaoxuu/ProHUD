//
//  File.swift
//  
//
//  Created by xaoxuu on 2022/8/29.
//

import UIKit

public class AlertConfiguration: CommonConfiguration {
    
    /// 堆叠深度
    public var stackDepth: CGFloat = 30
    
    public var enableShadow: Bool = true
    
    private static var customGlobalConfig: ((_ config: AlertConfiguration) -> Void)?
    
    public override init() {
        super.init()
        Self.customGlobalConfig?(self)
    }
    
    /// 全局共享配置（只能设置一次，影响所有实例）
    /// - Parameter callback: 配置代码
    public static func global(_ callback: @escaping (_ config: AlertConfiguration) -> Void) {
        customGlobalConfig = callback
    }
    
    var customBackgroundViewMask: ((_ mask: UIView) -> Void)?
    
    /// 设置背景蒙版
    /// - Parameter callback: 自定义内容卡片蒙版代码
    public func backgroundViewMask(_ callback: @escaping (_ mask: UIView) -> Void) {
        customBackgroundViewMask = callback
    }
    
    override var animateDurationForBuildOutByDefault: CGFloat {
        animateDurationForBuildOut ?? 0.2
    }
    
}
