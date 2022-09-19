//
//  Alert.swift
//  
//
//  Created by xaoxuu on 2022/8/29.
//

import UIKit

public class Alert: ProHUD.Controller {
    
    public lazy var config: Configuration = {
        var cfg = Configuration()
        Configuration.customShared?(cfg)
        return cfg
    }()
    
    public var progressView: ProgressView?
    
    /// 内容容器（包括icon、textStack、actionStack)
    public lazy var contentStack: StackView = {
        let stack = StackView(axis: .vertical)
        stack.spacing = config.margin
        stack.alignment = .center
        return stack
    }()
    
    /// 文本区容器
    public lazy var textStack: StackView = {
        let stack = StackView(axis: .vertical)
        stack.spacing = config.margin
        stack.alignment = .center
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
        lb.font = config.titleFontByDefault
        lb.textAlignment = .justified
        lb.numberOfLines = config.titleMaxLines
        return lb
    }()
    
    /// 正文
    public lazy var bodyLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = config.primaryLabelColor
        lb.font = config.bodyFontByDefault
        lb.textAlignment = .justified
        lb.numberOfLines = config.bodyMaxLines
        return lb
    }()
    
    /// 操作区域
    public lazy var actionStack: StackView = {
        let stack = StackView()
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = config.margin
        return stack
    }()
    
    /// 视图模型
    public var vm = ViewModel()
    
    public override var title: String? {
        didSet {
            vm.title = title
        }
    }
    
    @discardableResult public init(_ vm: ViewModel?, handler: ((_ alert: Alert) -> Void)? = nil) {
        super.init()
        if let vm = vm {
            self.vm = vm
        }
        handler?(self)
        DispatchQueue.main.async {
            if handler != nil {
                self.setDefaultAxis()
                self.push()
            }
        }
    }
    
    @discardableResult public convenience init(handler: ((_ alert: Alert) -> Void)?) {
        self.init(nil, handler: handler)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.tintColor = config.tintColor
        reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

// MARK: 动画扩展
extension Alert: LoadingAnimation {}
