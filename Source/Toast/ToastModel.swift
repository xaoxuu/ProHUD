//
//  ToastModel.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/31.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit

public extension Toast {
    class ViewModel {
        
        /// 使用场景
        public var scene = ProHUD.Scene.default
        
        /// 标题
        public var title: String? {
            didSet {
                vc?.titleLabel.text = title
            }
        }
        
        /// 正文
        public var message: String? {
            didSet {
                vc?.bodyLabel.text = message
            }
        }
        
        /// 图标
        public var icon: UIImage? {
            didSet {
                vc?.imageView.image = icon
            }
        }
        
        /// 持续时间
        public var duration: TimeInterval? {
            didSet {
                updateDuration()
            }
        }
        
        public weak var vc: Toast?
        
        // MARK: 私有
        
        /// 持续时间
        var durationBlock: DispatchWorkItem?
        
        /// 点击事件回调
        var tapCallback: (() -> Void)?
        
        func updateDuration() {
            durationBlock?.cancel()
            if let t = duration ?? scene.toastDuration, t > 0 {
                durationBlock = DispatchWorkItem(block: { [weak self] in
                    if let vc = self?.vc {
                        if vc.buttonEvents.count == 0 {
                            vc.pop()
                        }
                    }
                })
                DispatchQueue.main.asyncAfter(deadline: .now()+t, execute: durationBlock!)
            } else {
                durationBlock = nil
            }
        }
        
    }
}
