//
//  DemoToastVC.swift
//  PHDemo
//
//  Created by xaoxuu on 2022/9/3.
//

import UIKit
import ProHUD


func updateProgress(in duration: TimeInterval, callback: @escaping (_ percent: CGFloat) -> Void, completion: (() -> Void)?) {
    let s = DispatchSemaphore(value: 1)
    DispatchQueue.global().async {
        let total = 50
        for i in 0 ... total {
            s.wait()
            DispatchQueue.main.async {
                callback(CGFloat(i)/CGFloat(total))
                DispatchQueue.main.asyncAfter(deadline: .now() + (duration / TimeInterval(total))) {
                    s.signal()
                    if i == total {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            completion?()
                        }
                    }
                }
            }
        }
    }
}

let isTesting: Bool = true

class TestToastTarget: ToastTarget {
    override func push() {
        print("isTesting: \(isTesting)")
        guard isTesting else { return }
        super.push()
    }
}

class TestToast: HUDProviderType {
    
    public typealias ViewModel = ToastViewModel
    public typealias Target = TestToastTarget
    
    /// 根据自定义的初始化代码创建一个Target并显示
    /// - Parameter initializer: 初始化代码（传空值时不会做任何事）
    @discardableResult public required init(initializer: ((_ target: Target) -> Void)?) {
        guard let initializer = initializer else {
            // Provider的作用就是push一个target
            // 如果没有任何初始化代码就没有target，就是个无意义的Provider
            // 但为了支持lazyPush（找到已有实例并更新），所以就需要支持无意义的Provider
            // 详见子类中的 self.init(initializer: nil)
            return
        }
        let t = Target()
        initializer(t)
        t.push()
    }
    
    /// 根据ViewModel和自定义的初始化代码创建一个Target并显示
    /// - Parameters:
    ///   - vm: 数据模型
    ///   - initializer: 自定义的初始化代码
    @discardableResult public convenience init(_ vm: ViewModel, initializer: ((_ toast: Target) -> Void)?) {
        if let id = vm.identifier, id.count > 0, let target = ToastManager.find(identifier: id).last as? Target {
            target.vm = vm
            initializer?(target)
            self.init(initializer: nil)
        } else {
            self.init { target in
                target.vm = vm
                initializer?(target)
            }
        }
    }
    
    /// 根据ViewModel创建一个Target并显示
    /// - Parameter vm: 数据模型
    @discardableResult public convenience init(_ vm: ViewModel) {
        self.init(vm, initializer: nil)
    }
    
    /// 根据文本作为数据模型创建一个Target并显示
    /// - Parameter text: 文本
    @discardableResult @objc public convenience init(_ text: String) {
        self.init(.message(text), initializer: nil)
    }
    
}

