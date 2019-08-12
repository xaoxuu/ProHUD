//
//  ToastModel.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/31.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit

public extension Toast {
    enum Scene {
        /// 默认场景
        case `default`
        
        /// 加载中场景
        case loading
        
        /// 成功场景
        case success
        
        /// 警告场景
        case warning
        
        /// 错误场景
        case error
        
    }
    
    class ViewModel {
        
        /// ID标识
        public var identifier = String(Date().timeIntervalSince1970)
        
        /// 使用场景
        public var scene = Scene.default
        
        /// 标题
        public var title: String? {
            didSet {
                vc?.titleLabel.text = title
            }
        }
        
        /// 正文
        public var message: String? {
            didSet {
                vc?.bodyLabel.text = message
            }
        }
        
        /// 图标
        public var icon: UIImage? {
            didSet {
                vc?.imageView.image = icon
            }
        }
        
        /// 持续时间
        public var duration: TimeInterval? {
            didSet {
                updateDuration()
            }
        }
        
        public weak var vc: Toast?
        
        /// 是否可以通过手势移除（向上滑出屏幕）
        public var removable = true
        
        
        // MARK: 私有
        
        /// 持续时间
        internal var durationBlock: DispatchWorkItem?
        
        /// 点击事件回调
        internal var tapCallback: (() -> Void)?
        
        internal func updateDuration() {
            durationBlock?.cancel()
            if let t = duration ?? cfg.toast.durationForScene(scene), t > 0 {
                durationBlock = DispatchWorkItem(block: { [weak self] in
                    self?.vc?.pop()
                })
                DispatchQueue.main.asyncAfter(deadline: .now()+t, execute: durationBlock!)
            } else {
                durationBlock = nil
            }
        }
        
    }
    
}
