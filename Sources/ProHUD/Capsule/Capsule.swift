//
//  Capsule.swift
//
//
//  Created by xaoxuu on 2022/9/8.
//

import UIKit

open class Capsule: Controller {
    
    public lazy var config: Configuration = {
        var cfg = Configuration()
        Configuration.customShared?(cfg)
        return cfg
    }()
    
    /// 内容容器（imageView、textLabel)
    public lazy var contentStack: StackView = {
        let stack = StackView()
        stack.spacing = 8
        stack.distribution = .equalCentering
        stack.alignment = .fill
        stack.axis = .horizontal
        config.customContentStack?(stack)
        return stack
    }()
    
    /// 图标
    public lazy var imageView: UIImageView = {
        let imgv = UIImageView()
        imgv.contentMode = .scaleAspectFit
        return imgv
    }()
    
    /// 文本
    public lazy var textLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = config.primaryLabelColor
        lb.font = .boldSystemFont(ofSize: 15)
        lb.textAlignment = .justified
        lb.numberOfLines = 2
        config.customTextLabel?(lb)
        return lb
    }()
    
    open class CapsuleViewModel: ViewModel {
        
        public enum Position {
            case top
            case middle
            case bottom
        }
        public var position: Position = .top
        
        public static var top: Self {
            let obj = Self.init()
            obj.position = .top
            return obj
        }
        public static var middle: Self {
            let obj = Self.init()
            obj.position = .middle
            return obj
        }
        public static var bottom: Self {
            let obj = Self.init()
            obj.position = .bottom
            return obj
        }
        
    }
    
    /// 视图模型
    public var vm = CapsuleViewModel()
    
    private var tapActionCallback: ((_ capsule: Capsule) -> Void)?
    
    @discardableResult public init(_ vm: CapsuleViewModel, handler: ((_ capsule: Capsule) -> Void)? = nil) {
        super.init()
        self.vm = vm
        handler?(self)
        DispatchQueue.main.async {
            if handler != nil {
                self.push()
            }
        }
    }
    
    @discardableResult public convenience init(handler: ((_ capsule: Capsule) -> Void)?) {
        self.init(.init(), handler: handler)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.tintColor = config.tintColor
        view.layer.shadowRadius = 8
        view.layer.shadowOffset = .init(width: 0, height: 5)
        view.layer.shadowOpacity = 0.1
        
        // 点击
        let tap = UITapGestureRecognizer(target: self, action: #selector(_onTappedGesture(_:)))
        view.addGestureRecognizer(tap)
        
        reloadData(animated: false)
        
        navEvents[.onViewDidLoad]?(self)
        
    }
    
    public func onTapped(action: @escaping (_ capsule: Capsule) -> Void) {
        self.tapActionCallback = action
    }
    
}

fileprivate extension Capsule {
    
    /// 点击事件
    /// - Parameter sender: 手势
    @objc func _onTappedGesture(_ sender: UITapGestureRecognizer) {
        tapActionCallback?(self)
    }
    
}
