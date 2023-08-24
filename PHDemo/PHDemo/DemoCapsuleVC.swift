//
//  DemoCapsuleVC.swift
//  PHDemo
//
//  Created by xaoxuu on 2022/9/3.
//

import UIKit
import ProHUD

class DemoCapsuleVC: ListVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Capsule"
        header.detailLabel.text = "状态胶囊控件，用于状态显示，一个主程序窗口每个位置（上中下）各自最多只有一个状态胶囊实例。"
        
        CapsuleConfiguration.global { config in
            config.defaultDuration = 3 // 默认的持续时间
//            config.cardCornerRadius = .infinity // 设置一个较大的数字就会变成胶囊形状
        }
        list.add(title: "默认布局：纯文字") { section in
            section.add(title: "一条简短的消息") {
                // 设置vm或者handler都会自动push，这里测试传入vm：
                // Capsule(.message("一条简短消息"))
                // 如果只有一条文字信息，可以直接传字符串：
                Capsule("成功")
            }
            section.add(title: "一条稍微长一点的消息") {
                // 设置vm或者handler都会自动push，这里测试传入handler：
                Capsule { capsule in
                    // handler中可以进行复杂设置（详见下面的其它例子）
                    capsule.vm = .message("一条稍微长一点的消息")
                }
            }
            section.add(title: "延迟显示") {
                // 也可以手动创建一个Target实例，在需要的时候再push
                let obj = CapsuleTarget(.message("状态胶囊控件，用于状态显示，一个主程序窗口只有一个状态胶囊实例。"))
                // ... 在需要的时候手动push
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    obj.push()
                }
            }
            section.add(title: "（限制1行）状态胶囊控件，用于状态显示，一个主程序窗口只有一个状态胶囊实例。") {
                // 同时设置vm和handler也可以
                Capsule(.message("状态胶囊控件，用于状态显示，一个主程序窗口只有一个状态胶囊实例。")) { capsule in
                    capsule.config.customTextLabel { label in
                        label.numberOfLines = 1
                    }
                }
            }
        }
        
        list.add(title: "默认布局：图文") { section in
            section.add(title: "短的消息") {
                Capsule(.icon(.init(inProHUD: "prohud.rainbow.ring")).title("loading").rotation(.infinity))
            }
            section.add(title: "下载进度") {
                let capsule = CapsuleTarget()
                capsule.vm = .loading(.infinity).message("正在下载")
                capsule.update(progress: 0)
                capsule.push()
                updateProgress(in: 4) { percent in
                    capsule.update(progress: percent)
                } completion: {
                    capsule.update { toast in
                        toast.vm = .success(5).message("下载成功")
                    }
                }
            }
            section.add(title: "接口报错提示") {
                Capsule(.systemError.title("[500]").message("服务端错误"))
            }
            section.add(title: "（默认）状态胶囊控件，用于状态显示，一个主程序窗口只有一个状态胶囊实例。") {
                Capsule(.info("状态胶囊控件，用于状态显示，一个主程序窗口只有一个状态胶囊实例。"))
            }
            section.add(title: "（限制1行）状态胶囊控件，用于状态显示，一个主程序窗口只有一个状态胶囊实例。") {
                Capsule(.info("状态胶囊控件，用于状态显示，一个主程序窗口只有一个状态胶囊实例。")) { capsule in
                    capsule.config.customTextLabel { label in
                        label.numberOfLines = 1
                    }
                }
            }
        }
        
        list.add(title: "不同位置、不同动画") { section in
            section.add(title: "顶部，默认动画") {
                Capsule(.info("一条简短的消息").duration(1))
            }
            section.add(title: "中间，默认动画") {
                Capsule(.middle.info("一条简短的消息").duration(1))
            }
            section.add(title: "中间，黑底白字，透明渐变") {
                Capsule(.middle.info("一条简短的消息").duration(1)) { capsule in
                    capsule.config.tintColor = .white
                    capsule.config.cardCornerRadius = 8
                    capsule.config.contentViewMask { mask in
                        mask.layer.backgroundColor = UIColor.black.withAlphaComponent(0.75).cgColor
                    }
                    capsule.config.customTextLabel { label in
                        label.textColor = .white
                    }
                    capsule.config.animateBuildIn { window, completion in
                        window.alpha = 0
                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5) {
                            window.alpha = 1
                        } completion: { done in
                            completion()
                        }
                    }
                    capsule.config.animateBuildOut { window, completion in
                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5) {
                            window.alpha = 0
                        } completion: { done in
                            completion()
                        }
                    }
                }
            }
            section.add(title: "底部，渐变背景，默认回弹滑入") {
                Capsule(.bottom.enter("点击进入").duration(2)) { capsule in
                    capsule.config.tintColor = .white
                    capsule.config.cardEdgeInsets = .init(top: 12, left: 20, bottom: 12, right: 20)
                    capsule.config.customTextLabel { label in
                        label.textColor = .white
                        label.font = .boldSystemFont(ofSize: 16)
                    }
                    capsule.config.contentViewMask { [weak capsule] mask in
                        mask.effect = .none
                        mask.backgroundColor = .clear
                        let gradientLayer = CAGradientLayer()
                        if let f = capsule?.view.bounds {
                            gradientLayer.frame = f
                        } else {
                            gradientLayer.frame = .init(x: 0, y: 0, width: 300, height: 100)
                        }
                        gradientLayer.colors = [UIColor("#0091FF").cgColor, UIColor("#00FDFF").cgColor]
                        gradientLayer.startPoint = .init(x: 0.2, y: 0.6)
                        gradientLayer.endPoint = .init(x: 0.6, y: 0.2)
                        mask.layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
                        mask.layer.insertSublayer(gradientLayer, at: 0)
                    }
                    capsule.config.cardCornerRadius = .infinity
                    capsule.onTapped { capsule in
                        Alert(.message("收到点击事件").duration(1))
                        capsule.pop()
                    }
                }
            }
        }
        list.add(title: "自定义子类，队列推送") { section in
            section.add(title: "视频采集，title:开") {
                GradientCapsule(.videoRecord(on: true, text: "视频采集：开"))
            }
            section.add(title: "视频推流，title:开") {
                GradientCapsule(.videoPush(on: true, text: "视频推流：开"))
            }
            section.add(title: "音频采集，title:开") {
                GradientCapsule(.audioRecord(on: true, text: "音频采集：开"))
            }
            section.add(title: "音频推流，title:开") {
                GradientCapsule(.audioPush(on: true, text: "音频推流：开"))
            }
            
            section.add(title: "视频采集，title:关") {
                GradientCapsule(.videoRecord(on: false, text: "视频采集：关"))
            }
            section.add(title: "视频推流，title:关") {
                GradientCapsule(.videoPush(on: false, text: "视频推流：关"))
            }
            section.add(title: "音频采集，title:关") {
                GradientCapsule(.audioRecord(on: false, text: "音频采集：关"))
            }
            section.add(title: "音频推流，title:关") {
                GradientCapsule(.audioPush(on: false, text: "音频推流：关"))
            }
        }
        
        var i = 0
        list.add(title: "lazy push") { section in
            section.add(title: "以当前代码位置作为唯一标识符") {
                i += 1
                Capsule(.identifier().message("id=\(i)"))
            }
            section.add(title: "指定id=a, haha") {
                Capsule(.identifier("a").message("id=a, haha"))
            }
            section.add(title: "指定id=a, hahahahahaha") {
                Capsule(.identifier("a").message("id=a, hahahahahaha"))
            }
        }
        
        list.add(title: "网络图片") { section in
            section.add(title: "设置iconSize以修改默认约束尺寸") {
                Capsule(.icon("https://xaoxuu.com/assets/wiki/prohud/icon.png").title("ProHUD").duration(5)) { capsule in
                    capsule.config.iconSize = .init(width: 24, height: 24)
                }
            }
        }
        
    }

}

