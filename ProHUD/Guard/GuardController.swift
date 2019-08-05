//
//  GuardController.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/31.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import SnapKit

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
        
        private let tag = Int(23905340)
        
        private var displaying = false
        
        // MARK: 生命周期
        
        /// 实例化
        /// - Parameter scene: 场景
        /// - Parameter title: 标题
        /// - Parameter message: 内容
        /// - Parameter icon: 图标
        public convenience init(title: String? = nil, message: String? = nil) {
            self.init()
            
            view.tintColor = cfg.guard.tintColor
            if let _ = title {
                add(title: title)
            }
            if let _ = message {
                add(message: message)
            }
            cfg.guard.loadSubviews(self)
            cfg.guard.reloadData(self)
            
            // 点击
            let tap = UITapGestureRecognizer(target: self, action: #selector(privDidTapped(_:)))
            view.addGestureRecognizer(tap)
            
            
        }
        
        
    }
}

// MARK: - 实例函数

public extension ProHUD.Guard {
    
    // MARK: 生命周期函数
    
    /// 推入某个视图控制器
    /// - Parameter viewController: 视图控制器
    func push(to viewController: UIViewController? = nil) {
        if let vc = viewController {
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
        
    }
    
    /// 从父视图控制器弹出
    func pop() {
        if displaying {
            debug("pop")
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
        return lb
    }
    
    /// 加载一个按钮
    /// - Parameter style: 样式
    /// - Parameter title: 标题
    /// - Parameter action: 事件
    @discardableResult func add(action style: UIAlertAction.Style, title: String?, action: (() -> Void)? = nil) -> UIButton {
        let btn = Button.actionButton(title: title)
        btn.titleLabel?.font = cfg.guard.buttonFont
        if actionStack.superview == nil {
            contentStack.addArrangedSubview(actionStack)
        }
        actionStack.addArrangedSubview(btn)
        btn.update(style: style)
        addTouchUpAction(for: btn) { [weak self] in
            action?()
            if btn.tag == UIAlertAction.Style.cancel.rawValue {
                self?.pop()
            }
        }
        return btn
    }
    
    
    /// 消失事件
    /// - Parameter callback: 事件回调
    @discardableResult func didDisappear(_ callback: (() -> Void)?) -> ProHUD.Guard {
        disappearCallback = callback
        return self
    }
    
}

fileprivate extension ProHUD.Guard {
    
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
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        contentView.transform = .identity
    }
    
    func translateOut() {
        view.backgroundColor = UIColor(white: 0, alpha: 0)
        contentView.transform = .init(translationX: 0, y: view.frame.size.height - contentView.frame.minY + cfg.guard.margin)
    }
    
    
    
}

