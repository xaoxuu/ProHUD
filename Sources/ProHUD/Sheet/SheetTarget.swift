//
//  Sheet.swift
//  
//
//  Created by xaoxuu on 2022/9/8.
//

import UIKit

open class SheetTarget: BaseController, HUDTargetType {
    
    weak var window: SheetWindow?
    
    public lazy var config: SheetConfiguration = {
        var cfg = SheetConfiguration()
        SheetConfiguration.customGlobalConfig?(cfg)
        return cfg
    }()
    
    public lazy var backgroundView: UIView = {
        let v = UIView()
        v.backgroundColor = .init(white: 0, alpha: 0.5)
        return v
    }()
    
    /// 内容容器（包括icon、textStack、actionStack)
    public lazy var contentStack: StackView = {
        let stack = StackView()
        stack.spacing = 8
        stack.alignment = .fill
        config.customContentStack?(stack)
        return stack
    }()
    
    private var tapActionCallback: ((_ sheet: SheetTarget) -> Void)?
    
    public override var title: String? {
        didSet {
            add(title: title)
        }
    }
    
    public var vm: SheetViewModel? = nil {
        didSet {
            vm?.vc = self
        }
    }
    
    required public override init() {
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // 点击
        let tap = UITapGestureRecognizer(target: self, action: #selector(_onTappedBackground(_:)))
        backgroundView.addGestureRecognizer(tap)
        
        reloadData(animated: false)
        
        navEvents[.onViewDidLoad]?(self)
        
    }
    
    public func onTappedBackground(action: @escaping (_ sheet: SheetTarget) -> Void) {
        self.tapActionCallback = action
    }
    
}

extension SheetTarget {
    @objc func _onTappedBackground(_ sender: UITapGestureRecognizer) {
        if let act = tapActionCallback {
            act(self)
        } else {
            self.pop()
        }
    }
}
