//
//  AlertModel.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/29.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

public extension ProHUD.Alert {
    enum Scene {
        /// 默认场景
        case `default`
        
        /// 加载中场景
        case loading
        
        /// 确认场景
        case confirm
        
        /// 删除场景
        case delete
        
        /// 成功场景
        case success
        
        /// 警告场景
        case warning
        
        /// 错误场景
        case error
        
    }
    
    struct ViewModel {
        
        /// 使用场景
        public var scene = Scene.default
        
        /// 标题
        public var title: String?
        
        /// 正文
        public var message: String?
        
        /// 图标
        public var icon: UIImage?
        
        /// 持续时间
        internal var duration: TimeInterval?
        
        /// 持续时间
        internal var durationBlock: DispatchWorkItem?
        
        /// 强制退出按钮
        internal var forceQuitTimerBlock: DispatchWorkItem?
        
        /// 强制退出代码
        internal var forceQuitCallback: (() -> Void)?
        
        internal var willLayoutBlock: DispatchWorkItem?
        
        internal mutating func setupDuration(duration: TimeInterval?, callback: @escaping () -> Void) {
            self.duration = duration
            durationBlock?.cancel()
            if let t = duration, t > 0 {
                durationBlock = DispatchWorkItem(block: callback)
                DispatchQueue.main.asyncAfter(deadline: .now()+t, execute: durationBlock!)
            } else {
                durationBlock = nil
            }
        }
        
        internal mutating func setupForceQuit(duration: TimeInterval?, callback: @escaping () -> Void) {
            forceQuitTimerBlock?.cancel()
            if let t = duration, t > 0 {
                forceQuitTimerBlock = DispatchWorkItem(block: callback)
                DispatchQueue.main.asyncAfter(deadline: .now()+t, execute: forceQuitTimerBlock!)
            } else {
                forceQuitTimerBlock = nil
            }
        }
        
        internal mutating func setupWillLayout(duration: TimeInterval?, callback: @escaping () -> Void) {
            willLayoutBlock?.cancel()
            if let t = duration, t > 0 {
                willLayoutBlock = DispatchWorkItem(block: callback)
                DispatchQueue.main.asyncAfter(deadline: .now()+t, execute: willLayoutBlock!)
            } else {
                willLayoutBlock = nil
            }
        }
        
    }
    
}

