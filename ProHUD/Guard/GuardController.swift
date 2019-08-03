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
        
        /// 内容容器
        public var contentView = BlurView()
        
        /// 内容容器（包括textStack、actionStack)
        public var contentStack: StackContainer = {
            let stack = StackContainer()
            stack.spacing = guardConfig.padding + guardConfig.margin
            stack.alignment = .fill
            return stack
        }()
        
        /// 文本区域
        public var textStack: StackContainer = {
            let stack = StackContainer()
            stack.spacing = guardConfig.margin
            stack.alignment = .fill
            return stack
        }()
        
        public var titleLabel: UILabel?
        public var bodyLabel: UILabel?
        
        /// 操作区域
        public var actionStack: StackContainer = {
            let stack = StackContainer()
            stack.alignment = .fill
            stack.spacing = guardConfig.margin
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
            view = View()
            view.tintColor = guardConfig.tintColor
            if let _ = title {
                loadTitle(title)
            }
            if let _ = message {
                loadBody(message)
            }
            guardConfig.loadSubviews(self, guardConfig)
//            willLayoutSubviews()
            
            // 点击
            let tap = UITapGestureRecognizer(target: self, action: #selector(privDidTapped(_:)))
            view.addGestureRecognizer(tap)
            
            
        }
        
        
        public override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            
        }
        
        deinit {
            debugPrint(self, "deinit")
        }
        
        public func push(to viewController: UIViewController? = nil) {
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
        
        public func pop() {
            if displaying {
                debugPrint("pop")
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
    }
}

public extension ProHUD.Guard {
    
    @discardableResult
    func loadTitle(_ text: String?) -> UILabel {
        guardConfig.loadTitleLabel(self, guardConfig)
        let lb = titleLabel!
        lb.text = text
        if textStack.arrangedSubviews.count > 0 {
            textStack.insertArrangedSubview(lb, at: 0)
        } else {
            textStack.addArrangedSubview(lb)
        }
        return lb
    }
    
    @discardableResult
    func loadBody(_ text: String?) -> UILabel {
        guardConfig.loadBodyLabel(self, guardConfig)
        let lb = bodyLabel!
        lb.text = text
        textStack.addArrangedSubview(lb)
        return lb
    }
    
    @discardableResult
    func loadButton(style: UIAlertAction.Style, title: String?, action: (() -> Void)? = nil) -> UIButton {
        let btn = Button.actionButton(title: title)
        btn.titleLabel?.font = guardConfig.buttonFont
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
        contentView.transform = .init(translationX: 0, y: view.frame.size.height - contentView.frame.minY + guardConfig.margin)
    }
    
    
    
}

