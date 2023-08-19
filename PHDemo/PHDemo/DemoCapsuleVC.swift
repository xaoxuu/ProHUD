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
                Capsule("一条简短消息")
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
            section.add(title: "下载进度") {
                let capsule = CapsuleTarget()
                capsule.vm = .message("正在下载").icon(.init(systemName: "arrow.down.circle.fill")).duration(.infinity)
                capsule.update(progress: 0)
                capsule.push()
                updateProgress(in: 4) { percent in
                    capsule.update(progress: percent)
                } completion: {
                    capsule.update { toast in
                        toast.vm = .message("下载成功")
                            .icon(.init(systemName: "checkmark.circle.fill"))
                            .duration(5)
                            .tintColor(.systemGreen)
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
            section.add(title: "顶部，默认滑入") {
                Capsule(.info("一条简短的消息"))
            }
            section.add(title: "中间，默认缩放") {
                Capsule(.middle.info("一条简短的消息"))
            }
            section.add(title: "中间，黑底白字，透明渐变") {
                Capsule(.middle.info("一条简短的消息")) { capsule in
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
                Capsule(.bottom.enter("点击进入")) { capsule in
                    capsule.config.tintColor = .white
                    capsule.config.cardEdgeInsets = .init(top: 12, left: 20, bottom: 12, right: 20)
                    capsule.config.customTextLabel { label in
                        label.textColor = .white
                        label.font = .boldSystemFont(ofSize: 16)
                    }
                    capsule.config.contentViewMask { mask in
                        mask.effect = .none
                        mask.backgroundColor = .clear
                        let gradientLayer = CAGradientLayer()
                        gradientLayer.frame = self.view.bounds
                        gradientLayer.colors = [UIColor("#0091FF").cgColor, UIColor("#00FDFF").cgColor]
                        gradientLayer.startPoint = .init(x: 0.2, y: 0.6)
                        gradientLayer.endPoint = .init(x: 0.6, y: 0.2)
                        gradientLayer.frame = .init(x: 0, y: 0, width: 300, height: 100)
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
    
}
