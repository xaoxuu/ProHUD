//
//  Sheet.swift
//  
//
//  Created by xaoxuu on 2022/9/8.
//

import UIKit

public class Sheet: Controller {
    
    weak var window: SheetWindow?
    
    public lazy var config: Configuration = {
        var cfg = Configuration()
        Configuration.customShared?(cfg)
        return cfg
    }()
    
    public lazy var backgroundView: UIView = {
        let v = UIView()
        v.backgroundColor = .init(white: 0, alpha: 0.5)
        v.alpha = 0
        return v
    }()
    
    /// 内容容器（包括icon、textStack、actionStack)
    public lazy var contentStack: StackView = {
        let stack = StackView()
        stack.spacing = config.margin
        stack.alignment = .fill
        return stack
    }()
    
    private var onTappedBackground: ((_ sheet: Sheet) -> Void)?
    
    public override var title: String? {
        didSet {
            add(title: title)
        }
    }
    
    @discardableResult public init(callback: @escaping (_ sheet: Sheet) -> Void, onTappedBackground action: ((_ sheet: Sheet) -> Void)? = nil) {
        super.init()
        
        onTappedBackground = action
        callback(self)
        
        DispatchQueue.main.async {
            SheetWindow.push(sheet: self)
        }
        
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.tintColor = config.tintColor
        
        // 点击
        let tap = UITapGestureRecognizer(target: self, action: #selector(_onTappedBackground(_:)))
        backgroundView.addGestureRecognizer(tap)
        
        reloadData()
        
        _translateOut()
        
    }
    
}

extension Sheet {
    func translateIn(completion: (() -> Void)?) {
        UIView.animateEaseOut(duration: config.animateDurationForBuildInByDefault) {
            self._translateIn()
        } completion: { done in
            completion?()
        }
    }
    func translateOut(completion: (() -> Void)?) {
        UIView.animateEaseOut(duration: config.animateDurationForBuildOutByDefault) {
            self._translateOut()
        } completion: { done in
            completion?()
        }
    }
    
    func _translateIn() {
        backgroundView.alpha = 1
        contentView.transform = .identity
    }
    func _translateOut() {
        backgroundView.alpha = 0
        contentView.transform = .init(translationX: 0, y: view.frame.size.height - contentView.frame.minY + config.margin)
    }
    @objc func _onTappedBackground(_ sender: UITapGestureRecognizer) {
        if let act = onTappedBackground {
            act(self)
        } else {
            SheetWindow.pop(sheet: self)
        }
    }
}
