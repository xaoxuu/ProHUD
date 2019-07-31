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
        
        internal var toast = Toast()
        internal var alert = Alert()
        internal var `guard` = Guard()
        
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

