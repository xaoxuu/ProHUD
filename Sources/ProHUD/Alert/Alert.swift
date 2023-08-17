//
//  Alert.swift
//  
//
//  Created by xaoxuu on 2022/8/29.
//

import UIKit

open class Alert: ProHUD.Controller {
    
    public lazy var config: Configuration = {
        var cfg = Configuration()
        Configuration.customShared?(cfg)
        return cfg
    }()
    
    public var progressView: ProgressView?
    
    /// 内容容器（包括icon、textStack、actionStack)
    public lazy var contentStack: StackView = {
        let stack = StackView(axis: .vertical)
        stack.spacing = 24
        stack.alignment = .center
        config.customContentStack?(stack)
        return stack
    }()
    
    /// 文本区容器
    public lazy var textStack: StackView = {
        let stack = StackView(axis: .vertical)
        stack.spacing = 8
        stack.alignment = .center
        config.customTextStack?(stack)
        return stack
    }()
    
    /// 图标
    public lazy var imageView: UIImageView = {
        let imgv = UIImageView()
        imgv.contentMode = .scaleAspectFit
        imgv.tintColor = view.tintColor
        return imgv
    }()
    
    /// 标题
    public lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = config.primaryLabelColor
        lb.font = .boldSystemFont(ofSize: 20)
        lb.textAlignment = .left
        lb.numberOfLines = 5
        return lb
    }()
    
    /// 正文
    public lazy var bodyLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = config.primaryLabelColor
        lb.font = .systemFont(ofSize: 17)
        lb.textAlignment = .left
        lb.numberOfLines = 20
        return lb
    }()
    
    /// 操作区域
    public lazy var actionStack: StackView = {
        let stack = StackView()
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 8
        config.customActionStack?(stack)
        return stack
    }()
    
    open class ViewModel: BaseViewModel {}
    
    /// 视图模型
    public var vm = ViewModel()
    
    public override var title: String? {
        didSet {
            vm.title = title
        }
    }
    
    @discardableResult public init(_ vm: ViewModel, handler: ((_ alert: Alert) -> Void)? = nil) {
        super.init()
        self.vm = vm
        handler?(self)
        DispatchQueue.main.async {
            if handler != nil {
                self.setDefaultAxis()
                self.push()
            }
        }
    }
    
    @discardableResult public convenience init(handler: ((_ alert: Alert) -> Void)?) {
        self.init(.init(), handler: handler)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.tintColor = config.tintColor
        reloadData(animated: false)
        navEvents[.onViewDidLoad]?(self)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

// MARK: 动画扩展
extension Alert: LoadingAnimation {}
