//
//  SheetConvenienceLayout.swift
//  
//
//  Created by xaoxuu on 2022/9/8.
//

import UIKit

extension Sheet: ConvenienceLayout {
    
    // MARK: 增加
    @discardableResult public func add(action: Action) -> Button {
        insert(action: action, at: contentStack.arrangedSubviews.count)
    }
    @discardableResult public func insert(action: Action, at index: Int) -> Button {
        let btn = SheetButton(config: config, action: action)
        if index < contentStack.arrangedSubviews.count {
            contentStack.insertArrangedSubview(btn, at: index)
        } else {
            contentStack.addArrangedSubview(btn)
        }
        addTouchUpAction(for: btn) { [weak self] in
            if let self = self {
                action.handler?(self)
            }
            if action.handler == nil {
                self?.pop()
            }
        }
        if isViewDisplayed {
            self.contentStack.layoutIfNeeded()
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
        contentStack.addArrangedSubview(subview)
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
    
    public func add(spacing: CGFloat) {
        set(spacing: spacing, after: nil, in: contentStack)
    }
    
    // MARK: 完全自定义布局
    
    @discardableResult public func set(customView: UIView) -> UIView {
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

// MARK: more
public extension Sheet {
    
    /// 增加一个标题
    /// - Parameter text: 文本
    @discardableResult func add(title text: String?) -> UILabel {
        let lb = add(subTitle: text)
        lb.font = .boldSystemFont(ofSize: 24)
        lb.textColor = config.primaryLabelColor
        lb.textAlignment = .center
        config.customTitleLabel?(lb)
        return lb
    }
    
    /// 增加一个副标题
    /// - Parameter text: 文本
    @discardableResult func add(subTitle text: String?) -> UILabel {
        let lb = UILabel()
        lb.font = .boldSystemFont(ofSize: 20)
        lb.textColor = config.primaryLabelColor
        lb.numberOfLines = 0
        lb.textAlignment = .justified
        config.customSubtitleLabel?(lb)
        lb.text = text
        contentStack.addArrangedSubview(lb)
        if #available(iOS 11.0, *) {
            let count = contentStack.arrangedSubviews.count
            if count > 0 {
                contentStack.setCustomSpacing(config.margin * 1.5, after: contentStack.arrangedSubviews[count-1])
            }
            if count > 1 {
                contentStack.setCustomSpacing(config.margin * 2, after: contentStack.arrangedSubviews[count-2])
            }
        } else {
            // Fallback on earlier versions
        }
        return lb
    }
    
    /// 增加一段正文
    /// - Parameter text: 文本
    @discardableResult func add(message text: String?) -> UILabel {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 16)
        lb.textColor = config.primaryLabelColor
        lb.numberOfLines = 0
        lb.textAlignment = .justified
        config.customTitleLabel?(lb)
        lb.text = text
        contentStack.addArrangedSubview(lb)
        return lb
    }
    
    /// 增加一个按钮
    /// - Parameters:
    ///   - title: 标题
    ///   - style: 样式
    ///   - identifier: 唯一标识符
    ///   - handler: 点击事件
    /// - Returns: 按钮实例
    @discardableResult func add(action title: String, style: Action.Style = .tinted, identifier: String? = nil, handler: ((_ sheet: Sheet) -> Void)? = nil) -> Button {
        if let handler = handler {
            let action = Action(identifier: identifier, style: style, title: title) { vc in
                if let vc = vc as? Sheet {
                    handler(vc)
                }
            }
            return add(action: action)
        } else {
            return add(action: .init(identifier: identifier, style: style, title: title, handler: nil))
        }
    }
    
    
}
