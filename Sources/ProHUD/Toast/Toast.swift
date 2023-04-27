//
//  Toast.swift
//  
//
//  Created by xaoxuu on 2022/9/3.
//

import UIKit

public class Toast: Controller {
    
    weak var window: ToastWindow?
    
    public lazy var config: Configuration = {
        var cfg = Configuration()
        Configuration.customShared?(cfg)
        return cfg
    }()
    
    public var progressView: ProgressView?
    
    /// 内容容器（包括icon、textStack、actionStack)
    public lazy var contentStack: StackView = {
        let stack = StackView(axis: .vertical)
        stack.spacing = 16
        config.customContentStack?(stack)
        return stack
    }()
    
    /// 信息容器（image+text）
    public lazy var infoStack: StackView = {
        let stack = StackView(axis: .horizontal)
        stack.spacing = 8
        stack.alignment = .top
        config.customInfoStack?(stack)
        return stack
    }()
    
    /// 文本容器
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
    public var vm = ViewModel()
    
    private var tapActionCallback: ((_ toast: Toast) -> Void)?
    
    
    public override var title: String? {
        didSet {
            vm.title = title
        }
    }
    
    
    @discardableResult public init(_ vm: ViewModel?, handler: ((_ toast: Toast) -> Void)? = nil) {
        super.init()
        if let vm = vm {
            self.vm = vm
        }
        handler?(self)
        DispatchQueue.main.async {
            if handler != nil {
                ToastWindow.push(toast: self)
            }
        }
    }
    
    @discardableResult public convenience init(handler: ((_ toast: Toast) -> Void)?) {
        self.init(nil, handler: handler)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.tintColor = config.tintColor
        
        // 点击
        let tap = UITapGestureRecognizer(target: self, action: #selector(_onTappedGesture(_:)))
        view.addGestureRecognizer(tap)
        // 拖动
        let pan = UIPanGestureRecognizer(target: self, action: #selector(_onPanGesture(_:)))
        view.addGestureRecognizer(pan)
        
        reloadData(animated: false)
        navEvents[.onViewDidLoad]?(self)
        
    }
    
    public func onTapped(action: @escaping (_ toast: Toast) -> Void) {
        self.tapActionCallback = action
    }
    
}

fileprivate extension Toast {
    
    /// 点击事件
    /// - Parameter sender: 手势
    @objc func _onTappedGesture(_ sender: UITapGestureRecognizer) {
        tapActionCallback?(self)
    }
    
    /// 拖拽事件
    /// - Parameter sender: 手势
    @objc func _onPanGesture(_ sender: UIPanGestureRecognizer) {
        vm.timeoutTimer?.invalidate()
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
                let d = self.vm.duration
                self.vm.duration = d
            }
        }
    }
    
}

extension Toast: LoadingAnimation { }