class GradientCapsuleTarget: CapsuleTarget {
    
    override var config: CapsuleConfiguration {
        get { customConfig }
        set { customConfig = newValue}
    }
    
    private lazy var customConfig: CapsuleConfiguration = {
        let cfg = CapsuleConfiguration()
        cfg.tintColor = .white
        cfg.customTextLabel { label in
            label.textColor = .white
        }
        cfg.contentViewMask { [weak self] mask in
            mask.effect = .none
            mask.backgroundColor = .clear
            let gradientLayer = CAGradientLayer()
            if let f = self?.view.bounds {
                gradientLayer.frame = f
            } else {
                gradientLayer.frame = .init(x: 0, y: 0, width: 300, height: 100)
            }
            gradientLayer.colors = [UIColor.systemGreen.cgColor, UIColor("#B6F598").cgColor]
            gradientLayer.startPoint = .init(x: 0.2, y: 0.6)
            gradientLayer.endPoint = .init(x: 0.6, y: 0.2)
            mask.layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
            mask.layer.insertSublayer(gradientLayer, at: 0)
            self?.gradientLayer = gradientLayer
        }
        return cfg
    }()
    
    var gradientLayer: CAGradientLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let id = vm?.identifier ?? ""
        if id.contains("video") == true {
            if id.contains(":true") {
                gradientLayer?.colors = [UIColor("#7EF19B").cgColor, UIColor.systemGreen.cgColor]
            } else {
                gradientLayer?.colors = [UIColor("#1A7531").cgColor, UIColor("#2A5133").cgColor]
            }
        } else {
            if id.contains(":true") {
                gradientLayer?.colors = [UIColor("#FFC470").cgColor, UIColor.systemOrange.cgColor]
            } else {
                gradientLayer?.colors = [UIColor("#8F5300").cgColor, UIColor("#51412A").cgColor]
            }
        }
        
    }
}

