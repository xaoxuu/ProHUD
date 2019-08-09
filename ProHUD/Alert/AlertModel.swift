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
    
    struct ViewModel {
        
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
                durationBlock?.cancel()
                if let t = duration, t > 0 {
                    let v = vc
                    durationBlock = DispatchWorkItem(block: {
                        v?.pop()
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now()+t, execute: durationBlock!)
                } else {
                    durationBlock = nil
                }
            }
        }
        
        public weak var vc: Alert?
        
        /// 持续时间
        internal var durationBlock: DispatchWorkItem?
        
        /// 强制退出按钮
        internal var forceQuitTimerBlock: DispatchWorkItem?
        
        /// 强制退出代码
        internal var forceQuitCallback: (() -> Void)?
        
    }
    
}

public extension Alert.ViewModel {
    
    /// 添加按钮
    /// - Parameter style: 样式
    /// - Parameter text: 标题
    /// - Parameter handler: 事件处理
    @discardableResult mutating func add(action style: UIAlertAction.Style, title: String?, handler: (() -> Void)?) -> UIButton {
        duration = 0
        let btn = vc?.privAddButton(custom: Alert.Button.actionButton(title: title), handler: handler)
        if let b = btn as? Alert.Button {
            b.update(style: style)
        }
        return btn!
    }
    
    /// 插入按钮
    /// - Parameter index: 索引
    /// - Parameter style: 样式
    /// - Parameter title: 标题
    /// - Parameter handler: 事件处理
    @discardableResult mutating func insert(action index: Int, style: UIAlertAction.Style, title: String?, handler: (() -> Void)?) -> UIButton {
        duration = 0
        let btn = vc?.privAddButton(custom: Alert.Button.actionButton(title: title), at: index, handler: handler)
        if let b = btn as? Alert.Button {
            b.update(style: style)
        }
        return btn!
    }
    
    /// 更新按钮
    /// - Parameter index: 索引
    /// - Parameter style: 样式
    /// - Parameter title: 标题
    /// - Parameter handler: 事件处理
    mutating func update(action index: Int, style: UIAlertAction.Style, title: String?, handler: (() -> Void)?) {
        vc?.privUpdateButton(action: index, style: style, title: title, handler)
    }
    
    /// 移除按钮
    /// - Parameter index: 索引
    mutating func remove(action index: Int...) {
        guard let alert = self.vc else { return }
        for (i, idx) in index.enumerated() {
            alert.privRemoveAction(index: idx-i)
        }
    }
    
    
}
