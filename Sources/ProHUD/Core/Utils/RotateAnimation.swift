//
//  File.swift
//  
//
//  Created by xaoxuu on 2022/8/29.
//

import UIKit

extension LoadingAnimation {
    
    /// 旋转动画
    /// - Parameters:
    ///   - layer: 图层
    ///   - direction: 方向
    ///   - speed: 速度
    func startRotate(_ rotate: Rotation, at layer: CALayer? = nil) {
        DispatchQueue.main.async {
            let l = layer ?? self.imageView.layer
            self.animateLayer = l
            l.startRotate(rotate)
            NotificationCenter.default.addObserver(self, selector: #selector(self.pauseLoadingAnimation), name: UIApplication.didEnterBackgroundNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.resumeLoadingAnimation), name: UIApplication.willEnterForegroundNotification, object: nil)
        }
    }
    
    /// 停止旋转
    /// - Parameter layer: 图层
    func stopRotate(_ layer: CALayer? = nil) {
        DispatchQueue.main.async {
            self.animateLayer = nil
            (layer ?? self.imageView.layer)?.stopRotate()
            NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        }
    }
    
}

/// 动画扩展
extension BaseController {
    @objc func pauseLoadingAnimation() {
        if let layer = animateLayer {
            animation = layer.animation(forKey: .rotateKey)
            layer.timeOffset = layer.convertTime(CACurrentMediaTime(), from: nil)
            layer.speed = 0
        }
    }
    @objc func resumeLoadingAnimation() {
        if let layer = animateLayer, let ani = animation, layer.speed == 0 {
            let pauseTime = layer.timeOffset
            layer.timeOffset = 0
            let beginTime = layer.convertTime(CACurrentMediaTime(), from: nil) - pauseTime
            layer.beginTime = beginTime
            layer.speed = 1
            layer.add(ani, forKey: .rotateKey)
        }
    }
}

