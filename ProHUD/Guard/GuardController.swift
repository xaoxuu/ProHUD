//
//  GuardController.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/31.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit
import SnapKit
import Inspire

public typealias Guard = ProHUD.Guard

public extension ProHUD {
    
    class Guard: HUDController {
        
        /// 内容视图
        public var contentView = createBlurView()
        
        /// 内容容器（包括textStack、actionStack，可以自己插入需要的控件)
        public var contentStack: StackContainer = {
            let stack = StackContainer()
            stack.spacing = cfg.guard.padding + cfg.guard.margin
            stack.alignment = .fill
            return stack
        }()
        
        /// 文本区容器
        public var textStack: StackContainer = {
            let stack = StackContainer()
            stack.spacing = cfg.guard.margin
            stack.alignment = .fill
            return stack
        }()
        
        /// 操作区容器
        public var actionStack: StackContainer = {
            let stack = StackContainer()
            stack.alignment = .fill
            stack.spacing = cfg.guard.margin
            return stack
        }()
        
        /// 是否是强制性的（点击空白处是否可以消失）
        public var isForce = false
        
        /// 是否是全屏的（仅手机竖屏有效）
        public var isFullScreen = false
        
        /// 是否正在显示
        private var isDisplaying = false
        
        /// 背景颜色
        public var backgroundColor: UIColor? = UIColor(white: 0, alpha: 0.4)
        
        public var vm = ViewModel()
        
        // MARK: 生命周期
        private var isLoadFinished = false
        
        /// 实例化
        /// - Parameter title: 标题
        /// - Parameter message: 内容
        /// - Parameter actions: 更多操作
        public convenience init(title: String? = nil, message: String? = nil, actions: ((Guard) -> Void)? = nil) {
            self.init()
            vm.vc = self
            if let _ = title {
                add(title: title)
            }
            if let _ = message {
                add(message: message)
            }
            actions?(self)
            
            // 点击空白处
            let tap = UITapGestureRecognizer(target: self, action: #selector(privDidTapped(_:)))
            view.addGestureRecognizer(tap)
            
        }
        
        
        public override func viewDidLoad() {
            super.viewDidLoad()
            view.tintColor = cfg.guard.tintColor
            cfg.guard.reloadData(self)
            isLoadFinished = true
        }
        
    }
    
}

// MARK: - 实例函数
public extension Guard {
    
    /// 推入某个视图控制器
    /// - Parameter viewController: 视图控制器
    @discardableResult func push(to viewController: UIViewController? = nil) -> Guard {
        func f(_ vc: UIViewController) {
            view.layoutIfNeeded()
            vc.addChild(self)
            vc.view.addSubview(view)
            view.isUserInteractionEnabled = true
            view.snp.makeConstraints { (mk) in
                mk.edges.equalToSuperview()
            }
            if isDisplaying == false {
                privTranslateOut()
            }
            isDisplaying = true
            UIView.animateForGuard {
                self.privTranslateIn()
            }
        }
        if let vc = viewController ?? cfg.rootViewController {
            f(vc)
        } else {
            debug("请传入需要push到的控制器")
        }
        return self
    }
    
    /// 从父视图控制器弹出
    func pop() {
        if isDisplaying {
            debug("pop")
            willDisappearCallback?()
            isDisplaying = false
            view.isUserInteractionEnabled = false
            self.removeFromParent()
            UIView.animateForGuard(animations: {
                self.privTranslateOut()
            }) { (done) in
                if self.isDisplaying == false {
                    self.view.removeFromSuperview()
                }
            }
        }
    }
    
    /// 更新
    /// - Parameter callback: 回调
    func update(_ callback: ((inout ViewModel) -> Void)? = nil) {
        callback?(&vm)
        cfg.guard.reloadData(self)
    }
    
    
}

// MARK: - 实例管理器
public extension Guard {
    
    /// 推入屏幕
    /// - Parameter alert: 场景
    /// - Parameter title: 标题
    /// - Parameter message: 正文
    /// - Parameter icon: 图标
    @discardableResult class func push(to viewController: UIViewController? = nil, _ actions: ((Guard) -> Void)? = nil) -> Guard {
        return Guard(actions: actions).push(to: viewController)
    }
    
    /// 查找指定的实例
    /// - Parameter identifier: 指定实例的标识
    class func find(_ identifier: String?, from viewController: UIViewController? = nil) -> [Guard] {
        var gg = [Guard]()
        if let vc = viewController ?? cfg.rootViewController {
            for child in vc.children {
                if child.isKind(of: Guard.self) {
                    if let g = child as? Guard {
                        if let id = identifier {
                            if g.identifier == id {
                                gg.append(g)
                            }
                        } else {
                            gg.append(g)
                        }
                    }
                }
            }
        }
        return gg
    }
    
    /// 查找指定的实例
    /// - Parameter identifier: 标识
    /// - Parameter last: 已经存在（获取最后一个）
    /// - Parameter none: 不存在
    class func find(_ identifier: String?, from viewController: UIViewController? = nil, last: ((Guard) -> Void)? = nil, none: (() -> Void)? = nil) {
        if let t = find(identifier, from: viewController).last {
            last?(t)
        } else {
            none?()
        }
    }
    
    
    /// 弹出屏幕
    /// - Parameter alert: 实例
    class func pop(_ guard: Guard) {
        `guard`.pop()
    }
    
