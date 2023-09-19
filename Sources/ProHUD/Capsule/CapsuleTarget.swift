//
//  Capsule.swift
//
//
//  Created by xaoxuu on 2022/9/8.
//

import UIKit

open class CapsuleTarget: BaseController, HUDTargetType {
    
    public typealias ViewModel = CapsuleViewModel
    
    @objc open lazy var config = CapsuleConfiguration()
    
    /// 内容容器（imageView、textLabel)
    public lazy var contentStack: StackView = {
        let stack = StackView(axis: .horizontal)
        stack.spacing = 8
        stack.alignment = .center
        config.customContentStack?(stack)
        return stack
    }()
    
    /// 图标
    public lazy var imageView: UIImageView = {
        let imgv = UIImageView()
        imgv.contentMode = .scaleAspectFit
        return imgv
    }()
    
    public var progressView: ProgressView?
    
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
    
    @objc public var vm: CapsuleViewModel? {
        willSet {
            vm?.cancelTimer()
        }
        didSet {
            vm?.vc = self
            vm?.restartTimer()
        }
    }
    
    public override var title: String? {
        didSet {
            if let vm = vm {
                vm.title = title
                textLabel.text = title
            } else {
                vm = .title(title)
            }
        }
    }
    
    var tapActionCallback: ((_ capsule: CapsuleTarget) -> Void)?
    
    required public override init() {
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public convenience init(_ vm: ViewModel) {
        self.init()
        self.vm = vm
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // 点击
        let tap = UITapGestureRecognizer(target: self, action: #selector(_onTappedGesture(_:)))
        view.addGestureRecognizer(tap)
        
        reloadData(animated: false)
        
        navEvents[.onViewDidLoad]?(self)
        
    }
    
    @objc public func onTapped(action: @escaping (_ capsule: CapsuleTarget) -> Void) {
        self.tapActionCallback = action
    }
    
}

fileprivate extension CapsuleTarget {
    
    /// 点击事件
    /// - Parameter sender: 手势
    @objc func _onTappedGesture(_ sender: UITapGestureRecognizer) {
        tapActionCallback?(self)
    }
    
}


extension CapsuleTarget: LoadingAnimation { }
