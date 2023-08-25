//
//  Alert.swift
//  
//
//  Created by xaoxuu on 2022/8/29.
//

import UIKit

open class AlertTarget: BaseController, HUDTargetType {
    
    public typealias ViewModel = AlertViewModel
    
    public lazy var config = AlertConfiguration()
    
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
    
    /// 视图模型
    @objc public var vm: AlertViewModel? {
        didSet {
            vm?.vc = self
        }
    }
    
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
        fatalError("init(coder:) has not been implemented")
    }
    
    public convenience init(_ vm: ViewModel) {
        self.init()
        self.vm = vm
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        reloadData(animated: false)
        navEvents[.onViewDidLoad]?(self)
    }
    
    
}

// MARK: 动画扩展
extension AlertTarget: LoadingAnimation {}