    /// 弹出所有实例
    /// - Parameter identifier: 指定实例的标识
    class func pop(_ identifier: String?, from viewController: UIViewController?) {
        for g in find(identifier, from: viewController) {
            g.pop()
        }
    }
    
}



// MARK: - 创建和设置
internal extension Guard {
    
    /// 加载一个标题
    /// - Parameter text: 文本
    @discardableResult func add(title: String?) -> UILabel {
        let lb = UILabel()
        lb.font = cfg.guard.titleFont
        lb.textColor = cfg.primaryLabelColor
        lb.numberOfLines = 0
        lb.textAlignment = .center
        lb.text = title
        textStack.addArrangedSubview(lb)
        if #available(iOS 11.0, *) {
            let count = textStack.arrangedSubviews.count
            if count > 1 {
                textStack.setCustomSpacing(cfg.guard.margin * 2, after: textStack.arrangedSubviews[count-2])
            }
        } else {
            // Fallback on earlier versions
        }
        cfg.guard.reloadStack(self)
        return lb
    }
    
    /// 加载一个副标题
    /// - Parameter text: 文本
    @discardableResult func add(subTitle: String?) -> UILabel {
        let lb = add(title: subTitle)
        lb.font = cfg.guard.subTitleFont
        lb.textAlignment = .justified
        return lb
    }
    
    /// 加载一段正文
    /// - Parameter text: 文本
    @discardableResult func add(message: String?) -> UILabel {
        let lb = UILabel()
        lb.font = cfg.guard.bodyFont
        lb.textColor = cfg.secondaryLabelColor
        lb.numberOfLines = 0
        lb.textAlignment = .justified
        lb.text = message
        textStack.addArrangedSubview(lb)
        cfg.guard.reloadStack(self)
        return lb
    }
    
    /// 插入一个按钮
    /// - Parameter index: 索引
    /// - Parameter style: 样式
    /// - Parameter title: 标题
    /// - Parameter action: 事件
    @discardableResult func insert(action index: Int?, style: UIAlertAction.Style, title: String?, handler: (() -> Void)?) -> UIButton {
        let btn = Button.actionButton(title: title)
        btn.titleLabel?.font = cfg.guard.buttonFont
        if let idx = index, idx < actionStack.arrangedSubviews.count {
            actionStack.insertArrangedSubview(btn, at: idx)
        } else {
            actionStack.addArrangedSubview(btn)
        }
        btn.update(style: style)
        cfg.guard.reloadStack(self)
        addTouchUpAction(for: btn) { [weak self] in
            handler?()
            if btn.tag == UIAlertAction.Style.cancel.rawValue {
                self?.pop()
            }
        }
        if isLoadFinished {
            UIView.animateForGuard {
                self.view.layoutIfNeeded()
            }
        }
        return btn
    }
    
    /// 更新按钮
    /// - Parameter index: 索引
    /// - Parameter style: 样式
    /// - Parameter title: 标题
    /// - Parameter handler: 事件
    func update(action index: Int, style: UIAlertAction.Style, title: String?, handler: (() -> Void)?) {
        if index < self.actionStack.arrangedSubviews.count, let btn = self.actionStack.arrangedSubviews[index] as? UIButton {
            btn.setTitle(title, for: .normal)
            if let b = btn as? Button {
                b.update(style: style)
            }
            if let _ = buttonEvents[btn] {
                buttonEvents.removeValue(forKey: btn)
            }
            addTouchUpAction(for: btn) { [weak self] in
                handler?()
                if btn.tag == UIAlertAction.Style.cancel.rawValue {
                    self?.pop()
                }
            }
        }
    }
    
    /// 移除按钮
    /// - Parameter index: 索引
    @discardableResult func remove(index: Int) -> Guard {
        if index < 0 {
            for view in self.actionStack.arrangedSubviews {
                if let btn = view as? UIButton {
                    btn.removeFromSuperview()
                    if let _ = buttonEvents[btn] {
                        buttonEvents.removeValue(forKey: btn)
                    }
                }
            }
        } else if index < self.actionStack.arrangedSubviews.count, let btn = self.actionStack.arrangedSubviews[index] as? UIButton {
            btn.removeFromSuperview()
            if let _ = buttonEvents[btn] {
                buttonEvents.removeValue(forKey: btn)
            }
        }
        cfg.guard.reloadStack(self)
        UIView.animateForAlert {
            self.view.layoutIfNeeded()
        }
        return self
    }
    
}

fileprivate extension Guard {
    
    /// 点击事件
    /// - Parameter sender: 手势
    @objc func privDidTapped(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: contentView)
        if point.x < 0 || point.y < 0 {
            if isForce == false {
                // 点击到操作区域外部
                pop()
            }
        }
        
    }
    
    func privTranslateIn() {
        view.backgroundColor = backgroundColor
        contentView.transform = .identity
    }
    
    func privTranslateOut() {
        view.backgroundColor = UIColor(white: 0, alpha: 0)
        contentView.transform = .init(translationX: 0, y: view.frame.size.height - contentView.frame.minY + cfg.guard.margin)
    }
    
}