class DemoToastVC: ListVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Toast"
        
        let title = "通知条控件"
        let message = "通知条控件，用于非阻塞性事件通知。显示效果如同原生通知，默认会自动消失，可以支持手势移除，有多条通知可以平铺并列显示。"
        
        header.detailLabel.text = message
        
        ToastConfiguration.global { config in
            config.defaultDuration = 5
            config.contentViewMask { mask in
                mask.backgroundColor = .clear
                mask.effect = UIBlurEffect(style: .systemChromeMaterial)
            }
//            config.customWebImage { imageView, imageURL in
//                imageView.backgroundColor = .red
//            }
        }
        
        list.add(title: "默认布局") { section in
            section.add(title: "标题 + 正文") {
                TestToast(.title(title).message(message))
            }
            section.add(title: "防止重复") {
                TestToast(.identifier("toast").title(title).message(message).duration(2))
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    TestToast(.identifier("toast").title(title).message(message).duration(2))
                }
            }
            section.add(title: "一段长文本") {
                // Toast(.message(message))
                // 可以简写成这样：
                Toast(message)
            }
            section.add(title: "图标 + 标题 + 正文") {
                let s1 = "笑容正在加载"
                let s2 = "这通常不会太久"
                let toast = ToastTarget(.loading.title(s1).message(s2))
                toast.push()
                updateProgress(in: 4) { percent in
                    toast.vm?.progress(percent)
                } completion: {
                    toast.vm(
                        .success(5)
                        .title("加载成功")
                        .message("这条通知5s后消失")
                        .icon(.init(named: "twemoji"))
                    )
                }
            }
            section.add(title: "倒计时") {
                let s1 = "笑容正在消失"
                let s2 = "这通常不会太久"
                Toast(.title(s1).message(s2).icon(UIImage(named: "twemoji"))) { toast in
                    updateProgress(in: 5) { percent in
                        toast.vm?.progress(1 - percent)
                    } completion: {
                        toast.pop()
                    }
                }
            }
            section.add(title: "图标 + 一段长文本") {
                Toast(.note.message(message).duration(1))
            }
            section.add(title: "网络图标 + 一段文本") {
                Toast(.message("这是网络图标").icon(.init(string: "https://xaoxuu.com/assets/xaoxuu/avatar/rect-256@2x.png")))
            }
        }
        
        list.add(title: "事件管理") { section in
            section.add(title: "点击事件") {
                let title = "您收到了一条消息"
                let message = "点击通知横幅任意处即可回复"
                Toast(.msg.title(title).message(message)) { toast in
                    toast.onTapped { toast in
                        toast.pop()
                        Alert(.success(1).message("操作成功"))
                    }
                }
            }
            section.add(title: "增加按钮") {
                let title = "您收到了一条好友申请"
                let message = "丹妮莉丝·坦格利安申请添加您为好友，是否同意？"
                Toast(.title(title).message(message).icon(.init(named: "avatar")).duration(.infinity)) { toast in
                    toast.isRemovable = false
                    toast.imageView.layer.masksToBounds = true
                    toast.imageView.layer.cornerRadius = 44 / 2
                    toast.add(action: "拒绝", style: .destructive) { toast in
                        Alert(.identifier("Dracarys")) { alert in
                            alert.vm = .message("Dracarys")
                                .icon(UIImage(inProHUD: "prohud.windmill"))
                                .rotation(.init(repeatCount: .infinity))
                            alert.config.enableShadow = false
                            alert.config.contentViewMask { mask in
                                mask.effect = .none
                                mask.backgroundColor = .clear
                            }
                            alert.config.backgroundViewMask { mask in
                                mask.backgroundColor = .systemRed
                            }
                            alert.config.iconSize = .init(width: 64, height: 64)
                            alert.config.dynamicTextColor = .white
                            alert.config.customBodyLabel { label in
                                label.font = .init(name: "Papyrus", size: 40)
                            }
                        }
                    }
                    toast.add(action: "同意") { toast in
                        AlertManager.find(identifier: "Dracarys", update: { alert in
                            alert.pop()
                        })
                        toast.pop()
                        Alert(.success(1).message("Good choice!"))
                    }
                    ToastManager.find(identifier: "loading") { toast in
                        toast.vm = .success(2).message("加载成功")
                    }
                }
            }
            
            section.add(title: "禁止手势移除") {
                let title = "这条消息很重要"
                let message = "向上滑动将不会移除消息，您必须手动处理，用于重要但非阻塞性的事件。（通过代码处理或者在点击事件处理）"
                Toast(.warning.title(title).message(message).duration(.infinity)) { toast in
                    toast.isRemovable = false
                    toast.onTapped { toast in
                        toast.pop()
                        testAlert()
                    }
                }
            }
        }
        
        list.add(title: "实例管理") { section in
            var i = 0
            section.add(title: "多实例共存") {
                Toast(.loading.title("多实例共存").message("直接创建的实例，以平铺方式排列").duration(2)) { toast in
                    
                }
            }
            section.add(title: "不存在就创建，存在就更新") {
                i += 1
                Toast(.identifier("loading").title("正在加载\(i)").message("这条消息\n不会重复显示多条"))
            }
            section.add(title: "如果存在就更新，如果不存在就忽略") {
                i += 1
                ToastManager.find(identifier: "loading") { toast in
                    toast.vm = .success.title("加载完成\(i)").message("这条消息不会重复显示多条").duration(2)
                }
            }
            section.add(title: "移除指定实例") {
                ToastManager.find(identifier: "loading") { toast in
                    toast.pop()
                }
            }
        }
        
        list.add(title: "自定义视图") { section in
            section.add(title: "图片") {
                Toast { toast in
                    toast.config.cardMaxHeight = 200 // 自定义视图时需手动指定高度
                    let imgv = UIImageView(image: UIImage(named: "landscape"))
                    imgv.contentMode = .scaleAspectFill
                    toast.add(subview: imgv).snp.makeConstraints { make in
                        make.edges.equalToSuperview()
                    }
                    toast.onTapped { toast in
                        toast.pop()
                    }
                }
            }
            section.add(title: "修改内边距") {
                Toast(.message("这条toast的内边距经过自定义设置，与其它的有所不同。")) { toast in
                    toast.config.cardEdgeInsets = .init(top: 40, left: 32, bottom: 40, right: 32)
                }
            }
            section.add(title: "修改左右外边距") {
                Toast(.message("这条toast的左右外边距经过自定义设置，与其它的有所不同。")) { toast in
                    toast.config.marginX = 32
                    toast.config.cardCornerRadius = 24
                }
            }
            section.add(title: "圆角半径") {
                func foo() {
                    Toast { toast in
                        toast.vm = .title("圆角半径").message("可以在共享配置中设置，则全局生效")
                        toast.add(action: "8", style: .gray) { toast in
                            ToastConfiguration.global { config in
                                config.cardCornerRadius = 8
                            }
                            toast.pop()
                            foo()
                        }
                        toast.add(action: "16", style: .gray) { toast in
                            ToastConfiguration.global { config in
                                config.cardCornerRadius = 16
                            }
                            toast.pop()
                            foo()
                        }
                        toast.add(action: "24", style: .gray) { toast in
                            ToastConfiguration.global { config in
                                config.cardCornerRadius = 24
                            }
                            toast.pop()
                            foo()
                        }
                        toast.add(action: "32", style: .gray) { toast in
                            ToastConfiguration.global { config in
                                config.cardCornerRadius = 32
                            }
                            toast.pop()
                            foo()
                        }
                    }
                }
                foo()
            }
            
            section.add(title: "其它控件") {
                Toast { toast in
                    toast.config.cardMaxHeight = 200 // 自定义视图时需手动指定高度
                    
                    let stack = UIStackView()
                    stack.axis = .vertical
                    stack.distribution = .fill
                    stack.spacing = 8
                    stack.alignment = .fill
                    
                    let lb = UILabel()
                    lb.font = .systemFont(ofSize: 20, weight: .bold)
                    lb.text = "Custom Toast"
                    lb.textAlignment = .center
                    stack.addArrangedSubview(lb)
                    
                    let btn1 = ProHUD.ToastButton(config: toast.config, action: .init(style: .gray, title: "取消"))
                    btn1.onTouchUpInside { action in
                        print("点击了取消")
                        testAlert()
                    }
                    let btn2 = ProHUD.ToastButton(config: toast.config, action: .init(style: .tinted, title: "确定"))
                    btn2.onTouchUp { action in
                        print("点击了确定")
                        testAlert()
                    }
                    let actions = UIStackView(arrangedSubviews: [btn1, btn2])
                    actions.axis = .horizontal
                    actions.distribution = .fillEqually
                    actions.spacing = 8
                    actions.alignment = .fill
                    
                    stack.addArrangedSubview(actions)
                    actions.snp.makeConstraints { make in
                        make.height.equalTo(40)
                    }
                    
                    toast.add(subview: stack).snp.makeConstraints { make in
                        make.edges.equalToSuperview().inset(8)
                    }
                    toast.onTapped { toast in
                        toast.pop()
                    }
                }
            }
            
            section.add(title: "卡片背景样式") {
                Toast { toast in
                    toast.title = "卡片背景样式"
                    toast.add(action: "浅色毛玻璃") { toast in
                        toast.contentMaskView.effect = UIBlurEffect(style: .light)
                        toast.contentMaskView.backgroundColor = .clear
                    }
                    toast.add(action: "深色毛玻璃") { toast in
                        toast.contentMaskView.effect = UIBlurEffect(style: .dark)
                        toast.contentMaskView.backgroundColor = .clear
                    }
                    toast.add(action: "纯色") { toast in
                        toast.contentMaskView.effect = .none
                        toast.contentMaskView.backgroundColor = .red
                    }
                }
                
            }
            
            section.add(title: "共享配置") {
                func foo() {
                    Toast { toast in
                        toast.title = "共享配置"
                        toast.vm?.message = "建议在App启动后进行通用配置设置，所有实例都会先拉取通用配置为默认值，修改这些配置会影响到所有实例。"
                        toast.add(action: "默认", style: .gray) { toast in
                            ToastConfiguration.global { config in
                                config.customTitleLabel { titleLabel in
                                    titleLabel.font = .systemFont(ofSize: 19, weight: .bold)
                                }
                            }
                            toast.pop()
                            foo()
                        }
                        toast.add(action: "大号标题") { toast in
                            ToastConfiguration.global { config in
                                config.customTitleLabel { titleLabel in
                                    titleLabel.font = .systemFont(ofSize: 28, weight: .medium)
                                }
                            }
                            toast.pop()
                            foo()
                        }
                    }
                }
                foo()
            }
            
        }
        
    }

}

fileprivate func testAlert() {
    Alert { alert in
        alert.title = "处理点击事件"
        alert.add(action: "我知道了", style: .destructive)
    }
}
