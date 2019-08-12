//
//  AlertModel.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/29.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit

public extension Alert {
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
    
    class ViewModel {
        
        /// ID标识
        public var identifier = String(Date().timeIntervalSince1970)
        
        /// 使用场景
        public var scene = Scene.default
        
        /// 标题
        public var title: String? {
            didSet {
                vc?.titleLabel?.text = title
            }
        }
        
        /// 正文
        public var message: String? {
            didSet {
                vc?.bodyLabel?.text = message
            }
        }
        
        /// 图标
        public var icon: UIImage? {
            didSet {
                vc?.imageView?.image = icon
            }
        }
        
        /// 持续时间（为空代表根据场景不同的默认配置，为0代表无穷大）
        public var duration: TimeInterval? {
            didSet {
                updateDuration()
            }
        }
        
        public weak var vc: Alert?
        
        // MARK: 私有
        
        /// 持续时间
        internal var durationBlock: DispatchWorkItem?
        
        /// 强制退出按钮
        internal var forceQuitTimerBlock: DispatchWorkItem?
        
        /// 强制退出代码
        internal var forceQuitCallback: (() -> Void)?
        
        internal func updateDuration() {
            durationBlock?.cancel()
            if let t = duration ?? cfg.alert.durationForScene(scene), t > 0 {
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

public extension Alert.ViewModel {
    
    /// 添加按钮
    /// - Parameter style: 样式
    /// - Parameter text: 标题
    /// - Parameter handler: 事件处理
    @discardableResult func add(action style: UIAlertAction.Style, title: String?, handler: (() -> Void)?) -> UIButton {
        duration = 0
        return vc!.insert(action: nil, style: style, title: title, handler: handler)
    }
    
    /// 插入按钮
    /// - Parameter index: 索引
    /// - Parameter style: 样式
    /// - Parameter title: 标题
    /// - Parameter handler: 事件处理
    @discardableResult func insert(action index: Int, style: UIAlertAction.Style, title: String?, handler: (() -> Void)?) -> UIButton {
        duration = 0
        return vc!.insert(action: index, style: style, title: title, handler: handler)
    }
    
    /// 更新按钮
    /// - Parameter index: 索引
    /// - Parameter style: 样式
    /// - Parameter title: 标题
    /// - Parameter handler: 事件处理
    func update(action index: Int, style: UIAlertAction.Style, title: String?, handler: (() -> Void)?) {
        vc?.update(action: index, style: style, title: title, handler: handler)
    }
    
    /// 移除按钮
    /// - Parameter index: 索引
    func remove(action index: Int...) {
        for (i, idx) in index.enumerated() {
            vc?.remove(action: idx-i)
        }
    }
    
    
}
