//
//  ToastModel.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/31.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

public extension ProHUD.Toast {
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
        
        /// 持续时间
        internal var duration: TimeInterval?
        
        /// 持续时间
        internal var durationBlock: DispatchWorkItem?
        
        /// 是否可以通过手势移除（向上划）
        public var removable = true
        
        /// 点击事件回调
        internal var tapCallback: (() -> Void)?
        
        public init(title: String? = nil, message: String? = nil, icon: UIImage? = nil) {
            self.title = title
            self.message = message
            self.icon = icon
        }
        
        
    }
    
}


