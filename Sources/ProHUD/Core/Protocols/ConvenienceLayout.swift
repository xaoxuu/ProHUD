//
//  LayoutProtocol.swift
//  
//
//  Created by xaoxuu on 2022/8/29.
//

import UIKit

public protocol ConvenienceLayout {
    
    // MARK: 增加
    
    /// 增加按钮
    /// - Parameter action: 按钮模型
    /// - Returns: 按钮实例
    @discardableResult func add(action: Action) -> Button
    
    /// 插入按钮
    /// - Parameters:
    ///   - action: 按钮模型
    ///   - index: 位置
    /// - Returns: 按钮实例
    @discardableResult func insert(action: Action, at index: Int) -> Button
    
    // MARK: 查找
    
    /// 查找某个按钮实例
    /// - Parameter identifier: 按钮唯一标识符
    /// - Returns: 按钮实例
    func button(for identifier: String) -> Button?
    
    // MARK: 更新
    
    /// 更新按钮
    /// - Parameters:
    ///   - title: 标题
    ///   - style: 样式
    ///   - identifier: 按钮唯一标识符
    func update(action title: String, style: Action.Style?, for identifier: String)
    
    // MARK: 删除
    
    /// 删除按钮
    /// - Parameter finder: 按钮查找器
    func remove(actions finder: Action.Filter)
    
    // MARK: 自定义控件
    
    /// 增加自定义视图（无法通过唯一标识符管理）
    /// - Parameter subview: 自定义子视图
    /// - Returns: 自定义子视图
    @discardableResult func add(subview: UIView) -> UIView
    
    // MARK: 布局工具
    
    /// 增加空隙（仅iOS11以上可用）
    /// - Parameter spacing: 自定义空隙
    func add(spacing: CGFloat)
    
    // MARK: 自定义布局
    
    /// 设置自定义视图，调用此func之后标题、正文以及其它actions设置将失效
    /// - Parameter customView: 自定义视图
    @discardableResult func set(customView: UIView) -> UIView
    
}

public extension ConvenienceLayout {
    
    func insert(action: Action, after id: String) {
        guard let self = self as? InternalConvenienceLayout, let index = self.actionIndex(for: id) else {
            return
        }
        insert(action: action, at: index + 1)
    }
    
    func insert(action: Action, before id: String) {
        guard let self = self as? InternalConvenienceLayout, let index = self.actionIndex(for: id) else {
            return
        }
        insert(action: action, at: index)
    }
    
}

protocol InternalConvenienceLayout: ConvenienceLayout {
    
    /// 查找某个按钮索引
    /// - Parameter identifier: 按钮唯一标识符
    /// - Returns: 按钮索引
    func actionIndex(for identifier: String) -> Int?
    
}
