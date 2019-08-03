//
//  HUDConfig.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/29.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit

public extension ProHUD {
    struct Configuration {
        
        /// 是否允许Debug模式输出
        public var enableDebugPrint = true
        
        /// 动态颜色（适配iOS13）
        public lazy var dynamicColor: UIColor = {
            if #available(iOS 13.0, *) {
                let color = UIColor { (traitCollection: UITraitCollection) -> UIColor in
                    if traitCollection.userInterfaceStyle == .dark {
                        return .white
                    } else {
                        return .black
                    }
                }
                return color
            } else {
                // Fallback on earlier versions
            }
            return .init(white: 0.2, alpha: 1)
        }()
        
        /// 主标签文本颜色
        public lazy var primaryLabelColor: UIColor = {
            return dynamicColor.withAlphaComponent(0.75)
        }()
        
        /// 次级标签文本颜色
        public lazy var secondaryLabelColor: UIColor = {
            return dynamicColor.withAlphaComponent(0.6)
        }()
        
        
        public var toast = Toast()
        public var alert = Alert()
        public var `guard` = Guard()
        
        /// Toast的配置
        /// - Parameter callback: 回调
        public mutating func toast(_ callback: @escaping (inout Toast) -> Void) {
            callback(&toast)
        }
        
        /// Alert的配置
        /// - Parameter callback: 回调
        public mutating func alert(_ callback: @escaping (inout Alert) -> Void) {
            callback(&alert)
        }
        
        /// Guard的配置
        /// - Parameter callback: 回调
        public mutating func `guard`(_ callback: @escaping (inout Guard) -> Void) {
            callback(&`guard`)
        }
        
    }
}

internal var cfg = ProHUD.Configuration()

public extension ProHUD {
    static func config(_ config: (inout Configuration) -> Void) {
        config(&cfg)
    }
}
