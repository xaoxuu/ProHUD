//
//  ToastConvenienceLayout.swift
//  
//
//  Created by xaoxuu on 2022/9/8.
//

import UIKit

extension ToastTarget: ConvenienceLayout {
    
    // MARK: 增加
    
    /// 增加一个按钮
    /// - Parameters:
    ///   - title: 标题
    ///   - style: 样式
    ///   - identifier: 唯一标识符
    ///   - handler: 点击事件
    /// - Returns: 按钮实例
    @discardableResult public func add(action title: String, style: Action.Style = .tinted, identifier: String? = nil, handler: ((_ toast: ToastTarget) -> Void)? = nil) -> Button {
        if let handler = handler {
            let action = Action(identifier: identifier, style: style, title: title) { vc in
                if let vc = vc as? ToastTarget {
                    handler(vc)
                }
            }
            return add(action: action)
        } else {
            return add(action: .init(identifier: identifier, style: style, title: title, handler: nil))
        }
    }
    
    @discardableResult public func add(action: Action) -> Button {
        insert(action: action, at: actionStack.arrangedSubviews.count)
    }
    
    @discardableResult public func insert(action: Action, at index: Int) -> Button {
        let btn = ToastButton(config: config, action: action)
        if index < actionStack.arrangedSubviews.count {
            actionStack.insertArrangedSubview(btn, at: index)
        } else {
            actionStack.addArrangedSubview(btn)
        }
        loadActionStackIfNeeded()
        addTouchUpAction(for: btn) { [weak self] in
            if let self = self {
                action.handler?(self)
            }
            if action.handler == nil {
                self?.pop()
            }
        }
        if isViewDisplayed {
            self.actionStack.layoutIfNeeded()
            UIView.animateEaseOut(duration: config.animateDurationForReloadByDefault) {
                self.view.layoutIfNeeded()
            }
        }
        return btn
    }
    
    
    // MARK: 查找
    public func button(for identifier: String) -> Button? {
        if let index = actionIndex(for: identifier) {
            return contentStack.arrangedSubviews[index] as? Button
        }
        return nil
    }
    
    // MARK: 更新
    public func update(action title: String, style: Action.Style? = nil, for identifier: String) {
        if let btn = button(for: identifier), let act = btn.action {
            act.title = title
            if let style = style {
                act.style = style
            }
            btn.update(config: config, action: act)
        }
    }
    
    // MARK: 删除
    
    public func remove(actions finder: Action.Filter) {
        if finder.ids.count > 0 {
            for identifier in finder.ids {
                while let index = actionIndex(for: identifier), index < contentStack.arrangedSubviews.count {
                    let view = contentStack.arrangedSubviews[index]
                    contentStack.removeArrangedSubview(view)
                    view.removeFromSuperview()
                    buttonEvents[view] = nil
                }
            }
        } else {
            for view in contentStack.arrangedSubviews {
                contentStack.removeArrangedSubview(view)
                view.removeFromSuperview()
                buttonEvents[view] = nil
            }
        }
        if isViewDisplayed {
            UIView.animateEaseOut(duration: config.animateDurationForReloadByDefault) {
                self.contentStack.layoutIfNeeded()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // MARK: 自定义控件
    
    @discardableResult public func add(subview: UIView) -> UIView {
        if contentStack.superview != nil {
            contentStack.removeFromSuperview()
        }
        contentView.addSubview(subview)
        return subview
    }
    
    // MARK: 布局工具
    
    public func set(spacing: CGFloat, after: UIView?, in stack: UIStackView) {
        if #available(iOS 11.0, *) {
            if let after = after ?? stack.arrangedSubviews.last {
                stack.setCustomSpacing(spacing, after: after)
            }
        }
    }
    
    public func set(contentSpacing: CGFloat, after: UIView?) {
        set(spacing: contentSpacing, after: after, in: contentStack)
    }
    public func set(textSpacing: CGFloat, after: UIView?) {
        set(spacing: textSpacing, after: after, in: textStack)
    }
    public func set(actionSpacing: CGFloat, after: UIView?) {
        set(spacing: actionSpacing, after: after, in: actionStack)
    }
    public func add(contentSpacing: CGFloat) {
        set(spacing: contentSpacing, after: nil, in: contentStack)
    }
    public func add(textSpacing: CGFloat) {
        set(spacing: textSpacing, after: nil, in: textStack)
    }
    public func add(actionSpacing: CGFloat) {
        set(spacing: actionSpacing, after: nil, in: actionStack)
    }
    
    
    // MARK: 完全自定义布局
    
    public func set(customView: UIView) -> UIView {
        self.customView = customView
        contentView.addSubview(customView)
        return customView
    }
    
    // MARK: internal
    func actionIndex(for identifier: String) -> Int? {
        let arr = contentStack.arrangedSubviews.compactMap({ $0 as? Button })
        for i in 0 ..< arr.count {
            if arr[i].action?.identifier == identifier {
                return i
            }
        }
        return nil
    }
    
}

