//
//  GuardController.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/31.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import SnapKit

public typealias Guard = ProHUD.Guard

public extension ProHUD {
    
    class Guard: HUDController {
        
        /// 内容视图
        public var contentView = BlurView()
        
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
        public var force = false
        
        /// 是否正在显示
        private var displaying = false
        
        /// 背景颜色
        public var backgroundColor: UIColor? = UIColor(white: 0, alpha: 0.5)
        
        // MARK: 生命周期
        
        /// 实例化
        /// - Parameter title: 标题
        /// - Parameter message: 内容
        /// - Parameter actions: 更多操作
        public convenience init(title: String? = nil, message: String? = nil, actions: ((Guard) -> Void)? = nil) {
            self.init()
            
            view.tintColor = cfg.guard.tintColor
            if let _ = title {
                add(title: title)
            }
            if let _ = message {
                add(message: message)
            }
            actions?(self)
            cfg.guard.loadSubviews(self)
            cfg.guard.reloadData(self)
            cfg.guard.reloadStack(self)
            
            // 点击空白处
            let tap = UITapGestureRecognizer(target: self, action: #selector(privDidTapped(_:)))
            view.addGestureRecognizer(tap)
            
            
        }
        
        
    }
    
}

// MARK: - 实例函数

public extension Guard {
    
    // MARK: 生命周期函数
    
    /// 推入某个视图控制器
    /// - Parameter viewController: 视图控制器
    func push(to viewController: UIViewController? = nil) -> Guard {
        func f(_ vc: UIViewController) {
            view.layoutIfNeeded()
            vc.addChild(self)
            vc.view.addSubview(view)
            view.isUserInteractionEnabled = true
            view.snp.makeConstraints { (mk) in
                mk.edges.equalToSuperview()
            }
            if displaying == false {
                translateOut()
            }
            displaying = true
            UIView.animateForGuard {
                self.translateIn()
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
        if displaying {
            debug("pop")
            willDisappearCallback?()
            displaying = false
            view.isUserInteractionEnabled = false
            self.removeFromParent()
            UIView.animateForGuard(animations: {
                self.translateOut()
            }) { (done) in
                if self.displaying == false {
                    self.view.removeFromSuperview()
                }
            }
        }
    }
    
    // MARK: 设置函数
    
    /// 加载一个标题
    /// - Parameter text: 文本
    @discardableResult func add(title: String?) -> UILabel {
        let lb = UILabel()
        lb.font = cfg.guard.titleFont
        lb.textColor = cfg.primaryLabelColor
        lb.numberOfLines = 0
        lb.textAlignment = .justified
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
    
    /// 加载一个按钮
    /// - Parameter style: 样式
    /// - Parameter title: 标题
    /// - Parameter action: 事件
    @discardableResult func add(action style: UIAlertAction.Style, title: String?, handler: (() -> Void)?) -> UIButton {
        let btn = Button.actionButton(title: title)
        btn.titleLabel?.font = cfg.guard.buttonFont
        actionStack.addArrangedSubview(btn)
        cfg.guard.reloadStack(self)
        btn.update(style: style)
        addTouchUpAction(for: btn) { [weak self] in
            handler?()
            if btn.tag == UIAlertAction.Style.cancel.rawValue {
                self?.pop()
            }
        }
        return btn
    }
    
    /// 移除按钮
    /// - Parameter index: 索引
    @discardableResult func remove(action index: Int...) -> Guard {
        for (i, idx) in index.enumerated() {
            privRemoveAction(index: idx-i)
        }
        return self
    }
    
    /// 消失事件
    /// - Parameter callback: 事件回调
    @discardableResult func willDisappear(_ callback: (() -> Void)?) -> Guard {
        willDisappearCallback = callback
        return self
    }
    /// 消失事件
    /// - Parameter callback: 事件回调
    @discardableResult func didDisappear(_ callback: (() -> Void)?) -> Guard {
        disappearCallback = callback
        return self
    }
    
}


// MARK: 类函数

public extension Guard {
    
    /// 推入屏幕
    /// - Parameter alert: 场景
    /// - Parameter title: 标题
    /// - Parameter message: 正文
    /// - Parameter icon: 图标
    @discardableResult class func push(to viewController: UIViewController? = nil, actions: ((Guard) -> Void)? = nil) -> Guard {
        return Guard(actions: actions).push(to: viewController)
    }
    
    /// 获取指定的实例
    /// - Parameter identifier: 指定实例的标识
    class func guards(_ identifier: String? = nil, from viewController: UIViewController? = nil) -> [Guard] {
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
    
    /// 弹出屏幕
    /// - Parameter alert: 实例
    class func pop(_ guard: Guard) {
        `guard`.pop()
    }
    
    /// 弹出屏幕
    /// - Parameter identifier: 指定实例的标识
    class func pop(from viewController: UIViewController?) {
        for g in guards(from: viewController) {
            g.pop()
        }
    }
    
}



// MARK: - 私有

fileprivate extension Guard {
    
    /// 点击事件
    /// - Parameter sender: 手势
    @objc func privDidTapped(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: contentView)
        if point.x < 0 || point.y < 0 {
            if force == false {
                // 点击到操作区域外部
                pop()
            }
        }
        
    }
    
    func translateIn() {
        view.backgroundColor = backgroundColor
        contentView.transform = .identity
    }
    
    func translateOut() {
        view.backgroundColor = UIColor(white: 0, alpha: 0)
        contentView.transform = .init(translationX: 0, y: view.frame.size.height - contentView.frame.minY + cfg.guard.margin)
    }
    
    /// 移除按钮
    /// - Parameter index: 索引
    @discardableResult func privRemoveAction(index: Int) -> Guard {
        if index < 0 {
            for view in self.actionStack.arrangedSubviews {
                if let btn = view as? UIButton {
                    btn.removeFromSuperview()
                }
            }
        } else if index < self.actionStack.arrangedSubviews.count, let btn = self.actionStack.arrangedSubviews[index] as? UIButton {
            btn.removeFromSuperview()
        }
        cfg.guard.reloadStack(self)
        UIView.animateForAlert {
            self.view.layoutIfNeeded()
        }
        return self
    }
    
    
    
}

