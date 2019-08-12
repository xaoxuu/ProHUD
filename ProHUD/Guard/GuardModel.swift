//
//  GuardModel.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/8/9.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit

public extension Guard {
    
    class ViewModel {
        
        /// ID标识
        public var identifier = String(Date().timeIntervalSince1970)
        
        public weak var vc: Guard?
        
    }
    
}

public extension Guard.ViewModel {
    
    /// 加载一个标题
    /// - Parameter text: 文本
    @discardableResult func add(title: String?) -> UILabel {
        return vc!.add(title: title)
    }
    
    /// 加载一个副标题
    /// - Parameter text: 文本
    @discardableResult func add(subTitle: String?) -> UILabel {
        return vc!.add(subTitle: subTitle)
    }
    
    /// 加载一段正文
    /// - Parameter text: 文本
    @discardableResult func add(message: String?) -> UILabel {
        return vc!.add(message: message)
    }
    
    /// 加载一个按钮
    /// - Parameter style: 样式
    /// - Parameter title: 标题
    /// - Parameter action: 事件
    @discardableResult func add(action style: UIAlertAction.Style, title: String?, handler: (() -> Void)?) -> UIButton {
        return vc!.insert(action: nil, style: style, title: title, handler: handler)
    }
    
    /// 插入按钮
    /// - Parameter index: 索引
    /// - Parameter style: 样式
    /// - Parameter title: 标题
    /// - Parameter handler: 事件处理
    @discardableResult func insert(action index: Int, style: UIAlertAction.Style, title: String?, handler: (() -> Void)?) -> UIButton {
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
            vc?.remove(index: idx-i)
        }
    }
    
    
}
