//
//  ToastConvenienceLayout.swift
//  
//
//  Created by xaoxuu on 2022/9/8.
//

import UIKit

public extension Toast {
    
    @discardableResult func add(customView: UIView) -> UIView {
        if contentStack.superview != nil {
            contentStack.removeFromSuperview()
        }
        contentView.addSubview(customView)
        return customView
    }
    
    @discardableResult func add(action: Action) -> Button {
        insert(action: action, at: actionStack.arrangedSubviews.count)
    }
    
    func insert(action: Action, at index: Int) -> Button {
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
        if isViewLoaded {
            self.actionStack.layoutIfNeeded()
            UIView.animateEaseOut(duration: config.animateDurationForReloadByDefault) {
                self.view.layoutIfNeeded()
            }
        }
        return btn
    }
    
    // MARK: 布局工具
    
    func add(spacing: CGFloat) {
        if #available(iOS 11.0, *) {
            if let last = contentStack.arrangedSubviews.last {
                contentStack.setCustomSpacing(spacing, after: last)
            }
        }
    }
    
    /// 增加一个按钮
    /// - Parameters:
    ///   - title: 标题
    ///   - style: 样式
    ///   - identifier: 唯一标识符
    ///   - handler: 点击事件
    /// - Returns: 按钮实例
    @discardableResult func add(action title: String, style: Action.Style = .tinted, identifier: String? = nil, handler: ((_ toast: Toast) -> Void)? = nil) -> Button {
        if let handler = handler {
            let action = Action(identifier: identifier, style: style, title: title) { vc in
                if let vc = vc as? Toast {
                    handler(vc)
                }
            }
            return add(action: action)
        } else {
            return add(action: .init(identifier: identifier, style: style, title: title, handler: nil))
        }
    }
    
    
}

