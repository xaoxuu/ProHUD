//
//  AlertConvenienceLayout.swift
//  
//
//  Created by xaoxuu on 2022/9/8.
//

import UIKit

extension Alert: InternalConvenienceLayout {
    
    // MARK: 增加
    @discardableResult public func add(action: Action) -> Button {
        insert(action: action, at: actionStack.arrangedSubviews.count)
    }
    @discardableResult public func insert(action: Action, at index: Int) -> Button {
        let btn = Button(config: config, action: action)
        if index < actionStack.arrangedSubviews.count {
            actionStack.insertArrangedSubview(btn, at: index)
        } else {
            actionStack.addArrangedSubview(btn)
        }
        if actionStack.superview == nil {
            reloadActionStack()
            contentStack.layoutIfNeeded()
        }
        addTouchUpAction(for: btn) { [weak self] in
            if let self = self {
                action.handler?(self)
            }
            if action.handler == nil {
                self?.pop()
            }
        }
        if isViewLoaded {
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
            return actionStack.arrangedSubviews[index] as? Button
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
                while let index = actionIndex(for: identifier), index < actionStack.arrangedSubviews.count {
                    let view = actionStack.arrangedSubviews[index]
                    actionStack.removeArrangedSubview(view)
                    view.removeFromSuperview()
                    buttonEvents[view] = nil
                }
            }
        } else {
            for view in actionStack.arrangedSubviews {
                actionStack.removeArrangedSubview(view)
                view.removeFromSuperview()
                buttonEvents[view] = nil
            }
        }
        if isViewLoaded {
            UIView.animateEaseOut(duration: config.animateDurationForReloadByDefault) {
                self.actionStack.layoutIfNeeded()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // MARK: 自定义控件
    
    @discardableResult public func add(subview: UIView) -> UIView {
        contentStack.addArrangedSubview(subview)
        if #available(iOS 11.0, *) {
            if let last = contentStack.arrangedSubviews.last {
                contentStack.setCustomSpacing(0, after: last)
            }
        }
        return subview
    }
    
    @discardableResult public func add(action subview: UIView) -> UIView {
        actionStack.addArrangedSubview(subview)
        return subview
    }
    
    // MARK: 布局工具
    
    public func add(spacing: CGFloat) {
        add(spacing: spacing, for: contentStack)
    }
    
    public func add(spacing: CGFloat, for stack: UIStackView) {
        if #available(iOS 11.0, *) {
            if let last = stack.arrangedSubviews.last {
                stack.setCustomSpacing(spacing, after: last)
            }
        }
    }
    
    // MARK: 完全自定义布局
    
    @discardableResult public func set(customView: UIView) -> UIView {
        self.customView = customView
        contentView.subviews.forEach({ $0.removeFromSuperview() })
        contentView.addSubview(customView)
        return customView
    }
    
    // MARK: internal
    func actionIndex(for identifier: String) -> Int? {
        let arr = actionStack.arrangedSubviews.compactMap({ $0 as? Button })
        for i in 0 ..< arr.count {
            if arr[i].action?.identifier == identifier {
                return i
            }
        }
        return nil
    }
    
}

// MARK: more 
public extension Alert {
    
    /// 增加一个按钮
    /// - Parameters:
    ///   - title: 标题
    ///   - style: 样式
    ///   - identifier: 唯一标识符
    ///   - handler: 点击事件
    /// - Returns: 按钮实例
    @discardableResult func add(action title: String, style: Action.Style = .tinted, identifier: String? = nil, handler: ((_ alert: Alert) -> Void)? = nil) -> Button {
        if let handler = handler {
            let action = Action(identifier: identifier, style: style, title: title) { vc in
                if let vc = vc as? Alert {
                    handler(vc)
                }
            }
            return add(action: action)
        } else {
            return add(action: .init(identifier: identifier, style: style, title: title, handler: nil))
        }
    }
    
    func reloadTextStack() {
        setupTextStack()
        UIView.animateEaseOut(duration: config.animateDurationForReloadByDefault) {
            self.view.layoutIfNeeded()
        }
    }
    
}
