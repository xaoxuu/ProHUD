//
//  HUDConfig.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/29.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
public var sharedWindowScene: UIWindowScene?

public extension ProHUD {
    struct Configuration {
        
        /// 是否允许Debug模式输出
        public var enableDebugPrint = true
        
        /// 根控制器
        public var rootViewController: UIViewController?
        
        @available(iOS 13.0, *)
        
        /// Xcode11 创建的基于 windowScene 的应用必须设置此值
        public var windowScene: UIWindowScene? {
            set {
                sharedWindowScene = newValue
            }
            get {
                return sharedWindowScene
            }
        }
        
        /// 动态颜色（适配iOS13）
        public lazy var dynamicColor: UIColor = {
            if #available(iOS 13.0, *) {
                let color = UIColor { (traitCollection: UITraitCollection) -> UIColor in
                    if traitCollection.userInterfaceStyle == .dark {
                        return .init(white: 1, alpha: 1)
                    } else {
                        return .init(white: 0.1, alpha: 1)
                    }
                }
                return color
            } else {
                // Fallback on earlier versions
            }
            return .init(white: 0.1, alpha: 1)
        }()
        
        /// 主标签文本颜色
        public lazy var primaryLabelColor: UIColor = {
            return dynamicColor.withAlphaComponent(0.8)
        }()
        
        /// 次级标签文本颜色
        public lazy var secondaryLabelColor: UIColor = {
            return dynamicColor.withAlphaComponent(0.66)
        }()
        
        public func blurView(_ callback: @escaping () -> UIVisualEffectView) {
            createBlurView = callback
        }
        
        
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

/// 配置
internal var cfg = ProHUD.Configuration()

public extension ProHUD {
    static func config(_ config: (inout Configuration) -> Void) {
        config(&cfg)
    }
}

internal var createBlurView: () -> UIVisualEffectView = {
    return {
        let vev = UIVisualEffectView()
        if #available(iOS 13.0, *) {
            vev.effect = UIBlurEffect(style: .systemMaterial)
        } else if #available(iOS 11.0, *) {
            vev.effect = UIBlurEffect(style: .extraLight)
        } else {
            vev.effect = .none
            vev.backgroundColor = .white
        }
        return vev
    }
}()
