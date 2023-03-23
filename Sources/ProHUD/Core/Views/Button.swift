//
//  Button.swift
//  
//
//  Created by xaoxuu on 2022/8/29.
//

import UIKit

/// 弹窗的按钮

open class Button: UIButton {
    
    public internal(set) var action: Action?
    
    var edgeInset: CGFloat { 8 * 1.5 }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        let padding = edgeInset
        contentEdgeInsets = .init(top: padding, left: padding * 2, bottom: padding, right: padding * 2)
        addTarget(self, action: #selector(self._onTouchUp(_:)), for: [.touchUpInside, .touchUpOutside])
        addTarget(self, action: #selector(self._onTouchDown(_:)), for: .touchDown)
        addTarget(self, action: #selector(self._onTouchUpInside(_:)), for: .touchUpInside)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public convenience init(config: ProHUD.Configuration, action: Action) {
        self.init(frame: .zero)
        self.update(config: config, action: action)
    }
    
    /// 更新按钮
    /// - Parameter style: 样式
    open func update(config: ProHUD.Configuration, action: Action) {
        titleLabel?.font = config.buttonFontByDefault
        layer.cornerRadiusWithContinuous = config.buttonCornerRadiusByDefault
        self.action = action
        setTitle(action.title, for: .normal)
        switch action.style {
        case .tinted:
            setTitleColor(config.dynamicBackgroundColor, for: .normal)
            backgroundColor = config.tintColor ?? tintColor ?? .systemBlue
        case .destructive:
            setTitleColor(config.dynamicBackgroundColor, for: .normal)
            backgroundColor = .systemRed
        case .gray:
            setTitleColor(config.secondaryLabelColor, for: .normal)
            backgroundColor = config.secondaryLabelColor.withAlphaComponent(0.08)
        case .filled(let color):
            setTitleColor(config.dynamicBackgroundColor, for: .normal)
            backgroundColor = color
        case .light(let color):
            setTitleColor(color, for: .normal)
            backgroundColor = color.withAlphaComponent(0.15)
        case .plain(let textColor):
            setTitleColor(textColor, for: .normal)
            backgroundColor = .none
            contentEdgeInsets.top = 0
            contentEdgeInsets.bottom = 4
        }
    }
    
    var onTouchDown: ((_ action: Button) -> Void)?
    public func onTouchDown(handler: @escaping (_ action: Button) -> Void) {
        onTouchDown = handler
    }
    
    var onTouchUp: ((_ action: Button) -> Void)?
    public func onTouchUp(handler: @escaping (_ action: Button) -> Void) {
        onTouchUp = handler
    }
    
    var onTouchUpInside: ((_ action: Button) -> Void)?
    public func onTouchUpInside(handler: @escaping (_ action: Button) -> Void) {
        onTouchUpInside = handler
    }
    
}

extension Button {
    @objc func _onTouchDown(_ sender: Button) {
        onTouchDown?(sender)
    }
    @objc func _onTouchUp(_ sender: Button) {
        onTouchUp?(sender)
    }
    @objc func _onTouchUpInside(_ sender: Button) {
        onTouchUpInside?(sender)
    }
    open override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.1, delay: 0, options: .allowUserInteraction) {
                if self.isEnabled {
                    self.alpha = self.isHighlighted ? 0.6 : 1
                }
            } completion: { done in
                
            }
        }
    }
    open override var isEnabled: Bool {
        didSet {
            UIView.animate(withDuration: 0.1, delay: 0, options: .allowUserInteraction) {
                self.alpha = self.isEnabled ? 1 : 0.2
            } completion: { done in
                
            }
        }
    }
}
