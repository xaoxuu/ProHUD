//
//  AlertModel.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/29.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit

public extension ProHUD.Alert {
    enum Scene {
        /// 默认场景
        case `default`
        
        /// 加载中场景
        case loading
        
        /// 确认场景
        case confirm
        
        /// 删除场景
        case delete
        
        /// 成功场景
        case success
        
        /// 警告场景
        case warning
        
        /// 错误场景
        case error
        
        public var backgroundColor: UIColor {
            switch self {
            case .success:
                return UIColor.green
            case .warning:
                return UIColor.yellow
            case .error:
                return UIColor.red
            default:
                return .clear
            }
        }
        
        public var tintColor: UIColor {
            switch self {
            case .success, .error:
                return .white
            default:
                return UIColor.darkGray
            }
        }
    }
    
    struct ViewModel {
        
        /// 使用场景
        public var scene = Scene.default
        
        /// 标题
        public var title: String?
        
        /// 正文
        public var message: String?
        
        /// 图标
        public var icon: UIImage?
        
        public init(title: String? = nil, message: String? = nil, icon: UIImage? = nil) {
            self.title = title
            self.message = message
            self.icon = icon
        }
        
        
    }
    
}