class GradientCapsule: HUDProviderType {
    
    public typealias ViewModel = CapsuleViewModel
    public typealias Target = GradientCapsuleTarget
    
    /// 根据自定义的初始化代码创建一个Target并显示
    /// - Parameter initializer: 初始化代码（传空值时不会做任何事）
    @discardableResult required init(initializer: ((_ target: Target) -> Void)?) {
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
    ///   - initializer: 初始化代码
    @discardableResult public convenience init(_ vm: ViewModel, initializer: ((_ capsule: Target) -> Void)?) {
        if let id = vm.identifier, id.count > 0, let target = CapsuleManager.find(identifier: id).last as? Target {
            target.update { capsule in
                capsule.vm = vm
                initializer?(capsule as! GradientCapsule.Target)
            }
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
    @discardableResult public convenience init(_ text: String) {
        self.init(.message(text), initializer: nil)
    }
    
}

extension CapsuleViewModel {
    
    static func info(_ text: String?) -> Self {
        .init()
        .info(text)
    }
    
    func info(_ text: String?) -> Self {
        self.message(text)
        .icon(.init(systemName: "info.circle.fill"))
//        .duration(2)
    }
    
    func enter(_ text: String?) -> Self {
        self.message(text)
        .icon(.init(systemName: "arrow.right.circle.fill"))
//        .duration(.infinity)
    }
    
    static var systemError: Self {
        .init()
        .icon(.init(systemName: "xmark.circle.fill"))
        .tintColor(.systemRed)
    }
    static func systemError(_ text: String?) -> Self {
        .systemError
        .message(text)
    }
    
    static func videoRecord(on: Bool, text: String) -> CapsuleViewModel {
        .middle
        .identifier("video.record:\(on)")
        .icon(.init(systemName: on ? "video.fill" : "video.slash.fill"))
        .duration(0.5)
        .queuedPush(true)
        .message(text)
    }
    
    static func audioRecord(on: Bool, text: String) -> CapsuleViewModel {
        .middle
        .identifier("audio.record:\(on)")
        .icon(.init(systemName: on ? "mic.fill" : "mic.slash.fill"))
        .duration(0.5)
        .queuedPush(true)
        .message(text)
    }
    
    
    static func videoPush(on: Bool, text: String) -> CapsuleViewModel {
        .middle
        .identifier("video.push:\(on)")
        .icon(.init(systemName: on ? "icloud.fill" : "icloud.slash.fill"))
        .duration(0.5)
        .queuedPush(true)
        .message(text)
    }
    
    static func audioPush(on: Bool, text: String) -> CapsuleViewModel {
        .middle
        .identifier("audio.push:\(on)")
        .icon(.init(systemName: on ? "icloud.fill" : "icloud.slash.fill"))
        .duration(0.5)
        .queuedPush(true)
        .message(text)
    }
}
