//
//  Toast.swift
//  
//
//  Created by xaoxuu on 2022/9/3.
//

import UIKit

open class ToastTarget: BaseController, HUDTargetType {
    
    public typealias ViewModel = ToastViewModel
    
    weak var window: ToastWindow?
    
    public lazy var config = ToastConfiguration()
    
    public var progressView: ProgressView?
    
    /// 内容容器（包括infoStack、actionStack)
    public lazy var contentStack: StackView = {
        let stack = StackView(axis: .vertical)
        stack.spacing = 16
        config.customContentStack?(stack)
        return stack
    }()
    
    /// 信息容器（imageView+textStack）
    public lazy var infoStack: StackView = {
        let stack = StackView(axis: .horizontal)
        stack.spacing = 8
        stack.alignment = .top
        config.customInfoStack?(stack)
        return stack
    }()
    
    /// 文本容器（title、body）
    public lazy var textStack: StackView = {
        let stack = StackView(axis: .vertical)
        stack.spacing = config.lineSpace
        stack.distribution = .equalSpacing
        config.customTextStack?(stack)
        return stack
    }()
    
    /// 按钮容器
    public lazy var actionStack: StackView = {
        let stack = StackView(axis: .horizontal)
        stack.spacing = 8
        config.customActionStack?(stack)
        return stack
    }()
    
    /// 图标
    public lazy var imageView: UIImageView = {
        let imgv = UIImageView()
        imgv.contentMode = .scaleAspectFit
        return imgv
    }()
    
    /// 标题
    public lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = config.primaryLabelColor
        lb.font = .boldSystemFont(ofSize: 18)
        lb.textAlignment = .justified
        lb.numberOfLines = 5
        return lb
    }()
    
    /// 正文
    public lazy var bodyLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = config.primaryLabelColor
        lb.font = .systemFont(ofSize: 16)
        lb.textAlignment = .justified
        lb.numberOfLines = 20
        return lb
    }()
    
    /// 是否可以通过手势移除（向上滑出屏幕）
    public var isRemovable = true
    
    /// 视图模型
    @objc public var vm: ToastViewModel? {
        willSet {
            vm?.cancelTimer()
        }
        didSet {
            vm?.vc = self
            vm?.restartTimer()
        }
    }
    
    private var tapActionCallback: ((_ toast: ToastTarget) -> Void)?
    
    public override var title: String? {
        didSet {
            if let vm = vm {
                vm.title = title
                titleLabel.text = title
            } else {
                vm = .title(title)
            }
        }
    }
    
    required public override init() {
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public convenience init(_ vm: ViewModel) {
        self.init()
        self.vm = vm
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // 点击
        let tap = UITapGestureRecognizer(target: self, action: #selector(_onTappedGesture(_:)))
        view.addGestureRecognizer(tap)
        // 拖动
        let pan = UIPanGestureRecognizer(target: self, action: #selector(_onPanGesture(_:)))
        view.addGestureRecognizer(pan)
        
        reloadData(animated: false)
        navEvents[.onViewDidLoad]?(self)
        
    }
    
    public func onTapped(action: @escaping (_ toast: ToastTarget) -> Void) {
        self.tapActionCallback = action
    }
    
}

fileprivate extension ToastTarget {
    
    /// 点击事件
    /// - Parameter sender: 手势
    @objc func _onTappedGesture(_ sender: UITapGestureRecognizer) {
        tapActionCallback?(self)
    }
    
    /// 拖拽事件
    /// - Parameter sender: 手势
    @objc func _onPanGesture(_ sender: UIPanGestureRecognizer) {
        vm?.cancelTimer()
        let point = sender.translation(in: sender.view)
        window?.transform = .init(translationX: 0, y: point.y)
        if sender.state == .recognized {
            let v = sender.velocity(in: sender.view)
            if isRemovable {
                // 可以移除
                if ((window?.frame.origin.y ?? 0) < 0 && v.y < 0) || v.y < -1200 {
                    // 达到移除的速度
                    return pop()
                }
            }
            UIView.animateEaseOut(duration: config.animateDurationForReloadByDefault) {
                self.window?.transform = .identity
            } completion: { done in
                self.vm?.restartTimer()
            }
        }
    }
    
}

extension ToastTarget: LoadingAnimation { }
