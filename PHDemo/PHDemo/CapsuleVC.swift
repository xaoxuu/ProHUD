//
//  CapsuleVC.swift
//  PHDemo
//
//  Created by xaoxuu on 2022/9/3.
//

import UIKit
import ProHUD

class CapsuleVC: ListVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Capsule"
        header.detailLabel.text = "状态胶囊控件，用于状态显示，一个主程序窗口每个位置（上中下）各自最多只有一个状态胶囊实例。"
        
        Capsule.Configuration.shared { config in
//            config.cardCornerRadius = .infinity // 设置一个较大的数字就会变成胶囊形状
        }
        list.add(title: "默认布局：纯文字") { section in
            section.add(title: "一条简短的消息") {
                Capsule(.message("一条简短的消息")).push()
            }
            section.add(title: "一条稍微长一点的消息") {
                Capsule(.message("一条稍微长一点的消息")).push()
            }
            section.add(title: "（默认）状态胶囊控件，用于状态显示，一个主程序窗口只有一个状态胶囊实例。") {
                Capsule(.message("状态胶囊控件，用于状态显示，一个主程序窗口只有一个状态胶囊实例。")).push()
            }
            section.add(title: "（限制1行）状态胶囊控件，用于状态显示，一个主程序窗口只有一个状态胶囊实例。") {
                Capsule(.message("状态胶囊控件，用于状态显示，一个主程序窗口只有一个状态胶囊实例。")) { capsule in
                    capsule.config.customTextLabel { label in
                        label.numberOfLines = 1
                    }
                }
            }
        }
        
        list.add(title: "默认布局：图文") { section in
            section.add(title: "一条简短的消息") {
                Capsule(.info("一条简短的消息")).push()
            }
            section.add(title: "一条稍微长一点的消息") {
                Capsule(.info("一条稍微长一点的消息")).push()
            }
            section.add(title: "（默认）状态胶囊控件，用于状态显示，一个主程序窗口只有一个状态胶囊实例。") {
                Capsule(.info("状态胶囊控件，用于状态显示，一个主程序窗口只有一个状态胶囊实例。")).push()
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
            section.add(title: "顶部，缩放") {
                Capsule(.info("一条简短的消息")) { capsule in
                    capsule.config.animateBuildIn { window, completion in
                        let duration = 1.0
                        let d0 = duration * 0.2
                        let d1 = duration
                        window.transform = .init(scaleX: 0.001, y: 0.001)
                        window.alpha = 0
                        UIView.animate(withDuration: d0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5) {
                            window.transform = .init(scaleX: 0.01, y: 0.5)
                        }
                        UIView.animate(withDuration: d1, delay: d0 * 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
                            window.transform = .identity
                        } completion: { done in
                            completion()
                        }
                        UIView.animate(withDuration: duration * 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1) {
                            window.alpha = 1
                        }
                    }
                    capsule.config.animateBuildOut { window, completion in
                        let duration = 0.8
                        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1) {
                            window.transform = .init(scaleX: 0.0001, y: 0.5)
                        } completion: { done in
                            completion()
                        }
                        UIView.animate(withDuration: duration * 0.6, delay: duration * 0.4, usingSpringWithDamping: 1, initialSpringVelocity: 1) {
                            window.alpha = 0
                        }
                    }
                }
            }
            section.add(title: "中间，黑底白字，透明渐变") {
                Capsule(.middle.info("一条简短的消息")) { capsule in
                    capsule.config.tintColor = .white
                    capsule.config.cardCornerRadius = 4
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
            section.add(title: "底部，渐变背景，回弹滑入") {
                Capsule(.bottom.enter("点击进入")) { capsule in
                    capsule.config.tintColor = .white
                    capsule.config.customTextLabel { label in
                        label.textColor = .white
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
                    capsule.config.animateBuildIn { window, completion in
                        window.transform = .init(translationX: 0, y: 240)
                        window.alpha = 0
                        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.5) {
                            window.transform = .identity
                            window.alpha = 1
                        } completion: { done in
                            completion()
                        }
                    }
                    capsule.config.animateBuildOut { window, completion in
                        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5) {
                            window.transform = .init(translationX: 0, y: 240)
                            window.alpha = 0
                        } completion: { done in
                            completion()
                        }
                    }
                }.onTapped { capsule in
                    Alert(.message("收到点击事件").duration(1)).push()
                    capsule.pop()
                }
            }
        }
    }

}

extension Capsule.CapsuleViewModel {
    
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
        .duration(.infinity)
    }
    
}
