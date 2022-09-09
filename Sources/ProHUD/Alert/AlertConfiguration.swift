//
//  File.swift
//  
//
//  Created by xaoxuu on 2022/8/29.
//

import UIKit

public extension Alert {
    
    class Configuration: ProHUD.Configuration {
        
        /// 指定排列方向（默认两个按钮水平排列，超过时垂直排列）
        public var actionAxis: NSLayoutConstraint.Axis?
        
        /// 堆叠深度
        public var stackDepth: CGFloat = 30
        
        public var enableShadow: Bool = true
        
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
        
        override var animateDurationForBuildInByDefault: CGFloat {
            animateDurationForBuildIn ?? 0.6
        }
        
    }
    
}
